package android.dreame.module.task;

import android.dreame.module.loader.GlideImageLoader;
import android.dreame.module.loader.ImageLoaderProxy;

import org.jetbrains.annotations.NotNull;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/29 13:35
 * @Version: 1.0
 */
public class ImageLoaderInitTask extends RunInstantTask {
    public ImageLoaderInitTask(@NotNull String id) {
        this(id, false);
    }

    public ImageLoaderInitTask(@NotNull String id, boolean isAsyncTask) {
        super(id, isAsyncTask);
    }

    @Override
    protected void run(@NotNull String s) {
        ImageLoaderProxy.getInstance().setImageLoader(new GlideImageLoader());
    }

}