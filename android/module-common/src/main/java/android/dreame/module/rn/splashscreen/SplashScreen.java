package android.dreame.module.rn.splashscreen;

import android.app.Activity;
import android.dreame.module.R;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.manager.DeviceManager;
import android.dreame.module.rn.DeviceOfflineDialog;
import android.dreame.module.rn.LoadingRnDialogFragment;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import java.lang.ref.WeakReference;

/**
 * SplashScreen
 * 启动屏
 * from：http://www.devio.org
 * Author:CrazyCodeBoy
 * GitHub:https://github.com/crazycodeboy
 * Email:crazycodeboy@gmail.com
 */
public class SplashScreen {
    private static LoadingRnDialogFragment mSplashDialog;
    private static DeviceOfflineDialog deviceOfflineDialog;
    private static WeakReference<Activity> mActivity;
    private static final Handler mHandler = new Handler(Looper.getMainLooper());

    /**
     * 打开启动屏
     */
    public static void show(final Activity activity, final int themeResId) {
        show(activity, themeResId, 0);
    }

    public static void show(final Activity activity, final int themeResId, int progress) {
        if (activity == null) return;
        mActivity = new WeakReference<Activity>(activity);
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (!activity.isFinishing()) {
                    // mSplashDialog = new Dialog(activity, themeResId);
                    // mSplashDialog.setContentView(R.layout.dialog_layout_loading_rn);
                    // mSplashDialog.getWindow().setDimAmount(1);
                    // mSplashDialog.setCancelable(false);
                    //
                    // if (!mSplashDialog.isShowing()) {
                    //     mSplashDialog.show();
                    // }
                    if (mSplashDialog != null && mSplashDialog.isShowing()) {
                        mSplashDialog.dismiss();
                    }
                    mSplashDialog = LoadingRnDialogFragment.newInstance(0);
                    FragmentManager supportFragmentManager = ((FragmentActivity) activity).getSupportFragmentManager();
                    if (supportFragmentManager.isDestroyed()) {
                        return;
                    }
                    mSplashDialog.show(supportFragmentManager, mSplashDialog.toString());
//                    mHandler.postDelayed(new Runnable() {
//                        @Override
//                        public void run() {
//                            hide();
//                        }
//                    }, 1000);
                }
            }
        });
    }

    /**
     * 打开启动屏
     */
    public static void show(final Activity activity, final boolean fullScreen) {
        int resourceId = fullScreen ? R.style.SplashScreen_Fullscreen : R.style.SplashScreen_SplashTheme;

        show(activity, resourceId);
    }

    /**
     * 打开启动屏
     */
    public static void show(final Activity activity) {
        show(activity, false);
    }

    public static void hide() {
        if (mSplashDialog != null && mSplashDialog.isShowing()) {
            try {
                mSplashDialog.dismissAllowingStateLoss();
            } catch (Exception e) {
                e.printStackTrace();
            }
            mSplashDialog = null;
        }
    }

    /**
     * 关闭启动屏
     */
    public static void hide(Activity activity) {
        if (activity == null) {
            if (mActivity == null) {
                return;
            }
            activity = mActivity.get();
        }

        if (activity == null) return;

        final Activity _activity = activity;

        _activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mSplashDialog != null && mSplashDialog.isShowing()) {
                    boolean isDestroyed = false;

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                        isDestroyed = _activity.isDestroyed();
                    }

                    if (!_activity.isFinishing() && !isDestroyed) {
                        mSplashDialog.dismiss();
                    }
                    mSplashDialog = null;

                    //
                    DeviceListBean.Device currentDevice = DeviceManager.getInstance().getCurrentDevice();
                    if (currentDevice != null && !currentDevice.isOnline()) {
                        // FIXME: 8.9.21 去掉离线弹窗
                        // SplashScreen.showDeviceOffline(_activity);
                    }

                }
            }
        });
    }

    /**
     * 设备离线
     */
    public static void showDeviceOffline(Activity activity) {
        if (deviceOfflineDialog == null) {
            deviceOfflineDialog = new DeviceOfflineDialog(activity);
        }
        deviceOfflineDialog.show(DeviceManager.getInstance().getCurrentDevice());
    }

    public static void hideDeviceOffline() {
        if (deviceOfflineDialog != null && deviceOfflineDialog.isShowing()) {
            deviceOfflineDialog.dismiss();
            deviceOfflineDialog = null;
        }
    }
}
