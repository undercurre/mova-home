package android.dreame.module.rn.load;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.dreame.module.R;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.manager.DebugManager;
import android.dreame.module.rn.data.PluginDataInfo;
import android.dreame.module.rn.utils.FileUtils;
import android.dreame.module.util.DarkThemeUtils;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.toast.ToastUtils;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.facebook.infer.annotation.Assertions;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.NativeModuleCallExceptionHandler;
import com.facebook.react.devsupport.DoubleTapReloadRecognizer;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.modules.core.PermissionListener;

import java.io.File;
import java.lang.reflect.Field;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/04/26
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class ReactActivityDelegate {

    private final String TAG = "ReactActivityDelegate";

    private RnActivity mActivity;
    private PermissionListener mPermissionListener;
    private Callback mPermissionsCallback;
    private DoubleTapReloadRecognizer mDoubleTapReloadRecognizer;
    private Handler uiThreadHandler = new Handler(Looper.getMainLooper());
    private ReactRootView mRootView;


    public ReactActivityDelegate(RnActivity activity) {
        mActivity = activity;
        this.mDoubleTapReloadRecognizer = new DoubleTapReloadRecognizer();
    }


    protected @Nullable
    Bundle getLaunchOptions() {
        return mActivity.getLaunchOptions();
    }

    /**
     * 读取缓存或者创建BasicRNHost
     *
     * @return
     */
    protected synchronized BasicRNHost getReactNativeHost(boolean clearCache) {
        DeviceListBean.Device device = mActivity.getDevice();
        if (device == null) {
            LogUtil.e("ReactActivityDelegate getReactNativeHost: device == null");
            mActivity.finish();
            return null;
        } else {
            BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(device.getDid());
            if (basicRNHost != null) {
                // 如果深色或者亮色变了，则切颜色
                String themeMode = DarkThemeUtils.getThemeSettingString(mActivity);
                if (!themeMode.equals(basicRNHost.getThemeMode())) {
                    basicRNHost = null;
                    RnLoaderCache.removeRnHost(device.getDid());
                }
            }
            // 如果缓存的RNHost不是当前设备的RNHost，清除缓存
            if (basicRNHost != null && clearCache) {
                DeviceListBean.Device hostBindedDevice = basicRNHost.getRNHostBindedDevice();
                if (!hostBindedDevice.getMasterUid().equals(device.getMasterUid())) {
                    LogUtil.e("ReactActivityDelegate getReactNativeHost: hostBindedDevice.getMasterUid() != device.getMasterUid()");
                    basicRNHost = null;
                    RnLoaderCache.removeRnHost(device.getDid());
                }
            }
            if (basicRNHost == null) {
                String themeMode = DarkThemeUtils.getThemeSettingString(mActivity);
                LogUtil.i(TAG, "getReactNativeHost: basicRNHost == null");
                basicRNHost = new BasicRNHost(
                        mActivity.getDevice(),
                        themeMode,
                        mActivity.getSdkBundleFileInfo(),
                        mActivity.getPluginFileInfo());
                RnLoaderCache.cacheReactNativeHost(device.getDid(), basicRNHost);
            }
            return basicRNHost;
        }
    }

    public BasicRNHost getCurrentReactNativeHost() {
        return getReactNativeHost(false);
    }

    public ReactInstanceManager getReactInstanceManager() {
        return getCurrentReactNativeHost().getReactInstanceManager();
    }

    public String getMainComponentName() {
        return "";
    }

    protected void onCreate(Bundle savedInstanceState) {
        if (checkSDKAndPlugin()) {
            LogUtil.i(TAG, "onCreate getReactNativeHost");
            getReactNativeHost(true).setNativeModuleCallExceptionHandler(new NativeModuleCallExceptionHandler() {
                @Override
                public void handleException(Exception e) {
                    mActivity.runOnUiThread(() -> {
                        e.printStackTrace();
                        RnLoaderCache.removeRnHost(mActivity.getDevice().getDid());
                        ToastUtils.show(mActivity.getString(R.string.Popup_DevicePage_PluginLoading_Failed));
                        LogUtil.e("ReactActivityDelegate handleException: " + Log.getStackTraceString(e));
                        mActivity.finish();
                    });
                }
            });
            getCurrentReactNativeHost().createReactContext(() -> {
                LogUtil.i(TAG, "onCreate createReactContext listener " + (getReactInstanceManager().getCurrentReactContext() == null));
                if (getReactInstanceManager().getCurrentReactContext() != null) {
                    LogUtil.i(TAG, "onCreate createReactContext listener " + getReactInstanceManager().getCurrentReactContext());
                }
                RnLoaderCache.cacheDevice(getReactInstanceManager().getCurrentReactContext(), mActivity.getDevice());
                loadApp(mActivity.getDevice().getDeviceInfo().getModel());
            });
        }
    }

    private boolean checkSDKAndPlugin() {
        if (DebugManager.INSTANCE.getEnableCheckPluginMd5()) {
            if (!isPluginsValid()) {
                ToastUtils.show(mActivity.getString(R.string.Popup_DevicePage_PluginLoading_Failed));
                LogUtil.e("ReactActivityDelegate checkSDKAndPlugin isPluginsValid = false");
                mActivity.finish();
                return false;
            }
        }
        return true;
    }

    protected void loadApp(String appKey) {
        mRootView = new DmReactRootView(mActivity.getApplicationContext());
        mRootView.startReactApplication(getReactInstanceManager(), appKey, getLaunchOptions());
        LogUtil.i(TAG, "goDevicePlugin: load Rn End " + System.currentTimeMillis());
        getPlainActivity().addContentView(mRootView, new ViewGroup.LayoutParams(-1, -1));
    }

    protected void onResume() {
        final BasicRNHost currentReactNativeHost = getCurrentReactNativeHost();
        if (currentReactNativeHost.hasInstance()) {
            LogUtil.i(TAG, "onResume: currentReactNativeHost.hasInstance() " + currentReactNativeHost.getReactInstanceManager() + " mActivity:" + mActivity);
            if (mActivity != null) {
                currentReactNativeHost
                        .getReactInstanceManager()
                        .onHostResume(mActivity, (DefaultHardwareBackBtnHandler) mActivity);
            } else {
                throw new ClassCastException(
                        "Host Activity does not implement DefaultHardwareBackBtnHandler");
            }
        } else {
            LogUtil.e(TAG, "onResume: currentReactNativeHost.hasInstance() " + currentReactNativeHost);
        }
        if (mPermissionsCallback != null) {
            mPermissionsCallback.invoke();
            mPermissionsCallback = null;
        }
    }

    protected void onPause() {
        if (getCurrentReactNativeHost().hasInstance() && mActivity != null) {
            LogUtil.i(TAG, "onPause: currentReactNativeHost.hasInstance() " + getCurrentReactNativeHost().getReactInstanceManager() + " mActivity:" + mActivity);
            final ReactInstanceManager reactInstanceManager = getReactInstanceManager();
            try {
                Class<? extends ReactInstanceManager> clazz = reactInstanceManager.getClass();
                Field field = clazz.getDeclaredField("mCurrentActivity");
                field.setAccessible(true);
                Activity activity = (Activity) field.get(reactInstanceManager);
                field.setAccessible(false);
                if (activity != null) {
                    reactInstanceManager.onHostPause(activity);
                } else {
                    reactInstanceManager.onHostPause();
                }
            } catch (Exception e) {
                e.printStackTrace();
                LogUtil.e(Log.getStackTraceString(e));
            }

        }
    }

    protected void onDestroy() {
        if (mRootView != null) {
            mRootView.unmountReactApplication();
            ((ViewGroup) mRootView.getParent()).removeView(mRootView);
            mRootView = null;
        }
        final BasicRNHost currentReactNativeHost = getCurrentReactNativeHost();
        if(currentReactNativeHost != null){
            currentReactNativeHost.removeNativeModuleCallExceptionHandler();
            if (currentReactNativeHost.hasInstance()) {
                getReactInstanceManager().onHostDestroy(mActivity);
            }
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (this.getCurrentReactNativeHost().hasInstance()) {
            getReactInstanceManager().onActivityResult(this.mActivity, requestCode, resultCode, data);
        }
    }

    public boolean onKeyDown(int keyCode, KeyEvent event) {
        final BasicRNHost currentReactNativeHost = getCurrentReactNativeHost();
        if (currentReactNativeHost.hasInstance()
                && currentReactNativeHost.getUseDeveloperSupport()
                && keyCode == KeyEvent.KEYCODE_MEDIA_FAST_FORWARD) {
            event.startTracking();
            return true;
        }
        return false;
    }

    public boolean onKeyUp(int keyCode, KeyEvent event) {
        final BasicRNHost currentReactNativeHost = this.getCurrentReactNativeHost();
        if (currentReactNativeHost.hasInstance() && currentReactNativeHost.getUseDeveloperSupport()) {
            if (keyCode == 82) {
                getReactInstanceManager().showDevOptionsDialog();
                return true;
            }

            boolean didDoubleTapR = ((DoubleTapReloadRecognizer) Assertions.assertNotNull(this.mDoubleTapReloadRecognizer)).didDoubleTapR(keyCode, this.mActivity.getCurrentFocus());
            if (didDoubleTapR) {
                getReactInstanceManager().getDevSupportManager().handleReloadJS();
                return true;
            }
        }

        return false;
    }

    public boolean onKeyLongPress(int keyCode, KeyEvent event) {
        if (getCurrentReactNativeHost().hasInstance()
                && getCurrentReactNativeHost().getUseDeveloperSupport()
                && keyCode == KeyEvent.KEYCODE_MEDIA_FAST_FORWARD) {
            getReactInstanceManager().showDevOptionsDialog();
            return true;
        }
        return false;
    }

    public boolean onBackPressed() {
        if (getCurrentReactNativeHost().hasInstance()) {
            getReactInstanceManager().onBackPressed();
            return true;
        }
        return false;
    }

    public boolean onNewIntent(Intent intent) {
        if (getCurrentReactNativeHost().hasInstance()) {
            getReactInstanceManager().onNewIntent(intent);
            return true;
        }
        return false;
    }

    public void onWindowFocusChanged(boolean hasFocus) {
        if (getCurrentReactNativeHost().hasInstance()) {
            getReactInstanceManager().onWindowFocusChange(hasFocus);
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    public void requestPermissions(
            String[] permissions, int requestCode, PermissionListener listener) {
        mPermissionListener = listener;
        getPlainActivity().requestPermissions(permissions, requestCode);
    }

    public void onRequestPermissionsResult(
            final int requestCode, final String[] permissions, final int[] grantResults) {
        mPermissionsCallback =
                new Callback() {
                    @Override
                    public void invoke(Object... args) {
                        if (mPermissionListener != null
                                && mPermissionListener.onRequestPermissionsResult(
                                requestCode, permissions, grantResults)) {
                            mPermissionListener = null;
                        }
                    }
                };
    }

    protected Context getContext() {
        return Assertions.assertNotNull(mActivity);
    }

    protected Activity getPlainActivity() {
        return ((Activity) getContext());
    }

    class DmReactRootView extends ReactRootView {
        private boolean isLoadFinished;

        public DmReactRootView(Context context) {
            super(context);
        }

        @Override
        public void onViewAdded(View child) {
            super.onViewAdded(child);
            ViewGroup viewGroup = (ViewGroup) mActivity.findViewById(android.R.id.content);
            View loading = viewGroup.findViewById(R.id.rl_loading);
            if (!isLoadFinished && loading != null) {
                isLoadFinished = true;
                viewGroup.removeView(loading);
            }
        }
    }

    private boolean isPluginsValid() {
        PluginDataInfo pluginDataInfo = mActivity.getPluginDataInfo();
        if (pluginDataInfo == null) {
            LogUtil.e(TAG, "isPluginsValid: pluginDataInfo is Null");
            return false;
        }
        LogUtil.i(TAG, "sdkInfo:" + pluginDataInfo.getSdkSize() + "-----" + pluginDataInfo.getSdkMd5() + "  " + pluginDataInfo.getSdkPath());
        LogUtil.i(TAG, "pluginInfo:" + pluginDataInfo.getPluginSize() + "-----" + pluginDataInfo.getPluginMd5() + "  " + pluginDataInfo.getPluginPath());

        // 检查文件是否存在
        String sdkBundlePath = pluginDataInfo.getSdkPath();
        if (TextUtils.isEmpty(sdkBundlePath)) {
            return false;
        }
        File sdkBundleFile = new File(sdkBundlePath);
        if (!com.blankj.utilcode.util.FileUtils.isFileExists(sdkBundlePath)) {
            LogUtil.e(TAG, "checkSDKAndPlugin: deleteFileOrFolderSilently sdkBundlePath: " + sdkBundlePath + "，，，" + sdkBundleFile.exists());
            File sdkBundleFileParentFile = sdkBundleFile.getParentFile();
            if (sdkBundleFileParentFile != null) {
                FileUtils.deleteFileOrFolderSilently(sdkBundleFileParentFile.getParentFile(), true);
            }
            return false;
        }

        String pluginBundlePath = pluginDataInfo.getPluginPath();
        if (TextUtils.isEmpty(pluginBundlePath)) {
            return false;
        }
        File pluginBundleFile = new File(pluginBundlePath);
        if (!com.blankj.utilcode.util.FileUtils.isFileExists(pluginBundlePath)) {
            LogUtil.e(TAG, "checkSDKAndPlugin: deleteFileOrFolderSilently pluginBundlePath: " + pluginBundlePath);
            File pluginBundleFileParentFile = pluginBundleFile.getParentFile();
            if (pluginBundleFileParentFile != null) {
                FileUtils.deleteFileOrFolderSilently(pluginBundleFileParentFile.getParentFile(), true);
            }
            return false;
        }

        boolean sdkValid = PluginCheckUtil.checkFileMd5(mActivity.getSdkBundleFileInfo().second, pluginDataInfo.getSdkMd5());
        boolean pluginValid = PluginCheckUtil.checkFileMd5(mActivity.getPluginFileInfo().second, pluginDataInfo.getPluginMd5());
        return sdkValid && pluginValid;
    }
}
