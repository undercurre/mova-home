package android.dreame.module.rn;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.ViewParent;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactRootView;

import java.util.Map;
import java.util.WeakHashMap;

public class RNCacheViewManager {
    public Map<String, ReactRootView> CACHE;
    public static final int REQUEST_OVERLAY_PERMISSION_CODE = 1111;
    public static final String REDBOX_PERMISSION_MESSAGE =
            "Overlay permissions needs to be granted in order for react native apps to run in dev mode";

    private RNCacheViewManager() {
    }

    private static class SingletonHolder {
        private final static RNCacheViewManager INSTANCE = new RNCacheViewManager();
    }

    public static RNCacheViewManager getInstance() {
        return SingletonHolder.INSTANCE;
    }

    public ReactRootView getRootView(String moduleName) {
        if (CACHE == null) return null;
        return CACHE.get(moduleName);
    }

    public ReactNativeHost getReactNativeHost(Activity activity) {
        return ((ReactApplication) activity.getApplication()).getReactNativeHost();
    }

    /**
     * 预加载所需的RN模块
     *
     * @param launchOptions 启动参数
     * @param moduleNames   预加载模块名
     *                      建议在主界面onCreate方法调用，最好的情况是主界面在应用运行期间一直存在不被关闭
     */
    public void init(Context context, Bundle launchOptions, String... moduleNames) {
        if (CACHE == null) CACHE = new WeakHashMap<>();
//        boolean needsOverlayPermission = false;
//        if (getReactNativeHost(activity).getUseDeveloperSupport() && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(activity)) {
//            needsOverlayPermission = true;
//            Intent serviceIntent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + activity.getPackageName()));
//            Toast.makeText(activity, REDBOX_PERMISSION_MESSAGE, Toast.LENGTH_LONG).show();
//            activity.startActivityForResult(serviceIntent, REQUEST_OVERLAY_PERMISSION_CODE);
//        }
//
//        if (!needsOverlayPermission) {

        for (String moduleName : moduleNames) {
            ReactRootView rootView = new ReactRootView(context);
//            List<ReactPackage> packages = LocalApplication.getInstance().getPackages();
//            packages.add(new SDKPackage());
//            ReactInstanceManagerBuilder mbuilder = ReactInstanceManager.builder();
//            mbuilder = mbuilder
//                    .setApplication(LocalApplication.getInstance())
//                    .addPackages(packages)
////                    .setCurrentActivity(context)
//                    .setInitialLifecycleState(LifecycleState.BEFORE_CREATE)
////                    .setDefaultHardwareBackBtnHandler(this)
//                    .setUseDeveloperSupport(false)
//                    .setJSBundleLoader(new JSBundleLoader() {
//                        @Override
//                        public String loadScript(JSBundleLoaderDelegate jsBundleLoaderDelegate) {
//                            String sdkVersion = PluginSdkUpgradeManager.getInstance(LocalApplication.getInstance()).getSdkVersionLasted();
//                            String pluginVersion = PluginBundleManager.INSTANCE.getModuleIdWithVersionCodeLasted(LocalApplication.getInstance(), moduleName);
//                            String sdkPath = PluginBundleManager.INSTANCE.getPluginSDKRealPath(LocalApplication.getInstance(), sdkVersion);
//                            String pluginPath = PluginBundleManager.INSTANCE.getPluginModuleRealPath(LocalApplication.getInstance(), pluginVersion);
//                            sdkPath = "/storage/emulated/0/Android/data/com.dreame.smartlife/files/plugins/sdk_29/sdk/sdk.bundle";
//                            pluginPath = "/storage/emulated/0/Android/data/com.dreame.smartlife/files/plugins/630e5b0f2c8b441b860a41f0c938df1d_1/630e5b0f2c8b441b860a41f0c938df1d/index.android.bundle";
//                            JSBundleLoader.createFileLoader(sdkPath, sdkPath, false).loadScript(jsBundleLoaderDelegate);
//                            return JSBundleLoader.createFileLoader(pluginPath, pluginPath, false).loadScript(jsBundleLoaderDelegate);
//                        }
//                    });
//            rootView.startReactApplication(
//                    mbuilder.build(),
//                    moduleName,
//                    launchOptions);
//            CACHE.put(moduleName, rootView);
        }
//        }
    }

    /**
     * 销毁指定的预加载RN模块
     *
     * @param componentName
     */
    public void onDestroyOne(String componentName) {
        try {
            ReactRootView reactRootView = CACHE.get(componentName);
            if (reactRootView != null) {
                ViewParent parent = reactRootView.getParent();
                if (parent != null) {
                    ((android.view.ViewGroup) parent).removeView(reactRootView);
                }
                reactRootView.unmountReactApplication();
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 销毁全部RN模块
     * 建议在主界面onDestroy方法调用
     */
    public void onDestroy() {
        try {
            for (Map.Entry<String, ReactRootView> entry : CACHE.entrySet()) {
                ReactRootView reactRootView = entry.getValue();
                ViewParent parent = reactRootView.getParent();
                if (parent != null) {
                    ((android.view.ViewGroup) parent).removeView(reactRootView);
                }
                reactRootView.unmountReactApplication();
                reactRootView = null;
            }
            CACHE.clear();
            CACHE = null;
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

}