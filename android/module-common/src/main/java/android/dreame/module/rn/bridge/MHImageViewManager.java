package android.dreame.module.rn.bridge;

import android.dreame.module.view.NoFilterImageView;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

@ReactModule(name = MHImageViewManager.REACT_CLASS)
public class MHImageViewManager extends SimpleViewManager<NoFilterImageView> {
    static final String REACT_CLASS = "MHImageView";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public NoFilterImageView createViewInstance(ThemedReactContext context) {
        return new NoFilterImageView(context);
    }

    @ReactProp(name = "src")
    public void setSource(NoFilterImageView view, @Nullable ReadableArray sources) {
        view.setSource(sources);
    }

}