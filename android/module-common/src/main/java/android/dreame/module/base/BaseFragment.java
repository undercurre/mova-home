package android.dreame.module.base;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.dreame.module.LocalApplication;
import android.dreame.module.R;
import android.dreame.module.base.delegate.BaseActivityDelegate;
import android.dreame.module.event.EventCode;
import android.dreame.module.event.EventMessage;
import android.dreame.module.util.StatusBarUtil;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;

import org.greenrobot.eventbus.EventBus;

import butterknife.ButterKnife;
import butterknife.Unbinder;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.disposables.Disposable;

/**
 * Created by maqing on 2016/guide_2/13 <br>
 * Copyright (C) 2016 <br>
 * Email:2856992713@qq.com <p>
 * BaseFragment
 */
public abstract class BaseFragment extends Fragment implements BaseView, View.OnClickListener {
    protected Fragment mFragment;
    protected LocalApplication mApp;
    protected Activity mActivity;
    protected LayoutInflater mInflater;
    protected ViewGroup mContainer;
    protected View mRootView;
    protected Unbinder mUnbinder;
    protected CompositeDisposable mDisposable;
    private static final String TAG = BaseFragment.class.getSimpleName();

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = getActivity();
    }

    /**
     * 获取布局Id
     *
     * @return InflateViewId
     */
    protected abstract int getInflateViewId();

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        mFragment = this;
        mApp = LocalApplication.getInstance();
        mInflater = inflater;
        mContainer = container;
        initInstanceState(savedInstanceState);
        beforeInflateView();
        if (mRootView == null) {
            mRootView = inflater.inflate(getInflateViewId(), container, false);
            mUnbinder = ButterKnife.bind(this, mRootView);
            if (isRegisteredEventBus()) {
                EventBus.getDefault().register(this);
            }
            View status = mRootView.findViewById(R.id.view_status_bar);
            if (status != null) {
                ViewGroup.LayoutParams lp = status.getLayoutParams();
                lp.height = StatusBarUtil.getStatusBarHeight(mActivity);
                status.setLayoutParams(lp);
            }
            createViewModel();
            initView();
            initData();
            initEvent();
        }
        mUnbinder = ButterKnife.bind(this, mRootView);
        ViewGroup parent = (ViewGroup) mRootView.getParent();
        if (parent != null) {
            parent.removeView(mRootView);
        }
        return mRootView;
    }

    /**
     * 初始化保存的数据
     */
    protected void initInstanceState(Bundle savedInstanceState) {

    }

    /**
     * inflateView之前调用
     */
    protected void beforeInflateView() {
    }

    protected void createViewModel() {

    }

    /**
     * 是否注册事件分发
     *
     * @return true 注册；false 不注册，默认不注册
     */
    protected boolean isRegisteredEventBus() {
        return false;
    }

    /**
     * 通过id初始化View
     *
     * @param viewId viewId
     * @param <T>    T
     * @return T
     */
    protected <T extends View> T byId(int viewId) {
        return (T) mRootView.findViewById(viewId);
    }


    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (mUnbinder != null) {
            mUnbinder.unbind();
        }
        if (EventBus.getDefault().isRegistered(this)) {
            EventBus.getDefault().unregister(this);
        }
        if(mDisposable != null){
            mDisposable.dispose();
        }
    }

    public void popAll() {
        int count = getFragmentManager().getBackStackEntryCount();
        for (int i = 0; i < count; ++i) {
            getFragmentManager().popBackStack();
        }
        EventBus.getDefault().post(new EventMessage(EventCode.POP_ALL_FRAGMENT));
    }

    /**
     * 出栈
     */
    public void pop() {
        getFragmentManager().popBackStack();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        BaseActivityDelegate.onActivityResult(requestCode, resultCode, data, this);
    }

    protected void replaceWithLeftRightAnimator(int containerId, BaseFragment fragment) {
        startFragment(containerId, fragment);

    }

    private void startFragment(int containerId, BaseFragment fragment) {
        getFragmentManager().beginTransaction()
                .setCustomAnimations(R.animator.fragment_slide_right_enter,
                        R.animator.fragment_slide_left_exit,
                        R.animator.fragment_slide_left_enter,
                        R.animator.fragment_slide_right_exit)
                .addToBackStack(fragment.getClass().getSimpleName()).replace(containerId, fragment, fragment.getClass().getSimpleName()).commit();
    }

    public void startWithPopAllFragment(int containerId, BaseFragment fragment) {
        getParentFragmentManager().beginTransaction()
                .setCustomAnimations(R.animator.fragment_slide_right_enter,
                        R.animator.fragment_slide_left_exit,
                        R.animator.fragment_slide_left_enter,
                        R.animator.fragment_slide_right_exit)
                .addToBackStack(fragment.getClass().getSimpleName()).replace(containerId, fragment, fragment.getClass().getSimpleName()).commit();
        getParentFragmentManager().popBackStack(fragment.getClass().getSimpleName(), 0);
    }

    protected void addTo(Disposable disposable) {
        if(mDisposable == null){
            mDisposable = new CompositeDisposable();
        }
        mDisposable.add(disposable);
    }
}
