package android.dreame.module.task;

import android.dreame.module.LocalApplication;
import android.dreame.module.util.ScreenUtils;
import android.view.Gravity;

import android.dreame.module.util.toast.ToastUtils;

import org.jetbrains.annotations.NotNull;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/29 13:34
 * @Version: 1.0
 */
public class ToastInitTask extends RunInstantTask {
    public ToastInitTask(@NotNull String id) {
        this(id, false);
    }

    public ToastInitTask(@NotNull String id, boolean isAsyncTask) {
        super(id, isAsyncTask);
    }

    @Override
    protected void run(@NotNull String s) {
        initToast();
    }

    private void initToast() {
        ToastUtils.init(LocalApplication.getInstance());
    }

}
