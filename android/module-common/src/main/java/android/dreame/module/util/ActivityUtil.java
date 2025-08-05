package android.dreame.module.util;

import android.app.Activity;

import androidx.annotation.Nullable;

import java.util.Stack;

/**
 * 作者：maqing on 2016/10/17 0017 20:38
 * 邮箱：2856992713@qq.com
 */
public class ActivityUtil {
    private static final String TAG = ActivityUtil.class.getSimpleName();
    /**
     * 单一实例
     */
    private static ActivityUtil sActivityUtil;
    /**
     * Activity堆栈 Stack:线程安全
     */
    public Stack<Activity> mActivityStack = new Stack<>();
    /**
     * 当前在前台的 Activity
     */
    private Activity mCurrentActivity;

    /**
     * 私有构造器 无法外部创建
     */
    private ActivityUtil() {
    }

    /**
     * 获取单一实例 双重锁定
     *
     * @return this
     */
    public static ActivityUtil getInstance() {
        if (sActivityUtil == null) {
            synchronized (ActivityUtil.class) {
                if (sActivityUtil == null) {
                    sActivityUtil = new ActivityUtil();
                }
            }
        }
        return sActivityUtil;
    }

    /**
     * 添加Activity到堆栈
     */
    public void addActivity(Activity activity) {
        mActivityStack.add(activity);
    }

    /**
     * 移除堆栈中的Activity
     *
     * @param activity Activity
     */
    public void removeActivity(Activity activity) {
        if (activity != null && mActivityStack.contains(activity)) {
            mActivityStack.remove(activity);
        }
    }

    /**
     * 当前Activity 前一个actiivty
     */
    public Activity preActivity() {
        if (mActivityStack.size() > 1) {
            return mActivityStack.get(1);
        }
        return null;
    }

    /**
     * 获取在前台的Activity (保证获取到的Activity正处于可见状态, 即未调用 onStop())
     *
     * @return Activity
     */
    @Nullable
    public Activity getCurrentActivity() {
        return mCurrentActivity;
    }

    /**
     * 将在前台的Activity赋值给currentActivity,
     * 注意此方法是在onResume方法执行时赋值给currentActivity,在onStop时检查当前状态
     *
     * @param activity
     */
    public void setCurrentActivity(Activity activity) {
        this.mCurrentActivity = activity;
    }

    /**
     * 获取最近启动的一个Activity, 此方法不保证获取到的Activity正处于前台可见状态
     *
     * @return
     */
    @Nullable
    public Activity getTopActivity() {
        try {
            return mActivityStack.peek();
        } catch (Exception e) {
            LogUtil.e(TAG, "getTopActivity: " + e.toString());
        }
        return null;
    }

    /**
     * 获取指定类名的Activity
     */
    public Activity getActivity(Class<?> cls) {
        if (mActivityStack != null)
            for (Activity activity : mActivityStack) {
                if (activity.getClass().equals(cls)) {
                    return activity;
                }
            }
        return null;
    }

    /**
     * 结束当前Activity (堆栈中最后一个添加的)
     */
    public void finishCurrentActivity() {
        Activity activity = mActivityStack.peek();
        finishActivity(activity);
    }

    /**
     * 结束指定的Activity
     *
     * @param activity Activity
     */
    public void finishActivity(Activity activity) {
        if (activity != null && mActivityStack.contains(activity)) {
            mActivityStack.remove(activity);
            activity.finish();
        }
    }

    /**
     * 结束指定类名的Activity
     *
     * @param clazz Activity.class
     */
    public void finishActivity(Class<?> clazz) {
        for (Activity activity : mActivityStack) {
            if (activity.getClass().equals(clazz)) {
                finishActivity(activity);
                break;
            }
        }
    }

    /**
     * 结束指定类名的Activity
     *
     * @param clazz Activity.class
     */
    public void finishAllActivity(Class<?> clazz) {
        for (Activity activity : mActivityStack) {
            if (activity.getClass().equals(clazz)) {
                finishActivity(activity);
            }
        }
    }


    /**
     * 结束所有Activity
     */
    public void finishAllActivity() {
        for (int i = mActivityStack.size() - 1; i >= 0; i--) {
            if (mActivityStack.get(i) != null) {
                finishActivity(mActivityStack.get(i));
            }
        }
        mActivityStack.clear();
    }

    /**
     * 结束某个Activity之外的所有Activity
     */
    public void finishAllActivityExcept(Class<?> clazz) {
        for (int i = mActivityStack.size() - 1; i >= 0; i--) {
            if (mActivityStack.get(i) != null && !mActivityStack.get(i).getClass().equals(clazz)) {
                finishActivity(mActivityStack.get(i));
            }
        }
    }

    /**
     * 退出应用程序
     */
    public void exitApp() {
        try {
            finishAllActivity();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            System.exit(0);
        }
    }

    /**
     * app是否处于前台
     *
     * @return true前台 false后台
     */
    public boolean isForeground() {
        return getCurrentActivity() != null;
    }
}