package android.dreame.module.rn.bridge;

import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.transition.Transition;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewProps;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.views.image.ImageResizeMode;
import com.facebook.react.views.image.ReactImageView;

@ReactModule(name = GifImageViewManager.REACT_CLASS)
public class GifImageViewManager extends SimpleViewManager<ImageView> {
    static final String REACT_CLASS = "GifImage";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public ImageView createViewInstance(ThemedReactContext context) {
        ImageView imageView = new ImageView(context);
        return imageView;
    }

    @ReactProp(name = "src")
    public void setSource(ImageView view, @Nullable String src) {
        Glide.with(view)
                .load(src)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .into(new SimpleTarget<Drawable>() {
                    @Override
                    public void onResourceReady(@NonNull Drawable resource, @Nullable Transition<? super Drawable> transition) {
                        view.setImageDrawable(resource);
                        if (resource != null && resource instanceof GifDrawable) {
                            GifDrawable gifDrawable = (GifDrawable) resource;
                            boolean isPlay = (boolean) view.getTag();
                            if (isPlay) {
                                gifDrawable.start();
                            }
                        }
                    }
                });
    }

    @ReactProp(name = "play")
    public void setPlay(ImageView view, @Nullable Boolean play) {
        Drawable drawable = view.getDrawable();
        view.setTag(play);
        if (drawable != null && drawable instanceof GifDrawable) {
            GifDrawable gifDrawable = (GifDrawable) drawable;
            if (play) {
                gifDrawable.start();
            } else {
                gifDrawable.stop();
            }
        }
    }

    @ReactProp(name = ViewProps.RESIZE_MODE)
    public void setResizeMode(ReactImageView view, @Nullable String resizeMode) {
        view.setScaleType(ImageResizeMode.toScaleType(resizeMode));
        view.setTileMode(ImageResizeMode.toTileMode(resizeMode));
    }
}