package android.dreame.module.task;

import android.dreame.module.LocalApplication;

import com.facebook.soloader.SoLoader;

import org.jetbrains.annotations.NotNull;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/29 13:33
 * @Version: 1.0
 */
public class SoLoaderInitTask extends RunInstantTask {
    public SoLoaderInitTask(@NotNull String id) {
        this(id, false);
    }

    public SoLoaderInitTask(@NotNull String id, boolean isAsyncTask) {
        super(id, isAsyncTask);
    }

    @Override
    protected void run(@NotNull String s) {
        SoLoader.init(LocalApplication.getInstance(), /* native exopackage */ false);
    }

}
