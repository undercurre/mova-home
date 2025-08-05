package android.dreame.module.loader;

import android.content.Context;
import android.widget.ImageView;

import androidx.annotation.MainThread;
import androidx.annotation.NonNull;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.CenterCrop;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;

import io.reactivex.BackpressureStrategy;
import io.reactivex.Flowable;
import io.reactivex.FlowableEmitter;
import io.reactivex.FlowableOnSubscribe;
import io.reactivex.Scheduler;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;

/**
 * 作者：maqing-PC on 2019/10/31 17:43
 * <p>
 * 邮箱：2856992713@qq.com
 */
public class GlideImageLoader implements ImageLoader {

    @Override
    public void displayImage(Context context, String url, ImageView imageView) {
        Glide.with(context)
                .load(url)
                .into(imageView);
    }

    @Override
    public void displayImage(Context context, int resId, ImageView imageView) {
        Glide.with(context)
                .load(resId)
                .into(imageView);
    }

    @Override
    public void displayImage(Context context, int resId, int corners, ImageView imageView) {
        Glide.with(context)
                .load(resId)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(corners)))
                .into(imageView);
    }

    @Override
    public void displayImage(Context context, String url, int placeHolder, ImageView imageView) {
        Glide.with(context)
                .load(url)
                .apply(new RequestOptions().placeholder(placeHolder).error(placeHolder))
                .into(imageView);
    }

    @Override
    public void displayImage(Context context, String url, int placeHolder, int errorHolder, ImageView imageView) {
        Glide.with(context)
                .load(url)
                .apply(new RequestOptions().placeholder(placeHolder).error(errorHolder))
                .into(imageView);
    }

    @Override
    public void displayImageWithErrorHolder(Context context, String url, int errorHolder, ImageView imageView) {
        Glide.with(context)
                .load(url)
                .apply(new RequestOptions().error(errorHolder))
                .into(imageView);
    }

    @Override
    public void displayImageWithOption(Context context, String url, LoaderOption loaderOption, ImageView imageView) {

        RequestOptions requestOptions = new RequestOptions();
        if (loaderOption.mShowCircle) {
            requestOptions.circleCrop();
        }
        if (loaderOption.mPlaceHolder != 0) {
            requestOptions.placeholder(loaderOption.mPlaceHolder);
        }
        if (loaderOption.mErrorHolder != 0) {
            requestOptions.error(loaderOption.mErrorHolder);
        }

        Glide.with(context)
                .load(url)
                .apply(requestOptions)
                .into(imageView);
    }

    @Override
    public void displayImageWithCorners(Context context, String url, int corners, ImageView imageView) {
        Glide.with(context)
                .load(url)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(corners)))
                .into(imageView);
    }

    @Override
    public void displayImageWithCorners(Context context, String url, int holder, int corners, ImageView imageView) {
        RequestOptions options = RequestOptions.bitmapTransform(new RoundedCorners(corners));
        options.placeholder(holder);
        Glide.with(context)
                .load(url)
                .apply(options)
                .into(imageView);
    }

    @Override
    public void displayImageCenterCropWithCorners(Context context, String url, int holder, int corners, ImageView imageView) {
        Glide.with(context)
                .load(url)
                .transform(new CenterCrop(),new RoundedCorners(corners))
                .placeholder(holder)
                .into(imageView);
    }

    @Override
    public void clearCache(Context context) {
        Flowable.create(emitter -> Glide.get(context).clearDiskCache(), BackpressureStrategy.DROP)
                .observeOn(Schedulers.computation())
                .subscribe();
    }

    @Override
    public void clearMemory(Context context) {
        Glide.get(context).clearMemory();
    }

    @Override
    public void onTrimMemory(Context context, int level) {
        Glide.get(context).onTrimMemory(level);
    }
}
