package android.dreame.module.rn.bridge;

import android.dreame.module.util.ScreenUtils;
import android.view.MotionEvent;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.HashMap;
import java.util.Map;

@ReactModule(name = RockerViewManager.REACT_CLASS)
public class RockerViewManager extends SimpleViewManager<View> {
    float mLastX;
    float mLastY;
    static final String REACT_CLASS = "RockerView";

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @NonNull
    @Override
    protected View createViewInstance(@NonNull ThemedReactContext context) {
        View rockerView = new View(context);
        rockerView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                WritableMap params = Arguments.createMap();
                params.putInt("id", v.getId());
                context.getJSModule(RCTEventEmitter.class).receiveEvent(rockerView.getId(), "onClick", params);
            }
        });
        rockerView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                int dx = 0;
                int dy = 0;
                float x = ScreenUtils.px2dp(context, event.getX());
                float y = ScreenUtils.px2dp(context, event.getY());
                float rawX = ScreenUtils.px2dp(context, event.getRawX());
                float rawY = ScreenUtils.px2dp(context, event.getRawY());
                String eventName = "";
                if (event.getAction() == MotionEvent.ACTION_DOWN) {
                    mLastX = x;
                    mLastY = y;
                    eventName = "onGestureStart";
                } else if (event.getAction() == MotionEvent.ACTION_MOVE) {
                    dx = (int) (x - mLastX);
                    dy = (int) (y - mLastY);
                    eventName = "onGestureMove";
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                    eventName = "onGestureEnd";
                    mLastX = 0;
                    mLastY = 0;
                }
                WritableMap params = Arguments.createMap();
                params.putInt("addx", dx);
                params.putInt("addy", dy);
                params.putDouble("x", x);
                params.putDouble("y", y);
                params.putDouble("rawX", rawX);
                params.putDouble("rawY", rawY);
                context.getJSModule(RCTEventEmitter.class).receiveEvent(rockerView.getId(), eventName, params);
                return true;
            }
        });
        return rockerView;
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        Map<String, Object> map = new HashMap<>();
        map.put("onGestureStart", MapBuilder.of("registrationName", "onGestureStart"));
        map.put("onGestureMove", MapBuilder.of("registrationName", "onGestureMove"));
        map.put("onGestureEnd", MapBuilder.of("registrationName", "onGestureEnd"));
        map.put("onClick", MapBuilder.of("registrationName", "onClick"));
        return map;
    }
}
