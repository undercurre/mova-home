package android.dreame.module.view;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.util.Base64;

import androidx.appcompat.widget.AppCompatImageView;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

public class NoFilterImageView extends AppCompatImageView {
    private String uri = "";
    private Bitmap bitmap = null;
    private BitmapDrawable bitmapDrawable;

    public NoFilterImageView(Context context) {
        super(context);
    }

    public void setSource(ReadableArray sources) {
        if (sources != null && sources.size() != 0) {
            ReadableMap source = sources.getMap(0);
            if (!uri.equals(source.getString("uri")) || getDrawable() == null) {
                uri = source.getString("uri");
                byte[] decode = Base64.decode(uri.split(",")[1], Base64.DEFAULT);
                bitmap = BitmapFactory.decodeByteArray(decode, 0, decode.length);
                bitmapDrawable = new BitmapDrawable(getResources(), bitmap);
                bitmapDrawable.getPaint().setFilterBitmap(false);
                setImageDrawable(bitmapDrawable);
            }
        }
    }
}