package android.dreame.module.base;

import android.content.Context;
import android.dreame.module.LocalApplication;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;


import butterknife.ButterKnife;
import butterknife.Unbinder;

/**
 * 作者：maqing-PC on 2020/5/8 17:20
 * <p>
 * 邮箱：2856992713@qq.com
 * AndroidX Fragment 懒加载
 */
public abstract class XDelayFragment extends Fragment implements BaseView,View.OnClickListener {

    protected Fragment mFragment;
    protected LocalApplication mApp;
    protected FragmentActivity mActivity;
    protected LayoutInflater mInflater;
    protected ViewGroup mContainer;
    protected View mRootView;
    private boolean mIsVisible;
    private boolean mFirstVisible = true;
    protected Unbinder mUnbinder;

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        mActivity = getActivity();
    }

    @Override
    public void onResume() {
        super.onResume();
        mIsVisible = true;
        if (mFirstVisible) {
            mFirstVisible = false;
            createViewModel();
            initViewModel();
            initView();
            initData();
            initEvent();
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        mIsVisible = false;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        mFragment = this;
        mApp = LocalApplication.getInstance();
        mInflater = inflater;
        mContainer = container;
        initInstanceState(savedInstanceState);
        beforeInflateView();
        if (mRootView == null) {
            mRootView = inflater.inflate(getInflateViewId(), container, false);
        }
        mUnbinder = ButterKnife.bind(this, mRootView);
        ViewGroup parent = (ViewGroup) mRootView.getParent();
        if (parent != null) {
            parent.removeView(mRootView);
        }
        return mRootView;

    }

    protected void createViewModel() {

    }

    protected abstract void initViewModel();


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

    /**
     * 获取布局Id
     *
     * @return InflateViewId
     */
    protected abstract int getInflateViewId();

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

}
