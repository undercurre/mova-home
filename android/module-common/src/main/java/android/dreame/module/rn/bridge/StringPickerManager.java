package android.dreame.module.rn.bridge;

import android.dreame.module.view.WheelPicker;
import android.graphics.Color;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.PixelUtil;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

public class StringPickerManager extends SimpleViewManager<WheelPicker> {

    public static final String REACT_CLASS = "MHStringPicker";
    ReactApplicationContext mCallerContext;

    public StringPickerManager(ReactApplicationContext reactContext) {
        mCallerContext = reactContext;
    }

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @NonNull
    @Override
    protected WheelPicker createViewInstance(@NonNull ThemedReactContext reactContext) {
        WheelPicker wheelPicker = new WheelPicker(reactContext);
        wheelPicker.setSelectedItemTextColor(Color.parseColor("#FFAB8C5E"));
        return wheelPicker;
    }

    @ReactProp(name = "dataSource")
    public void setDataSource(WheelPicker view, @Nullable ReadableArray sources) {
        view.setData(sources.toArrayList());
    }

    @ReactProp(name = "defaultValue")
    public void setDefaultValue(WheelPicker view, @Nullable String defaultValue) {
        view.setDefaultValue(defaultValue);
    }

    @ReactProp(name = "pickerInnerStyle")
    public void setPickerInnerStyle(WheelPicker view, @Nullable ReadableMap pickerInnerStyle) {
        if (pickerInnerStyle != null) {
            if (pickerInnerStyle.hasKey("selectTextColorDreame")) {
                String textColor = pickerInnerStyle.getString("selectTextColorDreame");
                if (!TextUtils.isEmpty(textColor)) {
                    view.setSelectedItemTextColor(Color.parseColor(textColor));
                }
            }

            if (pickerInnerStyle.hasKey("selectFontSizeDreame")) {
                int fontSize = pickerInnerStyle.getInt("selectFontSizeDreame");
                view.setItemTextSize(fontSize);
            }
        }
    }

    @ReactProp(name = "innerStyle")
    public void setInnerStyle(WheelPicker view, @Nullable ReadableMap pickerInnerStyle) {
        if (pickerInnerStyle != null) {
            if (pickerInnerStyle.hasKey("textColor")) {
                String textColor = pickerInnerStyle.getString("textColor");
                view.setItemTextColor(Color.parseColor(textColor));
            }

            if (pickerInnerStyle.hasKey("selectTextColor")) {
                String textColor = pickerInnerStyle.getString("selectTextColor");
                view.setSelectedItemTextColor(Color.parseColor(textColor));
            }

            if (pickerInnerStyle.hasKey("selectBgColor")) {
                String textColor = pickerInnerStyle.getString("selectBgColor");
                view.setSelectedItemBgColor(Color.parseColor(textColor));
            }

            if (pickerInnerStyle.hasKey("unitTextColor")) {
                String textColor = pickerInnerStyle.getString("unitTextColor");
                view.setUnitTextColor(Color.parseColor(textColor));
            }

            if (pickerInnerStyle.hasKey("lineColor")) {
                String textColor = pickerInnerStyle.getString("lineColor");
                view.setIndicator(true);
                view.setIndicatorColor(Color.parseColor(textColor));
            }

            if (pickerInnerStyle.hasKey("fontSize")) {
                int fontSize = pickerInnerStyle.getInt("fontSize");
                view.setItemTextSize((int) PixelUtil.toPixelFromDIP(fontSize));
            }

            if (pickerInnerStyle.hasKey("selectFontSize")) {
                int fontSize = pickerInnerStyle.getInt("selectFontSize");
                view.setSelectedItemTextSize((int) PixelUtil.toPixelFromDIP(fontSize));
            }

            if (pickerInnerStyle.hasKey("unitFontSize")) {
                int fontSize = pickerInnerStyle.getInt("unitFontSize");
                view.setUnitTextSize((int) PixelUtil.toPixelFromDIP(fontSize));
            }

            if (pickerInnerStyle.hasKey("rowHeight")) {
                int rowHeight = pickerInnerStyle.getInt("rowHeight");
                view.setRowHeight((int) PixelUtil.toPixelFromDIP(rowHeight));
            }

            if (pickerInnerStyle.hasKey("unit")) {
                String unitText = pickerInnerStyle.getString("unit");
                view.setUnitText(unitText);
            }

            if (pickerInnerStyle.hasKey("unitTextSpace")) {
                int unitTextSpace = pickerInnerStyle.getInt("unitTextSpace");
                view.setUnitTextSpace((int) PixelUtil.toPixelFromDIP(unitTextSpace));
            }

            if (pickerInnerStyle.hasKey("unitOffsetY")) {
                int unitTextSpace = pickerInnerStyle.getInt("unitOffsetY");
                view.setUnitOffsetY((int) PixelUtil.toPixelFromDIP(unitTextSpace));
            }
        }
    }

    @Nullable
    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put("onWheelSelected", MapBuilder.of(
                        "phasedRegistrationNames",
                        MapBuilder.of("bubbled", "onValueChanged")))
                .build();
    }
}
