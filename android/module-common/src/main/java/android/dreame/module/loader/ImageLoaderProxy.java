package android.dreame.module.loader;

import android.app.Activity;
import android.content.Context;
import android.widget.ImageView;

/**
 * 作者：maqing-PC on 2019/11/1 10:11
 * <p>
 * 邮箱：2856992713@qq.com
 */
public class ImageLoaderProxy implements ImageLoader {
    private static ImageLoaderProxy mInstance;
    private ImageLoader mImageLoader;

    public static ImageLoaderProxy getInstance() {
        if (mInstance == null) {
            mInstance = new ImageLoaderProxy();
        }
        return mInstance;
    }

    public ImageLoader getImageLoader() {
        return mImageLoader;
    }

    public void setImageLoader(ImageLoader imageLoader) {
        mImageLoader = imageLoader;
    }

    @Override
    public void displayImage(Context context, String url, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImage(context, url, imageView);
        }
    }

    @Override
    public void displayImage(Context context, int resId, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImage(context, resId, imageView);
        }
    }

    @Override
    public void displayImage(Context context, int resId, int corners, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImage(context, resId, corners,imageView);
        }
    }

    @Override
    public void displayImage(Context context, String url, int placeHolder, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImage(context, url, placeHolder, imageView);
        }
    }

    @Override
    public void displayImage(Context context, String url, int placeHolder, int errorHolder, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImage(context, url, placeHolder, errorHolder, imageView);
        }
    }

    @Override
    public void displayImageWithErrorHolder(Context context, String url,int errorHolder, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImageWithErrorHolder(context, url, errorHolder, imageView);
        }
    }

    @Override
    public void displayImageWithOption(Context context, String url, LoaderOption loaderOption, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImageWithOption(context, url, loaderOption, imageView);
        }
    }

    @Override
    public void displayImageWithCorners(Context context, String url, int corners, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImageWithCorners(context, url, corners, imageView);
        }
    }

    @Override
    public void displayImageWithCorners(Context context, String url, int holder, int corners, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImageWithCorners(context, url, holder, corners, imageView);
        }
    }

    @Override
    public void displayImageCenterCropWithCorners(Context context, String url, int holder, int corners, ImageView imageView) {
        Activity activity = (Activity) context;
        if (mImageLoader != null && context != null && !activity.isFinishing() && !activity.isDestroyed()) {
            mImageLoader.displayImageCenterCropWithCorners(context, url, holder, corners, imageView);
        }
    }

    @Override
    public void clearCache(Context context) {
        if (mImageLoader != null) {
            mImageLoader.clearCache(context);
        }
    }

    @Override
    public void clearMemory(Context context) {
        if (mImageLoader != null) {
            mImageLoader.clearMemory(context);
        }
    }

    @Override
    public void onTrimMemory(Context context, int level) {
        if (mImageLoader != null) {
            mImageLoader.onTrimMemory(context, level);
        }
    }

}
