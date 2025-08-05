package android.dreame.module.rn.load;

import static android.dreame.module.rn.load.ShortcutPinnedReceiverKt.registerShortcutPinnedReceiver;
import static android.dreame.module.rn.load.ShortcutPinnedReceiverKt.unregisterShortcutPinnedReceiver;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.dreame.module.R;
import android.dreame.module.RouteServiceProvider;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.bean.LanguageBean;
import android.dreame.module.constant.CommExtraConstant;
import android.dreame.module.constant.Constants;
import android.dreame.module.feature.connect.bluetooth.BluetoothLeManager;
import android.dreame.module.feature.connect.bluetoothv2.MyBleConnectStateManager;
import android.dreame.module.manager.LanguageManager;
import android.dreame.module.rn.RNBleStateEventReceiver;
import android.dreame.module.rn.data.PluginDataInfo;
import android.dreame.module.rn.utils.RNConstants;
import android.dreame.module.util.DarkThemeUtils;
import android.dreame.module.util.GsonUtils;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.SuperStatusUtil;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.util.Pair;
import android.view.KeyEvent;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import com.blankj.utilcode.util.BarUtils;
import com.dreame.module.service.app.flutter.IFlutterBridgeService;
import com.dreame.sdk.share.ShareSdk;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.modules.core.PermissionAwareActivity;
import com.facebook.react.modules.core.PermissionListener;
import com.facebook.react.modules.i18nmanager.I18nUtil;

import kotlin.Triple;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/04/26
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class RnActivity extends AppCompatActivity implements DefaultHardwareBackBtnHandler, PermissionAwareActivity {

    private final String TAG = "RnActivity";
    private static final String STATE_RESTORE = "isRestore";

    public ReactActivityDelegate mDelegate;
    private DeviceListBean.Device device;
    private Pair<String, String> mSdkBundleFileInfo;
    private Pair<String, String> mPluginFileInfo;
    private Triple<Integer, String, Integer> mPluginResFileInfo;

    @Nullable
    private PluginDataInfo mPluginDataInfo;
    private boolean isVideo;
    private String warningCode;
    private boolean showWarning;
    private String entranceType;
    private String extraData;
    private String source;
    private String realSdkVersion;

    public RnActivity() {
        mDelegate = createReactActivityDelegate();
    }

    private ShortcutPinnedReceiver mShortcutPinnedReceiver;
    private RNBleStateEventReceiver mBleStateReceiver;

    /**
     * Called at construction time, override if you have a custom delegate implementation.
     */
    protected ReactActivityDelegate createReactActivityDelegate() {
        return new ReactActivityDelegate(this);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LanguageBean lanauge = LanguageManager.getInstance().getLanguage(this);
        if (TextUtils.equals(lanauge.getLangTag(), "he") || TextUtils.equals(lanauge.getLangTag(), "ar")
                || TextUtils.equals(lanauge.getLangTag(), "iw")) {
            I18nUtil.getInstance().forceRTL(this, true);
        } else {
            I18nUtil.getInstance().forceRTL(this, false);
        }
        ShareSdk.INSTANCE.initSdk(getApplicationContext(), false);
        if (savedInstanceState != null) {
            boolean isRestore = savedInstanceState.getBoolean(STATE_RESTORE, false);
            if (isRestore) {
                LogUtil.i(TAG, "onCreate isRestore:" + isRestore);
                finish();
                return;
            }
        }
        // 注册桌面快捷方式广播
        mShortcutPinnedReceiver = registerShortcutPinnedReceiver(this);
        registerBleStateReceiver();

        // 初始化数据
        Intent intent = getIntent();
        device = (DeviceListBean.Device) intent.getParcelableExtra(Constants.DEVICE);
        if (device == null) {
            LogUtil.i(TAG, "onCreate device == null");
            device = GsonUtils.fromJson(getIntent().getStringExtra("device"), DeviceListBean.Device.class);
        }
        if (device == null) {
            finish();
            return;
        }

        setContentView(R.layout.activity_rn_loading);
        mPluginDataInfo = intent.getParcelableExtra("pluginDataInfo");

        String sdkVersion = "";
        String pluginVersion = "";
        String sdkBundlePath = "";
        String pluginFilePath = "";

        int pluginResVersion = -1;
        String pluginResFilePath = "";
        int commonPluginVer = -1;
        if (mPluginDataInfo != null) {
            sdkVersion = mPluginDataInfo.getSdkVersion();
            realSdkVersion = mPluginDataInfo.getRealSdkVersion();
            pluginVersion = mPluginDataInfo.getPluginVersion();
            sdkBundlePath = mPluginDataInfo.getSdkPath();
            pluginFilePath = mPluginDataInfo.getPluginPath();

            pluginResVersion = mPluginDataInfo.getPluginResVersion();
            pluginResFilePath = mPluginDataInfo.getPluginResPath();
            commonPluginVer = mPluginDataInfo.getCommonPluginVer();
        }

        LogUtil.i(TAG, "sdkVersion: " + sdkVersion + " ,pluginVersion: " + pluginVersion
                + " ,sdkBundlePath: " + sdkBundlePath + " ,pluginFilePath: " + pluginFilePath + " ,pluginResFilePath: " + mPluginDataInfo);

        this.mSdkBundleFileInfo = new Pair<>(sdkVersion, sdkBundlePath);
        this.mPluginFileInfo = new Pair<>(pluginVersion, pluginFilePath);
        this.mPluginResFileInfo = new Triple<>(pluginResVersion, pluginResFilePath, commonPluginVer);

        isVideo = intent.getBooleanExtra(CommExtraConstant.IS_FROM_VIDEO, false);
        showWarning = getIntent().getBooleanExtra(CommExtraConstant.EXTRA_DEVICE_WARNING, false);
        warningCode = getIntent().getStringExtra(CommExtraConstant.EXTRA_DEVICE_WARNING_CODE);
        entranceType = getIntent().getStringExtra(CommExtraConstant.ENTRANCE_TYPE);
        extraData = getIntent().getStringExtra(CommExtraConstant.EXTRA_EXTRA_DATA);
        source = getIntent().getStringExtra(CommExtraConstant.EXTRA_SOURCE);

        SuperStatusUtil.hieStatusBarAndNavigationBar(getWindow().getDecorView());
        boolean isDark = DarkThemeUtils.isDarkTheme(this);
        SuperStatusUtil.setStatusBar(this, false, isDark, Color.TRANSPARENT);
        BarUtils.setNavBarColor(this, ContextCompat.getColor(this, R.color.common_layoutBg));
        // 已缓存的插件和本次加载版本不一致情况，删除已缓存插件信息
        BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(device.getDid());
        if (basicRNHost != null) {
            final String inUseSdkVersion = basicRNHost.getInUseSdkVersion();
            final String inUsePluginVersion = basicRNHost.getInUsePluginVersion();
            if (!TextUtils.equals(inUseSdkVersion, sdkVersion) || !TextUtils.equals(inUsePluginVersion, pluginVersion)) {
                LogUtil.i(TAG, "getReactNativeHost: removeRnHost = inUseSdkVersion: " + inUseSdkVersion + " ,inUsePluginVersion: " + inUsePluginVersion
                        + " ,sdkBundlePath: " + sdkVersion + " ,pluginBundlePath: " + pluginVersion);
                RnLoaderCache.removeRnHost(device.getDid());
            }
        }

        if (mDelegate != null) {
            mDelegate.onCreate(savedInstanceState);
        }
    }

    @Override
    public void onNewIntent(Intent intent) {
        if (mDelegate != null) {
            if (!mDelegate.onNewIntent(intent)) {
                super.onNewIntent(intent);
            }
        } else {
            super.onNewIntent(intent);
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        LogUtil.d("RnActivity", "onStart");
        // 页面从后台回到前台，检查并连接mqtt
        IFlutterBridgeService flutterBridgeService = RouteServiceProvider.getService(IFlutterBridgeService.class);
        if (flutterBridgeService != null) {
            flutterBridgeService.checkAndConnectMqtt();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        LogUtil.d("RnActivity", "onResume");
        if (mDelegate != null) {
            mDelegate.onResume();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        LogUtil.d("RnActivity", "onPause");
        if (mDelegate != null) {
            mDelegate.onPause();
        }
        if (isFinishing()) {
            disConnectBLE();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        LogUtil.d("RnActivity", "onStop");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        LogUtil.d("RnActivity", "onDestroy");
        if (mDelegate != null) {
            mDelegate.onDestroy();
        }
        RnCacheManager.INSTANCE.loadTimesIncrement();
        // 注册桌面快捷方式广播
        unregisterShortcutPinnedReceiver(this, mShortcutPinnedReceiver);
        unregisterBleStateReceiver();
        if (isFinishing()) {
            disConnectBLE();
        }
    }

    void disConnectBLE() {
        if (isFinishing()) {
            try {
                BluetoothLeManager.INSTANCE.disconnectAndCloseAll();
                MyBleConnectStateManager.INSTANCE.disconnectAndCloseAll();
            } catch (Exception e) {
                LogUtil.e("RnActivity", "onDestroy disconnectAndCloseAll " + Log.getStackTraceString(e));
            }
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (mDelegate != null) {
            mDelegate.onActivityResult(requestCode, resultCode, data);
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (mDelegate != null) {
            return mDelegate.onKeyDown(keyCode, event) || super.onKeyDown(keyCode, event);
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (mDelegate != null) {
            return mDelegate.onKeyUp(keyCode, event) || super.onKeyUp(keyCode, event);
        } else {
            return super.onKeyUp(keyCode, event);
        }
    }

    @Override
    public boolean onKeyLongPress(int keyCode, KeyEvent event) {
        if (mDelegate != null) {
            return mDelegate.onKeyLongPress(keyCode, event) || super.onKeyLongPress(keyCode, event);
        } else {
            return super.onKeyLongPress(keyCode, event);
        }
    }

    @Override
    public void onBackPressed() {
        if (mDelegate != null) {
            if (!mDelegate.onBackPressed()) {
                super.onBackPressed();
            }
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public void invokeDefaultOnBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.right_in, R.anim.right_out);
    }

    @Override
    public void requestPermissions(
            String[] permissions, int requestCode, PermissionListener listener) {
        if (mDelegate != null) {
            mDelegate.requestPermissions(permissions, requestCode, listener);
        }
    }

    @Override
    public void onRequestPermissionsResult(
            int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (mDelegate != null) {
            mDelegate.onRequestPermissionsResult(requestCode, permissions, grantResults);
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (mDelegate != null) {
            mDelegate.onWindowFocusChanged(hasFocus);
        }

        if (isVideo && hasFocus) {
            View decorView = getWindow().getDecorView();
            decorView.setSystemUiVisibility(
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
        }
    }


    public DeviceListBean.Device getDevice() {
        return device;
    }

    public Pair<String, String> getSdkBundleFileInfo() {
        return mSdkBundleFileInfo;
    }

    public Pair<String, String> getPluginFileInfo() {
        return mPluginFileInfo;
    }

    public PluginDataInfo getPluginDataInfo() {
        return mPluginDataInfo;
    }

    public boolean isVideo() {
        return isVideo;
    }

    public Bundle getLaunchOptions() {
        Bundle bundle = new Bundle();
        bundle.putString("packageName", getPackageName());
        bundle.putBoolean("isDebug", false);
        bundle.putString("models", "models");
        final String versionLasted = mPluginFileInfo.first;
        bundle.putString("version", versionLasted);
        bundle.putBoolean("isVideo", isVideo);
        if (showWarning) {
            bundle.putBoolean("goWarning", true);
            bundle.putString("warnCode", warningCode);
        }
        if (device.supportLastWill()) {
            bundle.putString("lastWillCode", device.getLastWill());
        }
        WritableMap writableMap = new WritableNativeMap();
        writableMap.putMap("account", (ReadableMap) RNConstants.getAccount().get("account"));
        if (device == null) {
            LogUtil.e("getLoadDevice currentDevice == null");
        }
        writableMap.putMap("device",
                (ReadableMap) RNConstants.getLoadDevice(device));
        writableMap.putMap("host", (ReadableMap) RNConstants.getHost().get("host"));
        writableMap.putMap("locale", (ReadableMap) Arguments.makeNativeMap(RNConstants.getLocale()));
        writableMap.putMap("sdkConfig", (ReadableMap) Arguments.makeNativeMap(RNConstants.getSDKConfig()));
        writableMap.putMap("package", (ReadableMap) Arguments.makeNativeMap(RNConstants.getPackage(mDelegate.getReactInstanceManager().getCurrentReactContext())));
        bundle.putString("sdkInfo", GsonUtils.toJson(writableMap.toHashMap()));

        Bundle entrance = new Bundle();
        entrance.putString("type", entranceType);
        if (!TextUtils.isEmpty(source)) {
            entrance.putString("source", source);
        }
        if (!TextUtils.isEmpty(extraData)) {
            entrance.putString("extraData", extraData);
        }
        entrance.putBundle("extra", new Bundle());
        bundle.putBundle("entrance", entrance);

        bundle.putInt("resVersion", mPluginResFileInfo.getFirst());
        bundle.putString("resPackagePath", mPluginResFileInfo.getSecond());
        bundle.putString("sdkVersion", mSdkBundleFileInfo.first);
        bundle.putString("realSdkVersion", realSdkVersion);
        bundle.putInt("commonPluginVer", mPluginResFileInfo.getThird());
        return bundle;
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(LanguageManager.getInstance().setLocal(newBase));
    }

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        outState.putBoolean(STATE_RESTORE, true);
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onRestoreInstanceState(@NonNull Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        boolean isRestore = savedInstanceState.getBoolean(STATE_RESTORE);
        if (isRestore) {
            LogUtil.i(TAG, "onRestoreInstanceState isRestore:" + isRestore);
            finish();
        }
    }


    private void registerBleStateReceiver() {
        if (mBleStateReceiver == null) {
            mBleStateReceiver = new RNBleStateEventReceiver();
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                registerReceiver(mBleStateReceiver, intentFilter, Context.RECEIVER_EXPORTED);
            } else {
                registerReceiver(mBleStateReceiver, intentFilter);
            }
        }
    }

    private void unregisterBleStateReceiver() {
        if (mBleStateReceiver != null) {
            unregisterReceiver(mBleStateReceiver);
            mBleStateReceiver = null;
        }
    }

    @Override
    public void onConfigurationChanged(@NonNull Configuration newConfig) {
        super.onConfigurationChanged(newConfig);

    }
}
