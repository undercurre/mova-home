package android.dreame.module.rn.bridge;

import android.app.Activity;
import android.content.Intent;
import android.dreame.module.BuildConfig;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.data.db.PluginInfoEntity;
import android.dreame.module.rn.RNDebugActivity;
import android.dreame.module.rn.load.BasicRNHost;
import android.dreame.module.rn.load.RnLoaderCache;
import android.dreame.module.rn.utils.Package;
import android.dreame.module.rn.utils.RNConstants;
import android.dreame.module.trace.EventCommonHelper;
import android.dreame.module.trace.ExceptionStatisticsEventCode;
import android.dreame.module.trace.ModuleCode;
import android.dreame.module.ui.JSExceptionActivity;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.MD5Util;
import android.dreame.module.util.download.rn.RnPluginInfoHelper;
import android.os.Process;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.UiThreadUtil;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.io.File;
import java.util.Map;

public class PackageModule extends ReactContextBaseJavaModule {
    Package mPackage;

    public PackageModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        mPackage = new Package();
    }

    @NonNull
    @Override
    public String getName() {
        return "package";
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return RNConstants.getPackage(getReactApplicationContext());
    }

    @ReactMethod
    public void initSDKConfig() {
        WritableMap writableMap = new WritableNativeMap();
        writableMap.putMap("account", (ReadableMap) RNConstants.getAccount().get("account"));
        writableMap.putMap("device", (ReadableMap) RNConstants.getDevice(getReactApplicationContext()).get("device"));
        writableMap.putMap("host", (ReadableMap) RNConstants.getHost().get("host"));
        writableMap.putMap("locale", (ReadableMap) Arguments.makeNativeMap(RNConstants.getLocale()));
        writableMap.putMap("sdkConfig", (ReadableMap) Arguments.makeNativeMap(RNConstants.getSDKConfig()));
        writableMap.putMap("package", (ReadableMap) Arguments.makeNativeMap(RNConstants.getPackage(getReactApplicationContext())));
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("onPluginConfigUpdate", writableMap);
    }

    @ReactMethod
    public void throwError(String error) {
        final Activity currentActivity = getCurrentActivity();
        boolean isDebuggable = currentActivity != null && currentActivity instanceof RNDebugActivity;
        Intent intent = new Intent(getReactApplicationContext(), JSExceptionActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra("error", error);
        getReactApplicationContext().startActivity(intent);
        LogUtil.e("PackageModule", "throwError isDebuggable: " + isDebuggable + " ,throwError: " + error);
        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (device != null) {
            BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(device.getDid());
            if (basicRNHost != null) {
                basicRNHost.setClearCache(true);
            }

            int pluginRealVersion = 0;
            int sdkRealVersion = 0;
            if (basicRNHost != null) {
                String pluginVersion = basicRNHost.getInUsePluginVersion();
                try {
                    pluginRealVersion = Integer.parseInt(pluginVersion);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
                try {
                    String sdkVersion = basicRNHost.getInUseSdkVersion();
                    sdkRealVersion = Integer.parseInt(sdkVersion);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            } else {
                final PluginInfoEntity sdkInfo = RnPluginInfoHelper.getRnSDKPluginUseSync();
                sdkRealVersion = sdkInfo == null ? 0 : sdkInfo.getPluginVersion();
                final PluginInfoEntity pluginInfo = RnPluginInfoHelper.getRnPluginUseSync(device.getModel(), 0);
                if (pluginInfo != null) {
                    pluginRealVersion = pluginInfo.getPluginVersion();
                }
            }
            LogUtil.e("PackageModule", "throwError did: " + device.getDid() + " ,model: " + device.getModel() + " ,pluginRealVersion: " + pluginRealVersion
                    + " ,sdkRealVersion: " + sdkRealVersion
                    + " ,inUseSdkPath: " + basicRNHost.getInUseSdkPath()
                    + " ,inUsePluginPath: " + basicRNHost.getInUsePluginPath()
                    + " ,inUseSdkPathLength: " + new File(basicRNHost.getInUseSdkPath()).length()
                    + " ,inUsePluginPathLength: " + new File(basicRNHost.getInUsePluginPath()).length()
                    + " ,inUseSdkPathMd5: " + MD5Util.getFileMD5(new File(basicRNHost.getInUseSdkPath()))
                    + " ,inUsePluginPathMd5: " + MD5Util.getFileMD5(new File(basicRNHost.getInUsePluginPath()))
            );
            // debug模式不报
            if (!isDebuggable) {
                // FIXME: 此处在子进程操作数据库
                EventCommonHelper.INSTANCE.eventCommonPageInsertAndKillProcess(ModuleCode.ExceptionStatistics.getCode(), ExceptionStatisticsEventCode.PluginCrash.getCode(), 0, pluginRealVersion, device.getDid(), device.getModel(),
                        sdkRealVersion, 0, 0, 0, BuildConfig.PLUGIN_APP_VERSION, "", "", "", error);
            }
        } else {
            Process.killProcess(Process.myPid());
        }
    }

    @ReactMethod
    public void componentName(Promise promise) {
        DeviceListBean.Device currentDevice = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        promise.resolve(currentDevice.getModel());
    }

    @ReactMethod
    public void exit() {
        LogUtil.e("PackageModule", "exit: ");
        this.exitRN();
    }

    @ReactMethod
    public void exitByCode(int code) {
        LogUtil.e("PackageModule", "exitByCode: " + code);
        if (code == 80002) {
            // 设备无权限
            EventCommonHelper.INSTANCE.eventCommonPageInsert(ModuleCode.ExceptionStatistics.getCode(), ExceptionStatisticsEventCode.LoginAgain.getCode(), 0, 0);
        }
        this.exitRN();
    }


    private void exitRN() {
        LogUtil.e("PackageModule", "exitRN: ");
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    if (getCurrentActivity() != null) {
                        // 空指针问题
                        getCurrentActivity().finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    LogUtil.e("RN 退出异常：" + Log.getStackTraceString(e));
                }
            }
        });
    }
}
