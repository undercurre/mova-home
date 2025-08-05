package android.dreame.module.rn.load;

import android.dreame.module.BuildConfig;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.trace.EventCommonHelper;
import android.dreame.module.trace.ExceptionStatisticsEventCode;
import android.dreame.module.trace.ModuleCode;
import android.dreame.module.util.LogUtil;
import android.util.Log;
import android.util.Pair;

import com.dreame.event_tracker.EventTracker;
import com.facebook.infer.annotation.Assertions;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactInstanceManagerBuilder;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.CatalystInstance;
import com.facebook.react.bridge.NativeModuleCallExceptionHandler;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactMarker;
import com.facebook.react.bridge.ReactMarkerConstants;
import com.facebook.react.common.LifecycleState;
import com.facebook.v8.reactexecutor.V8ExecutorFactory;

import java.io.File;
import java.util.List;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/04/26
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class BasicRNHost extends ReactNativeHost {

    private final String TAG = "BasicRNHost";

    private Pair<String, String> mSdkBundleInfo;
    private Pair<String, String> mPluginBundleInfo;
    private DeviceListBean.Device device;
    private String themeMode;
    private NativeModuleCallExceptionHandler mNativeModuleCallExceptionHandler;
    private boolean clearCache;
    @Deprecated(since = "不建议使用, 建议直接从ReactInstanceManager判断获取")
    private ReactContext mReactContext;
    private CreateReactContextListener mCreateReactContextListener;

    private ReactInstanceManager.ReactInstanceEventListener mReactInstanceEventListener = new ReactInstanceManager.ReactInstanceEventListener() {
        @Override
        public void onReactContextInitialized(ReactContext context) {
            LogUtil.i(TAG, "onReactContextInitialized " + context);
            mReactContext = context;
            loadScriptFromFile(context);
            getReactInstanceManager().removeReactInstanceEventListener(this);
            if (BasicRNHost.this.mCreateReactContextListener != null) {
                BasicRNHost.this.mCreateReactContextListener.onSuccess();
                BasicRNHost.this.mCreateReactContextListener = null;
            }
        }

        @Override
        public void onReactContextCreated(ReactContext context) {
            LogUtil.i(TAG, "onReactContextCreated: " + context + "," + Thread.currentThread().getName());
            RnLoaderCache.cacheDevice(context, device);
        }
    };

    protected BasicRNHost(DeviceListBean.Device device, String darkMode, Pair<String, String> sdkBundleInfo, Pair<String, String> pluginBundleInfo) {
        super(ReactAppRuntime.getInstance().getApplication());
        this.device = device;
        this.themeMode = darkMode;
        this.mSdkBundleInfo = sdkBundleInfo;
        this.mPluginBundleInfo = pluginBundleInfo;
    }

    public DeviceListBean.Device getRNHostBindedDevice() {
        return device;
    }

    @Override
    protected ReactInstanceManager createReactInstanceManager() {
        ReactMarker.logMarker(ReactMarkerConstants.BUILD_REACT_INSTANCE_MANAGER_START);
        ReactInstanceManagerBuilder builder =
                ReactInstanceManager.builder()
                        .setApplication(getApplication())
                        .setJSMainModulePath(getJSMainModuleName())
                        .setUseDeveloperSupport(getUseDeveloperSupport())
                        .setJavaScriptExecutorFactory(new V8ExecutorFactory())
                        .setUIImplementationProvider(getUIImplementationProvider())
                        .setJSIModulesPackage(getJSIModulePackage())
                        .setNativeModuleCallExceptionHandler(new NativeModuleCallExceptionHandler() {
                            @Override
                            public void handleException(Exception e) {
                                Log.i(TAG, "handleException: ");
                                if (mNativeModuleCallExceptionHandler != null) {
                                    mNativeModuleCallExceptionHandler.handleException(e);
                                }
                                extracted(e);
                                LogUtil.e(TAG, "handleException: " + Log.getStackTraceString(e));
                            }
                        })
                        .setInitialLifecycleState(LifecycleState.BEFORE_CREATE);

        for (ReactPackage reactPackage : getPackages()) {
            builder.addPackage(reactPackage);
        }
        String jsBundleFile = getJSBundleFile();
        if (jsBundleFile != null) {
            builder.setJSBundleFile(jsBundleFile);
        } else {
            builder.setBundleAssetName(Assertions.assertNotNull(getBundleAssetName()));
        }
        ReactInstanceManager reactInstanceManager = builder.build();
        ReactMarker.logMarker(ReactMarkerConstants.BUILD_REACT_INSTANCE_MANAGER_END);
        return reactInstanceManager;
    }

    @Override
    public boolean getUseDeveloperSupport() {
        return false;
    }

    @Override
    protected List<ReactPackage> getPackages() {
        return ReactAppRuntime.getInstance().getPackages();
    }

    @Override
    protected String getJSBundleFile() {
        return this.mSdkBundleInfo.second;
    }

    public void createReactContext(CreateReactContextListener listener) {
        this.mCreateReactContextListener = listener;
        if (mReactContext != null && mCreateReactContextListener != null && mReactContext.hasActiveCatalystInstance()) {
            LogUtil.i(TAG, "createReactContext: mReactContext=" + mReactContext + " ,hasInstance=" + hasInstance() + ",CurrentReactContext=" + getReactInstanceManager().getCurrentReactContext());
            mCreateReactContextListener.onSuccess();
            this.mCreateReactContextListener = null;
        } else {
            ReactInstanceManager manager = getReactInstanceManager();
            manager.addReactInstanceEventListener(mReactInstanceEventListener);
            LogUtil.i(TAG, "createReactContextInBackground: ");
            manager.createReactContextInBackground();
        }
    }

    public void loadScriptFromFile(ReactContext context) {
        CatalystInstance catalyst = context.getCatalystInstance();
        LogUtil.i(TAG, "loadScriptFromFile:" + catalyst);
        try {
            if (catalyst != null) {
                catalyst.loadScriptFromFile(mPluginBundleInfo.second,
                        mPluginBundleInfo.second, false);
            }
        } catch (Exception e) {
            extracted(e);
            e.printStackTrace();
            LogUtil.e(TAG, "loadScriptFromFile Exception:" + e.getMessage());
        }
    }

    private void extracted(Exception e) {
        final String first = mPluginBundleInfo.first;
        final int versionCode = Integer.parseInt(first);
        final String sdk = mSdkBundleInfo.first;
        final int sdkVersion = Integer.parseInt(sdk);

        String stackTraceString = Log.getStackTraceString(e);
        if (stackTraceString != null && stackTraceString.length() > 300) {
            stackTraceString = stackTraceString.substring(0, 300);
        }
        EventCommonHelper.INSTANCE.eventCommonPageInsert(ModuleCode.ExceptionStatistics.getCode(), ExceptionStatisticsEventCode.PluginLoadFail.getCode(), 0, versionCode, "",
                device.getModel(), sdkVersion, 0, 0, 0, BuildConfig.PLUGIN_APP_VERSION, "", "", "", stackTraceString);
        EventTracker.getInstance().forceUpload();
    }

    public void removeNativeModuleCallExceptionHandler() {
        this.mNativeModuleCallExceptionHandler = null;
    }

    public void setNativeModuleCallExceptionHandler(NativeModuleCallExceptionHandler mNativeModuleCallExceptionHandler) {
        this.mNativeModuleCallExceptionHandler = mNativeModuleCallExceptionHandler;
    }

    public boolean isClearCache() {
        return clearCache;
    }

    public void setClearCache(boolean clearCache) {
        this.clearCache = clearCache;
    }


    /**
     * 插件和插件SDK 的version 和 path
     *
     * @return
     */
    public String getInUseSdkPath() {
        return new File(mSdkBundleInfo.second).getParent() + File.separator;
    }

    public String getInUseSdkVersion() {
        return mSdkBundleInfo.first;
    }

    public String getInUsePluginPath() {
        return new File(mPluginBundleInfo.second).getParent() + File.separator;
    }

    public String getInUsePluginVersion() {
        return mPluginBundleInfo.first;
    }

    public String getThemeMode() {
        return themeMode;
    }
}
