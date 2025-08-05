package android.dreame.module.base.lifecycle;

import android.app.Activity;
import android.app.Application;
import android.dreame.module.manager.LanguageManager;
import android.dreame.module.util.ActivityUtil;
import android.dreame.module.util.LogUtil;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

/**
 * ActivityLifecycleCallbacks模式实现,处理Activity公共事件
 */
public class ActivityLifecycle implements Application.ActivityLifecycleCallbacks {
    private static final String TAG = ActivityLifecycle.class.getSimpleName();
    private final static ActivityLifecycle INSTANCE = new ActivityLifecycle();

    // 运行的activity数
    private int liveActivityCount = 0;

    private OnBackgroundCallback mOnBackgroundCallback;

    // 记录进程是否在前台
    private int count = 0;

    public static ActivityLifecycle getInstance() {
        return INSTANCE;
    }

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
        LogUtil.d(TAG, "onActivityCreated: " + activity.toString());
        ActivityUtil.getInstance().addActivity(activity);
        if (activity instanceof AppCompatActivity) {
            ((AppCompatActivity) activity).getSupportFragmentManager().registerFragmentLifecycleCallbacks(FragmentLifecycle.getInstance(), true);
        }
        if (activity.toString().contains("SobotChatActivity")) {
            Activity currentActivity = ActivityUtil.getInstance().getCurrentActivity();
            if (currentActivity != null) {
                LanguageManager.getInstance().setApplicationLanguage(currentActivity);
            }
        }

    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {
        LogUtil.d(TAG, "onActivityStarted: " + activity.toString());
        liveActivityCount++;
        if (liveActivityCount == 1 && mOnBackgroundCallback != null) {
            mOnBackgroundCallback.onForeground(activity);
        }
    }

    @Override
    public void onActivityResumed(@NonNull Activity activity) {
        count = 1;
        LogUtil.d(TAG, "onActivityResumed: " + activity.toString());
        if (mOnBackgroundCallback != null) {
            mOnBackgroundCallback.onResume(ActivityUtil.getInstance().getCurrentActivity(), activity);
        }
        ActivityUtil.getInstance().setCurrentActivity(activity);
    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {
        count = 0;
        LogUtil.d(TAG, "onActivityPaused: " + activity.toString());
    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {
        LogUtil.d(TAG, "onActivityStopped: " + activity.toString());

        liveActivityCount--;
        if (liveActivityCount == 0 && mOnBackgroundCallback != null) {
            mOnBackgroundCallback.onBackground(activity);
        }

        if (activity == ActivityUtil.getInstance().getCurrentActivity()) {
            ActivityUtil.getInstance().setCurrentActivity(null);
        }
    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
        LogUtil.d(TAG, "onActivitySaveInstanceState: " + activity.toString());
    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {
        LogUtil.d(TAG, "onActivityDestroyed: " + activity.toString());
        ActivityUtil.getInstance().removeActivity(activity);
        if (activity instanceof AppCompatActivity) {
            ((AppCompatActivity) activity).getSupportFragmentManager().unregisterFragmentLifecycleCallbacks(FragmentLifecycle.getInstance());
        }
    }

    public boolean isAppForeground() {
        return count > 0;
    }

    public void setOnBackgroundCallback(OnBackgroundCallback onBackgroundCallback) {
        this.mOnBackgroundCallback = onBackgroundCallback;
    }

    public interface OnBackgroundCallback {
        void onResume(@Nullable Activity oldActivity, Activity newActivity);

        void onBackground(Activity activity);

        void onForeground(Activity activity);
    }
}
