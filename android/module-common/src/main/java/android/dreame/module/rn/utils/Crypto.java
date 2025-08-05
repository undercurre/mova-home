package android.dreame.module.rn.utils;

import android.dreame.module.util.LogUtil;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.DashPathEffect;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.util.Base64;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;

public class Crypto {
    private static final String TAG = "Crypto";

    public String pointsToImageBase64(int width, int height, String pointStr, String colorStr) throws JSONException {
        JSONObject jSONObject = new JSONObject(colorStr);
        HashMap<String, Integer> hashMap = new HashMap<>();
        Iterator<String> keys = jSONObject.keys();

        while (keys.hasNext()) {
            String next = keys.next();
            hashMap.put(next, Color.parseColor(jSONObject.getString(next)));
        }
        int[] iArr = new int[width * height];
        split(pointStr, ",", new MyConsumer<String>() {
            @Override
            public void accept(int index, String s) {
                iArr[index] = hashMap.get(s);
            }
        });

        Matrix matrix = new Matrix();
        matrix.setScale(1.0f, -1.0f);
        Bitmap createBitmap = Bitmap.createBitmap(iArr, width, height, Bitmap.Config.ARGB_8888);
        Bitmap createBitmap2 = Bitmap.createBitmap(createBitmap, 0, 0, width, height, matrix, true);
        String imgStr = bitmapToBase64(createBitmap2);
        createBitmap.recycle();
        createBitmap2.recycle();
        return imgStr;
    }

    private String bitmapToBase64(Bitmap bitmap) {
        String result = null;
        ByteArrayOutputStream baos = null;
        try {
            if (bitmap != null) {
                baos = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.PNG, 80, baos);
                try {
                    baos.flush();
                    baos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                byte[] bitmapBytes = baos.toByteArray();
                result = Base64.encodeToString(bitmapBytes, Base64.NO_WRAP);
                bitmap.recycle();
                bitmap = null;
            }
        } finally {
            try {
                if (baos != null) {
                    baos.flush();
                    baos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public String createTracesImageBase64(int width, int height, String traces) {
        LogUtil.v(TAG, "createTracesImageBase64 width: " + width + " height: " + height);

        String base64Image = "";
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        canvas.drawColor(Color.TRANSPARENT);
        Paint paint = new Paint();
        paint.setAntiAlias(true);
        paint.setStrokeJoin(Paint.Join.ROUND);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC));
        try {
            JSONArray lines = new JSONArray(traces);
            for (int i = 0; i < lines.length(); i++) {
                JSONObject line = lines.getJSONObject(i);
                String color = "#FFFFFFFF";
                if (line.has("color")) {
                    color = line.getString("color");
                }

                float strokeWidth = 2f;
                if (line.has("width")) {
                    strokeWidth = (float) line.getDouble("width");
                }
                paint.setStrokeWidth((float) strokeWidth);
                int type = 0;
                if (line.has("type")) {
                    type = line.getInt("type");
                }
                if (type == 1) {
                    float[] dash = new float[]{10, 10};
                    if (line.has("dash")) {
                        JSONArray dashArr = line.getJSONArray("dash");
                        if (dashArr.length() == 2) {
                            dash[0] = (float) dashArr.getDouble(0);
                            dash[1] = (float) dashArr.getDouble(1);
                        }
                    }
                    paint.setPathEffect(new DashPathEffect(dash, 0));
                } else {
                    paint.setPathEffect(null);
                }

                JSONArray pointsValue = line.getJSONArray("points");
                if (pointsValue.length() % 2 != 0 && pointsValue.length() >= 4) {
                    throw new Exception("points in json must has even length");
                }
                int pointsLength = pointsValue.length() / 2;
                int fillColor = 0;
                if (line.has("fillColor")) {
                    String fillColorStr = line.getString("fillColor");
                    fillColor = Color.parseColor(fillColorStr);
                }
                Path p = new Path();
                p.moveTo((float) pointsValue.getDouble(0), height - (float) pointsValue.getDouble(1));
                for (int j = 1; j < pointsLength; j++) {
                    p.lineTo((float) pointsValue.getDouble(2 * j), height - (float) pointsValue.getDouble(2 * j + 1));
                }
                paint.setStyle(fillColor != 0 ? Paint.Style.FILL : Paint.Style.STROKE);
                paint.setColor(fillColor != 0 ? fillColor : Color.parseColor(color));
                paint.setAntiAlias(true);
                canvas.drawPath(p, paint);
            }

            ByteArrayOutputStream fos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.PNG, 80, fos);
            byte[] data = fos.toByteArray();
            base64Image = Base64.encodeToString(data, Base64.DEFAULT);
            bitmap.recycle();
            bitmap = null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return base64Image;
    }

    public void split(final String str, final String separatorChar, MyConsumer<String> onSplit) {
        int fromIndex = 0;
        int index = 0;
        while (true) {
            int indexOf = str.indexOf(separatorChar, fromIndex);
            if (indexOf == -1) {
                break;
            }
            String substring = str.substring(fromIndex, indexOf);
            onSplit.accept(index, substring);
            fromIndex = indexOf + 1;
            index++;
        }
    }

    public interface MyConsumer<T> {
        void accept(int index, T t);
    }
}
