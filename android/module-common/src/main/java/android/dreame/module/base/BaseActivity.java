package android.dreame.module.base;

import android.app.Activity;
import android.app.Application;
import android.content.ComponentCallbacks;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.dreame.module.LocalApplication;
import android.dreame.module.R;
import android.dreame.module.base.delegate.BaseActivityDelegate;
import android.dreame.module.base.delegate.IPermissionCallBack;
import android.dreame.module.manager.LanguageManager;
import android.dreame.module.util.DarkThemeUtils;
import android.dreame.module.util.OSUtil;
import android.dreame.module.util.StatusBarUtil;
import android.dreame.module.util.SuperStatusUtil;
import android.dreame.module.view.dialog.CustomProgressDialog;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import org.greenrobot.eventbus.EventBus;

import butterknife.ButterKnife;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.disposables.Disposable;


/**
 * Created by maqing-PC on 2016/guide_2/12 <br>
 * Copyright (C) 2016 <br>
 * Email:2856992713@qq.com
 * BaseActivity
 */
public abstract class BaseActivity extends AppCompatActivity implements BaseView, View.OnClickListener, IPermissionCallBack {
    protected Context mContext;
    protected Activity mActivity;
    protected LocalApplication mApp;
    protected LayoutInflater mInflater;
    private Handler mHandler;
    protected CompositeDisposable mDisposable;

    // 系统的Density
    private static float sNoncompatDensity;
    // 系统的ScaledDensity
    private static float sNoncompatScaledDensity;
    private CustomProgressDialog loading;

    /**
     * 获取布局Id
     *
     * @return
     */
    protected abstract int getContentViewId();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = this;
        mActivity = this;
        mApp = LocalApplication.getInstance();
        mInflater = LayoutInflater.from(this);
        mDisposable = new CompositeDisposable();
//    setSystemUi();
        initInstanceState(savedInstanceState);
        beforeSetContentView();

//    setCustomDensity(this,getApplication());
        setContentView(getContentViewId());
        setStatusBar();
        ButterKnife.bind(mActivity);
        if (isRegisteredEventBus()) {
            EventBus.getDefault().register(this);
        }
        createViewModel();
        initData();
        initView();
        initEvent();
        initViewModel();
    }

    /**
     * 注意避免与viewmodel中的loading 冲突
     */
    protected void showLoading() {
        if (loading != null && loading.isShowing()) {
            loading.dismiss();
        }
        loading = new CustomProgressDialog(this);
        loading.show();
    }

    protected void dismissLoading() {
        if (loading != null && loading.isShowing()) {
            loading.dismiss();
        }
        loading = null;
    }

    /**
     * 沉浸式状态栏
     */
    protected void setStatusBar() {
        SuperStatusUtil.hieStatusBarAndNavigationBar(getWindow().getDecorView());
        boolean isDark = DarkThemeUtils.isDarkTheme(this);
        SuperStatusUtil.setStatusBar(this, false, isDark, Color.TRANSPARENT);
        View status = findViewById(R.id.view_status_bar);
        if (status != null) {
            ViewGroup.LayoutParams lp = status.getLayoutParams();
            lp.height = StatusBarUtil.getStatusBarHeight(mActivity);
            status.setLayoutParams(lp);
        }
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(LanguageManager.getInstance().setLocal(newBase));
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        if (isRegisteredEventBus()) {
            EventBus.getDefault().unregister(this);
        }
        if (mDisposable != null) {
            mDisposable.dispose();
        }
        super.onDestroy();
    }

    protected void addTo(Disposable disposable) {
        mDisposable.add(disposable);
    }

    /**
     * 设置系统界面
     */
    protected void setSystemUi() {
        if (Build.VERSION.SDK_INT >= 21) {
            getWindow().setStatusBarColor(ContextCompat.getColor(mContext, R.color.common_color_white));
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().getDecorView().setSystemUiVisibility(
                    View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
            getWindow().setStatusBarColor(ContextCompat.getColor(mContext, R.color.common_color_white));
        }
        if (OSUtil.getRomType() == OSUtil.ROM_TYPE.MIUI) {
            StatusBarUtil.MIUISetStatusBarLightMode(this.getWindow(), true);
        } else if (OSUtil.getRomType() == OSUtil.ROM_TYPE.FLYME) {
            StatusBarUtil.FlymeSetStatusBarLightMode(this.getWindow(), true);
        }
    }

    protected final Handler getHandler() {
        if (mHandler == null) {
            mHandler = new Handler(getMainLooper());
        }
        return mHandler;
    }

    /**
     * 初始化保存的数据
     */
    protected void initInstanceState(Bundle savedInstanceState) {

    }

    /**
     * setContentView之前调用
     */
    protected void beforeSetContentView() {

    }

    /**
     * 通过id初始化View
     *
     * @param viewId
     * @param <T>
     * @return
     */
    protected <T extends View> T byId(int viewId) {
        return (T) findViewById(viewId);
    }

    protected void createViewModel() {

    }

    protected abstract void initViewModel();

    @Override
    public void permissionSettingBack() {

    }

    /**
     * 是否注册事件分发
     *
     * @return true 注册；false 不注册，默认不注册
     */
    protected boolean isRegisteredEventBus() {
        return false;
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
//        if (hasFocus) {
//            getWindow().getDecorView().setSystemUiVisibility(
//                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
//                            | View.SYSTEM_UI_FLAG_FULLSCREEN | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
//            );
//        }
    }

    /**
     * 屏幕适配方案
     *
     * @param activity
     * @param application
     */
    public static void setCustomDensity(Activity activity, Application application) {
        DisplayMetrics displayMetrics = application.getResources().getDisplayMetrics();
        if (sNoncompatDensity == 0) {
            sNoncompatDensity = displayMetrics.density;
            sNoncompatScaledDensity = displayMetrics.scaledDensity;
            // 监听在系统设置中切换字体
            application.registerComponentCallbacks(new ComponentCallbacks() {
                @Override
                public void onConfigurationChanged(Configuration newConfig) {
                    if (newConfig != null && newConfig.fontScale > 0) {
                        sNoncompatScaledDensity = application.getResources().getDisplayMetrics().scaledDensity;
                    }
                }

                @Override
                public void onLowMemory() {

                }
            });
        }
        // 此处为360dp的设计图
        float targetDensity = displayMetrics.widthPixels / 360;
        float targetScaledDensity = targetDensity * (sNoncompatScaledDensity / sNoncompatDensity);
        int targetDensityDpi = (int) (160 * targetDensity);
        displayMetrics.density = targetDensity;
        displayMetrics.scaledDensity = targetScaledDensity;
        displayMetrics.densityDpi = targetDensityDpi;

        DisplayMetrics activityDisplayMetrics = activity.getResources().getDisplayMetrics();
        activityDisplayMetrics.density = targetDensity;
        activityDisplayMetrics.scaledDensity = targetScaledDensity;
        activityDisplayMetrics.densityDpi = targetDensityDpi;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        BaseActivityDelegate.onActivityResult(requestCode, resultCode, data, this);
    }
}
