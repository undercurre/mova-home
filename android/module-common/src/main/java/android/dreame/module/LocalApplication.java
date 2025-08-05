package android.dreame.module;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.dreame.module.base.lifecycle.ActivityLifecycle;
import android.dreame.module.manager.AccountManager;
import android.dreame.module.util.LogUtil;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.Log;
import android.webkit.WebView;

import androidx.annotation.IntRange;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import com.dreame.module.service.app.flutter.IFlutterBridgeService;
import com.dreame.sdk.alify.AliFyApplication;
import com.scwang.smartrefresh.header.MaterialHeader;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.footer.BallPulseFooter;
import com.tencent.mmkv.MMKV;
import com.tencent.mmkv.MMKVHandler;
import com.tencent.mmkv.MMKVLogLevel;
import com.tencent.mmkv.MMKVRecoverStrategic;

import java.io.FileInputStream;
import java.lang.reflect.Method;

public abstract class LocalApplication extends AliFyApplication {

    private static LocalApplication sApp;
    private Handler mUIHandler = new Handler(Looper.getMainLooper());

    public static final LocalApplication getInstance() {
        return sApp;
    }

    //  存储pid, procName
    private static ArrayMap<Integer, String> mProcName = new ArrayMap<>();
    /**
     * 是否打印 http 请求日志
     */
    public static boolean isLogHttpBODY = BuildConfig.LOG_ENABLE;

    static {
        // 全局设置默认的 Header
        SmartRefreshLayout.setDefaultRefreshHeaderCreator((context, layout) -> {
            // 开始设置全局的基本参数（这里设置的属性只跟下面的MaterialHeader绑定，其他Header不会生效，能覆盖DefaultRefreshInitializer的属性和Xml设置的属性）
            layout.setEnableHeaderTranslationContent(true);
            return new MaterialHeader(context).setColorSchemeResources(R.color.common_text_brand);
        });
        SmartRefreshLayout.setDefaultRefreshFooterCreator((context, layout) -> new BallPulseFooter(context)
                .setNormalColor(ContextCompat.getColor(context, R.color.common_textMain))
                .setAnimatingColor(ContextCompat.getColor(context, R.color.common_textMain)));
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        // Reflection.unseal(base);
        sApp = this;
        MMKV.initialize(base);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        initPub();
        registerActivityLifecycleCallbacks(ActivityLifecycle.getInstance());
        ActivityLifecycle.getInstance().setOnBackgroundCallback(new ActivityLifecycle.OnBackgroundCallback() {
            @Override
            public void onResume(@Nullable Activity oldActivity, Activity newActivity) {
                // 应用从后台回到前台
                IFlutterBridgeService service = RouteServiceProvider.getService(IFlutterBridgeService.class);
                if (service != null) {
                    service.onAppResume(oldActivity, newActivity);
                }
            }

            @Override
            public void onBackground(Activity activity) {
                // 应用在前台
                IFlutterBridgeService service = RouteServiceProvider.getService(IFlutterBridgeService.class);
                if (service != null) {
                    service.onAppEnterBackground();
                }
            }

            @Override
            public void onForeground(Activity activity) {
                // 应用在后台
                IFlutterBridgeService service = RouteServiceProvider.getService(IFlutterBridgeService.class);
                if (service != null) {
                    service.onAppEnterForeground();
                }
            }
        });
    }

    /**
     * 初始化公共部分
     */
    private void initPub() {
        // Thread.setDefaultUncaughtExceptionHandler(new CustomExceptionHandler(this));
        String processName = getCurrentProcessName();
        String packageName = getPackageName();

        // fix: android p  WebView Crash
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            WebView.setDataDirectorySuffix(getProcessName());
        }
        if (TextUtils.equals(packageName, processName)) {
            // 主进程
            init(PROCESS_MAIN);
        } else if (processName != null && processName.startsWith(packageName)) {
            // 私有进程
            if (processName.endsWith(":plugin")) {
                // 插件进程
                init(PROCESS_PRIVATE_PLUGIN1);
            } else {
                init(PROCESS_PRIVATE_CHANNEL);
            }
        } else {
            // 其他进程
            init(PROCESS_OTHER);
        }

        MMKV.registerHandler(new MMKVHandler() {
            @Override
            public MMKVRecoverStrategic onMMKVCRCCheckFail(String mmapID) {
                LogUtil.i("MMKV", "onMMKVCRCCheckFail");
                return null;
            }

            @Override
            public MMKVRecoverStrategic onMMKVFileLengthError(String mmapID) {
                LogUtil.i("MMKV", "onMMKVFileLengthError");
                return null;
            }

            @Override
            public boolean wantLogRedirecting() {
                return true;
            }

            @Override
            public void mmkvLog(MMKVLogLevel level, String file, int line, String function, String message) {
                String log = "<" + file + ":" + line + "::" + function + "> " + message;
                LogUtil.i("redirect logging MMKV", log);
            }
        });
    }

    public static String getCurrentProcessName() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            return getProcessName();
        }
        return getProcessName(getInstance(), Process.myPid());
    }

    private static String getProcessName(Context cxt, int pid) {
        final String procName = mProcName.get(pid);
        if (procName != null) {
            return procName;
        }
        String processName = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            processName = getProcessName();
            return processName;
        }
        try {
            final Method declaredMethod = Class.forName("android.app.ActivityThread", false, Application.class.getClassLoader())
                    .getDeclaredMethod("currentProcessName", (Class<?>[]) new Class[0]);
            declaredMethod.setAccessible(true);
            final Object invoke = declaredMethod.invoke(null, new Object[0]);
            if (invoke instanceof String) {
                processName = (String) invoke;
            }
        } catch (Throwable e) {
            e.printStackTrace();
            LogUtil.d("sunzhibin", "getProcessName: " + Log.getStackTraceString(e));
        }
        if (processName == null) {
            String fn = "/proc/self/cmdline";
            try (FileInputStream fileInputStream = new FileInputStream(fn);) {
                byte[] buffer = new byte[1024];
                final int read = fileInputStream.read(buffer);
                int index = -1;
                for (int i = 0; i < buffer.length; i++) {
                    if (buffer[i] == 0) {
                        index = i;
                        break;
                    }
                }
                processName = new String(buffer, 0, index);
            } catch (Exception e) {

            }
        }
        mProcName.put(pid, processName);
        return processName;
    }

    public boolean isMainProcess() {
        String processName = getCurrentProcessName();
        String packageName = getPackageName();
        return TextUtils.equals(packageName, processName);
    }

    public boolean isPluginProcess() {
        String processName = getCurrentProcessName();
        String packageName = getPackageName();
        if (processName != null && processName.startsWith(packageName)) {
            // 私有进程
            return processName.endsWith(":plugin");
        }
        return false;
    }

    public void startLoginActivity() {
        mUIHandler.post(() -> {
            // 重新登录
            LogUtil.i("LocalApplication", "startLoginActivity: ");
            AccountManager.getInstance().clear();
            IFlutterBridgeService flutterBridgeService = RouteServiceProvider.INSTANCE.getService(IFlutterBridgeService.class);
            if (flutterBridgeService != null) {
                flutterBridgeService.gotoFlutterPluginActivity();
            }
        });
    }

    public void initSomeSdkAfterAgreePrivacy() {
    }

    // public abstract String getAuthStr();

    public abstract String getTenantId();

    public abstract boolean isGpVersion();

    public abstract boolean isCnDomain();

    /**
     * 初始化
     *
     * @param process 进程 0：主进程 1：插件进程 5：私有进程 -1：其他进程
     */
    protected abstract void init(@IntRange(from = -1, to = 10) int process);

    /**
     * 主进程：
     */
    public final static int PROCESS_MAIN = 0;
    /**
     * 私有进程：  插件进程
     */
    public final static int PROCESS_PRIVATE_PLUGIN1 = 1;
    public final static int PROCESS_PRIVATE_PLUGIN2 = 2;
    public final static int PROCESS_PRIVATE_PLUGIN3 = 3;
    public final static int PROCESS_PRIVATE_PLUGIN4 = 4;
    /**
     * 私有进程：  友盟推送的channel进程
     */
    public final static int PROCESS_PRIVATE_CHANNEL = 5;
    public final static int PROCESS_OTHER = -1;

}
