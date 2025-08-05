package com.dreame.movahome;

import android.content.Context;
import android.dreame.module.LocalApplication;
import android.dreame.module.base.permission.PermissionInterceptor;
import android.dreame.module.constant.Constants;
import android.dreame.module.loader.ImageLoaderProxy;
import android.dreame.module.manager.AccountManager;
import android.dreame.module.rn.bridge.SDKPackage;
import android.dreame.module.rn.load.ReactAppRuntime;
import android.dreame.module.task.ImageLoaderInitTask;
import android.dreame.module.task.LogModuleInitTask;
import android.dreame.module.task.RNInitTask;
import android.dreame.module.task.ToastInitTask;
import android.dreame.module.trace.AppEventEventCode;
import android.dreame.module.trace.EventCommonHelper;
import android.dreame.module.trace.ModuleCode;
import android.dreame.module.util.DarkThemeUtils;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.SPUtil;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.work.Configuration;

import com.blankj.utilcode.util.ThreadUtils;
import com.dreame.android.netlibrary.NetworkListener;
import com.dreame.sdk.alify.AliFyApplication;
import com.dreame.sdk.countly.Countly;
import com.dreame.sdk.countly.CountlyActivityLifecycle;
import com.dreame.sdk.countly.IConfigProvider;
import com.dreame.sdk.share.ShareSdk;
import com.dreame.sdk.share.data.ShareConfig;
import com.dreame.smartlife.BuildConfig;
import com.dreame.smartlife.common.IPushLogger;
import com.dreame.smartlife.help.CustomerServiceManager;
import com.dreame.smartlife.service.push.PushManager;
import com.dreame.smartlife.task.PushTask;
import com.facebook.react.PackageList;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactPackage;
import com.facebook.react.views.imagehelper.ResourceDrawableIdHelper;
import com.hjq.permissions.XXPermissions;
import com.tencent.bugly.crashreport.CrashReport;
import com.therouter.router.NavigatorKt;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MainApplication extends LocalApplication implements Configuration.Provider {

    private final String TAG = "MainApplication";
    private Handler mUiHandler = new Handler(Looper.getMainLooper());
    private static boolean hasStartedSplash = false;

    @Override
    public void onCreate() {

        super.onCreate();
        Map<String, String> params = new HashMap<>();
        PushManager.INSTANCE.setLogEnable(BuildConfig.DEBUG);
        PushManager.INSTANCE.setLogger(new IPushLogger() {
            @Override
            public void log(@NonNull String s, @NonNull String s1) {
                LogUtil.d("sunzhibin  PushManager", s + " " + s1);
            }

            @Override
            public void log(@NonNull String s, @NonNull String s1, @Nullable Throwable throwable) {
                LogUtil.d("sunzhibin  PushManager", s + " " + s1 + " " + throwable);

            }
        });
        PushManager.INSTANCE.prePush(this, params);
        if (!AccountManager.getInstance().isFirstLogin()) {
            PushManager.INSTANCE.initPush(this, params);
        }

        NavigatorKt.setRouterInterceptor((routeItem, interceptorCallback) -> {
            // 打印
            LogUtil.d(TAG, "RouterInterceptor process: " + routeItem.toString());
            interceptorCallback.onContinue(routeItem);
        });
    }

    @Override
    public String getTenantId() {
        return "000002";
    }

    @Override
    protected void init(int process) {
        // 多进程preInit
        if (BuildConfig.DEBUG) {           // 这两行必须写在init之前，否则这些配置在init过程中将无效
            // 可以直接删掉本行 // 可以直接删掉本行 ARouter.openLog();     // 打印日志
            // 可以直接删掉本行 // 可以直接删掉本行 ARouter.openDebug();   // 开启调试模式(如果在InstantRun模式下运行，必须开启调试模式！线上版本需要关闭,否则有安全风险)
        }
        // 可以直接删掉本行 // 可以直接删掉本行 ARouter.init(this);
        if (process == 0) {
            // 主进程
            startFromApplicationOnMainProcess();
        } else if (process != -1) {
            // 私有进程
            startFromApplicationOnPrivateProcess(process);
        } else {
            // 其他进程
            startFromApplicationOnPublicProcess();
        }
    }

    private void startFromApplicationOnPublicProcess() {

    }

    private void startFromApplicationOnPrivateProcess(int processFlag) {
        if (processFlag == PROCESS_PRIVATE_PLUGIN1) {
            List<ReactPackage> packages = new PackageList(this).getPackages();
            // Packages that cannot be autolinked yet can be added manually here, for example:
            packages.add(new SDKPackage());
            ReactAppRuntime.getInstance().setPackages(packages).init(this);
            NetworkListener.getInstance().init(this);
            new RNInitTask(this).runInstant();
            initSomeSdkAfterAgreePrivacy();
        } else {
            initCountly();
        }
    }

    private void startFromApplicationOnMainProcess() {
        Log.d(TAG, "startFromApplicationOnMainProcess: --------- RunInstantTask 1 -----");
        // 耗时月10ms
        new LogModuleInitTask("LogModuleInitTask", true).runInstant();
        NetworkListener.getInstance().init(this);
        Log.d(TAG, "startFromApplicationOnMainProcess: --------- RunInstantTask 2 -----");
        // 耗时月90ms
        new ImageLoaderInitTask("ImageLoader").runInstant();
        new ToastInitTask("ToastInitTask").runInstant();

        new PushTask("PushTask").runInstant();
        XXPermissions.setInterceptor(new PermissionInterceptor());

        List<ReactPackage> packages = new PackageList(this).getPackages();
        // Packages that cannot be autolinked yet can be added manually here, for example:
        packages.add(new SDKPackage());
        ReactAppRuntime.getInstance().setPackages(packages).init(this);
        initSomeSdkAfterAgreePrivacy();
        Log.d(TAG, "startFromApplicationOnMainProcess: -------- RunInstantTask 3 ------");
    }

    /**
     * 初始化Countly
     */
    private void initCountly() {
        Countly.sharedInstance().setConfigProvider(new IConfigProvider() {
            @Override
            public void reportEvent(@NonNull String pageName, @NonNull String eventName) {
                EventCommonHelper.INSTANCE.eventCommonPageInsert(ModuleCode.AppEvent.getCode(), AppEventEventCode.Click.getCode(),
                        0, 0, "", "", 0, 0, 0, 0, 0,
                        pageName + "_" + eventName, "", "", "");
            }

            @Override
            public void reportLifeEvent(@NonNull String pageName, @NonNull String eventName) {
                EventCommonHelper.INSTANCE.eventCommonPageInsert(ModuleCode.AppEvent.getCode(), AppEventEventCode.LifeCycle.getCode(),
                        0, 0, "", "", 0, 0, 0, 0, 0,
                        pageName + "_" + eventName, "", "", "");
            }
        });
        registerActivityLifecycleCallbacks(CountlyActivityLifecycle.getInstance());
    }

    private void initShareSdk() {
        ShareConfig shareConfig = new ShareConfig(
                "wx59efb945de8565a0",
                "",
                "1112305425",
                "7wfNcMNFEn0b10iz",
                "3811142209",
                "623556a868b8c772fa9925dfc0207af7",
                "https://app.mova-tech.com/", true, true, true, false
        );
        ShareSdk.INSTANCE.initSdk(this, shareConfig, BuildConfig.DEBUG);
    }

    private void initCustomerServiceSdk() {
        /*ScreenShotHelper.getInstance().register(this, new ScreenShotHelper.CallbackListener() {
            private ScreenShotDetectDialog dialog = null;
            private BottomPermissionDialog bottomPermissionDialog = null;

            @Override
            public void onShot(String path) {
                String processName = getCurrentProcessName();
                String packageName = getPackageName();
                boolean mainProcess = TextUtils.equals(packageName, processName);

                Activity activity = ActivityUtil.getInstance().getCurrentActivity();
                boolean needLogin = !mainProcess || AccountManager.getInstance().isAccountValid();
                if (activity != null && needLogin) {
                    mUiHandler.post(() -> {
                        if (dialog != null && dialog.isShowing()) {
                            return;
                        }
                        Context ctx = LanguageManager.getInstance()
                                .setLocal(activity, LanguageManager.getInstance().getLanguage(activity));
                        dialog = new ScreenShotDetectDialog(activity,
                                () -> {
                                    TheRouter.build(RoutPath.HELP_CENTER).navigation();
                                    return null;
                                },
                                () -> {
                                    TheRouter.build(RoutPath.HELP_FEEDBACK).navigation();
                                    return null;
                                });
                        dialog.show();
                    });
                }
            }

            @Override
            public void onPermissionRequest() {
                mUiHandler.post(() -> {
                    if (bottomPermissionDialog != null && bottomPermissionDialog.isShowing()) {
                        return;
                    }
                    Activity activity = ActivityUtil.getInstance().getCurrentActivity();
                    if (activity != null) {
                        bottomPermissionDialog = new BottomPermissionDialog(activity);
                        bottomPermissionDialog.show(
                                activity.getString(R.string.Toast_SystemServicePermission_CameraPhoto),
                                activity.getString(R.string.next),
                                activity.getString(R.string.cancel),
                                bottomPermissionDialog -> {
                                    XXPermissions.with(activity)
                                            .permission(Permission.READ_MEDIA_IMAGES)
                                            .request((OnPermissionCallback2) (permissions, allGranted) -> {
                                                if (allGranted) {
                                                    ScreenShotHelper.getInstance().startWatchingFileDir();
                                                }
                                            });
                                    bottomPermissionDialog.dismiss();
                                    return null;
                                },
                                bottomPermissionDialog -> {
                                    bottomPermissionDialog.dismiss();
                                    return null;
                                }
                        );
                    }
                });
            }
        });*/
    }

    private void initAlifySdk() {
        if (isMainProcess()) {
            ThreadUtils.getSinglePool().execute(() -> {
                Looper.prepare();
                String appKey = "334474517";
                String appSecret = "40bca2923f914aa6b06ab59e32a16781";
                String forceUrl = SPUtil.getString(getInstance(), Constants.NET_BASE_URL, "");
                if (forceUrl.contains("uat") || BuildConfig.BUILD_TYPE.equalsIgnoreCase("uat")) {
                    appKey = "334667960";
                    appSecret = "222d8821192d4bdd8d80e3f67f72d53e";
                }
                ((AliFyApplication) AliFyApplication.getInstance()).initAliSdk(BuildConfig.DEBUG, appKey, appSecret);
            });
        }
    }

    /**
     * 初始化一些SDK，这些SDK需要在同意隐私后初始化
     */
    @Override
    public void initSomeSdkAfterAgreePrivacy() {
        if (isPluginProcess() || !AccountManager.getInstance().isFirstLogin()) {
            initAlifySdk();
            // gp 不再初始化bugly，firebase就可以了
            if (!isGpVersion()) {
                CrashReport.initCrashReport(this, android.dreame.module.BuildConfig.BUGLY_APP_ID, BuildConfig.DEBUG);
            }
            initCountly();
            initShareSdk();
            initCustomerServiceSdk();
        }
    }

    @Override
    public void onTrimMemory(int level) {
        super.onTrimMemory(level);
        Log.d(TAG, "onTrimMemory: " + level);
        if (!"com.dreame.smartlife".equalsIgnoreCase(getPackageName())) {
            return;
        }
        switch (level) {
            case TRIM_MEMORY_COMPLETE:
                // 内存不足，并且该进程在后台进程列表最后一个，马上就要被清理
                // break;
            case TRIM_MEMORY_MODERATE:
                // 内存不足，并且该进程在后台进程列表的中部。
                // break;
            case TRIM_MEMORY_BACKGROUND:
                // 内存不足，并且该进程是后台进程。
                ResourceDrawableIdHelper.getInstance().clear();
                ImageLoaderProxy.getInstance().onTrimMemory(this, level);
                break;
            case TRIM_MEMORY_UI_HIDDEN:
                // 内存不足，并且该进程的UI已经不可见了。

                break;
            case TRIM_MEMORY_RUNNING_CRITICAL:
                // 内存不足(后台进程不足3个)，并且该进程优先级比较高，需要清理内存
                // break;
            case TRIM_MEMORY_RUNNING_LOW:
                // 内存不足(后台进程不足5个)，并且该进程优先级比较高，需要清理内存
                // break;
            case TRIM_MEMORY_RUNNING_MODERATE:
                // 内存不足(后台进程超过5个)，并且该进程优先级比较高，需要清理内存
                break;
            default:
                break;
        }
    }


    /**
     * Loads Flipper in React Native templates. Call this in the onCreate method with something like
     * initializeFlipper(this, getReactNativeHost().getReactInstanceManager());
     *
     * @param context
     * @param reactInstanceManager
     */
    private static void initializeFlipper(Context context, ReactInstanceManager reactInstanceManager) {
        if (BuildConfig.DEBUG) {
            try {
        /*
         We use reflection here to pick up the class that initializes Flipper,
        since Flipper library is not available in release mode
        */
                Class<?> aClass = Class.forName("com.dreame.smartlife.ReactNativeFlipper");
                aClass.getMethod("initializeFlipper", Context.class, ReactInstanceManager.class).invoke(null, context, reactInstanceManager);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public boolean isGpVersion() {
        return TextUtils.equals("gp", BuildConfig.FLAVOR);
    }

    @Override
    public boolean isCnDomain() {
        return AccountManager.getInstance().isFirstLogin();
    }

    @NonNull
    @Override
    public Configuration getWorkManagerConfiguration() {
        return new Configuration.Builder().setMinimumLoggingLevel(Log.DEBUG).build();
    }

    public static boolean hasStartedSplash() {
        return hasStartedSplash;
    }

    public static void setHasStartedSplash(boolean hasStarted) {
        hasStartedSplash = hasStarted;
    }
}
