package android.dreame.module.loader;

import android.content.Context;
import android.widget.ImageView;

import androidx.annotation.MainThread;
import androidx.annotation.WorkerThread;

/**
 * 作者：maqing-PC on 2019/10/31 17:32
 * <p>
 * 邮箱：2856992713@qq.com
 * 图片加载接口，实现该类，进行图片加载
 * 减少对第三方库的依赖
 */
public interface ImageLoader {

    void displayImage(Context context, String url, ImageView imageView);

    void displayImage(Context context, int resId, ImageView imageView);

    void displayImage(Context context, int resId, int corners,ImageView imageView);

    void displayImage(Context context, String url, int holder, ImageView imageView);

    void displayImage(Context context, String url, int holder, int errorHolder, ImageView imageView);

    void displayImageWithErrorHolder(Context context, String url, int errorHolder, ImageView imageView);

    void displayImageWithOption(Context context, String url, LoaderOption loaderOption, ImageView imageView);

    void displayImageWithCorners(Context context, String url, int corners, ImageView imageView);

    void displayImageWithCorners(Context context, String url, int holder, int corners, ImageView imageView);
    void displayImageCenterCropWithCorners(Context context, String url, int holder, int corners, ImageView imageView);

    @WorkerThread
    void clearCache(Context context);

    @MainThread
    void clearMemory(Context context);

    void onTrimMemory(Context context, int level);
}
