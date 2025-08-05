package android.dreame.module.base.lifecycle;

import android.content.Context;
import android.dreame.module.util.LogUtil;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;

/**
 * FragmentLifecycleCallbacks模式实现类,处理公共事件
 */
public class FragmentLifecycle extends FragmentManager.FragmentLifecycleCallbacks {

    private static final String TAG = FragmentLifecycle.class.getSimpleName();
    private static final FragmentLifecycle INSTANCE = new FragmentLifecycle();

    public static FragmentLifecycle getInstance() {
        return INSTANCE;
    }

    @Override
    public void onFragmentAttached(@NonNull FragmentManager fm, @NonNull Fragment f, @NonNull Context context) {
        super.onFragmentAttached(fm, f, context);
    }

    @Override
    public void onFragmentCreated(@NonNull FragmentManager fm, @NonNull Fragment f, @Nullable Bundle savedInstanceState) {
        super.onFragmentCreated(fm, f, savedInstanceState);
    }

    @Override
    public void onFragmentViewCreated(@NonNull FragmentManager fm, @NonNull Fragment f, @NonNull View v, @Nullable Bundle savedInstanceState) {
        super.onFragmentViewCreated(fm, f, v, savedInstanceState);
    }

    @Override
    public void onFragmentActivityCreated(@NonNull FragmentManager fm, @NonNull Fragment f, @Nullable Bundle savedInstanceState) {
        super.onFragmentActivityCreated(fm, f, savedInstanceState);
        LogUtil.d(TAG, "onFragmentActivityCreated: " + f.toString());
    }

    @Override
    public void onFragmentResumed(@NonNull FragmentManager fm, @NonNull Fragment f) {
        super.onFragmentResumed(fm, f);
        LogUtil.d(TAG, "onFragmentResumed: " + f.toString());
    }

    @Override
    public void onFragmentViewDestroyed(@NonNull FragmentManager fm, @NonNull Fragment f) {
        super.onFragmentViewDestroyed(fm, f);
    }

    @Override
    public void onFragmentDestroyed(@NonNull FragmentManager fm, @NonNull Fragment f) {
        LogUtil.d(TAG, "onFragmentDestroyed: " + f.toString());
        super.onFragmentDestroyed(fm, f);
    }

    @Override
    public void onFragmentDetached(@NonNull FragmentManager fm, @NonNull Fragment f) {
        super.onFragmentDetached(fm, f);
    }

}