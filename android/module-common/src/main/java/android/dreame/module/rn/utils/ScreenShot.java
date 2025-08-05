package android.dreame.module.rn.utils;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Looper;
import android.util.LruCache;
import android.view.View;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.ScrollView;

import androidx.recyclerview.widget.RecyclerView;

import java.io.FileOutputStream;
import java.util.ArrayList;

public class ScreenShot {
    private static ScreenShot screenShot;
    private Handler mWorkHandler = new Handler(Looper.getMainLooper());
    private boolean isLoading = false;

    private ScreenShot() {
    }

    public static ScreenShot getInstance() {
        if (screenShot == null) {
            synchronized (ScreenShot.class) {
                if (screenShot == null) {
                    screenShot = new ScreenShot();
                }
            }
        }
        return screenShot;
    }

    public void generate(View view, Rect rect, String path, OnGenerateListener listener) {
        if (isLoading) {
            listener.onGenerateFinished(new Throwable());
            return;
        }
        mWorkHandler.post(() -> {
            Exception exception = null;
            try {
                isLoading = true;
                Bitmap bitmap = createBitmap(view, rect);
                FileOutputStream fout = new FileOutputStream(path);
                bitmap.compress(Bitmap.CompressFormat.PNG, 80, fout);
                bitmap.recycle();
                bitmap = null;
                fout.flush();
                fout.close();
                isLoading = false;
            } catch (Exception e) {
                isLoading = false;
                e.printStackTrace();
            }
            if (listener != null) {
                final Exception exception1 = exception;
                listener.onGenerateFinished(exception1);
            }
        });
    }

    private Bitmap createBitmap(View view, Rect rect) {
        // view.setDrawingCacheEnabled(true);
        // view.buildDrawingCache(true);
        int width = view.getWidth();
        int height = view.getHeight();
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        view.draw(canvas);
        Bitmap bitmap2 = Bitmap.createBitmap(bitmap, rect.left, rect.top, rect.width(), rect.height());
        return bitmap2;
        // view.setDrawingCacheEnabled(false);
        // view.destroyDrawingCache();
        // return bitmap;
    }

    public static Bitmap captureFromSV(ScrollView scrollView) {
        int i = 0;
        for (int i2 = 0; i2 < scrollView.getChildCount(); i2++) {
            i += scrollView.getChildAt(i2).getHeight();
            scrollView.getChildAt(i2).setBackgroundColor(-1);
        }
        Bitmap createBitmap = Bitmap.createBitmap(scrollView.getWidth(), i, Bitmap.Config.RGB_565);
        scrollView.draw(new Canvas(createBitmap));
        return createBitmap;
    }

    public static Bitmap captureFromRV(RecyclerView recyclerView) {
        RecyclerView.Adapter adapter = recyclerView.getAdapter();
        if (adapter == null) {
            return null;
        }
        int itemCount = adapter.getItemCount();
        Paint paint = new Paint();
        LruCache lruCache = new LruCache(((int) (Runtime.getRuntime().maxMemory() / 1024)) / 8);
        int i = 0;
        for (int i2 = 0; i2 < itemCount; i2++) {
            RecyclerView.ViewHolder createViewHolder = adapter.createViewHolder(recyclerView, adapter.getItemViewType(i2));
            adapter.onBindViewHolder(createViewHolder, i2);
            createViewHolder.itemView.measure(View.MeasureSpec.makeMeasureSpec(recyclerView.getWidth(), View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
            createViewHolder.itemView.layout(0, 0, createViewHolder.itemView.getMeasuredWidth(), createViewHolder.itemView.getMeasuredHeight());
            createViewHolder.itemView.setDrawingCacheEnabled(true);
            createViewHolder.itemView.buildDrawingCache();
            Bitmap drawingCache = createViewHolder.itemView.getDrawingCache();
            if (drawingCache != null) {
                lruCache.put(String.valueOf(i2), drawingCache);
            }
            i += createViewHolder.itemView.getMeasuredHeight();
        }
        Bitmap createBitmap = Bitmap.createBitmap(recyclerView.getMeasuredWidth(), i, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(createBitmap);
        Drawable background = recyclerView.getBackground();
        if (background instanceof ColorDrawable) {
            canvas.drawColor(((ColorDrawable) background).getColor());
        }
        int i3 = 0;
        for (int i4 = 0; i4 < itemCount; i4++) {
            Bitmap bitmap = (Bitmap) lruCache.get(String.valueOf(i4));
            canvas.drawBitmap(bitmap, 0.0f, (float) i3, paint);
            i3 += bitmap.getHeight();
            bitmap.recycle();
        }
        return createBitmap;
    }

    public static Bitmap captureFromLV(ListView listView) {
        ListAdapter adapter = listView.getAdapter();
        int count = adapter.getCount();
        ArrayList arrayList = new ArrayList();
        int i = 0;
        for (int i2 = 0; i2 < count; i2++) {
            View view = adapter.getView(i2, null, listView);
            view.measure(View.MeasureSpec.makeMeasureSpec(listView.getWidth(), View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
            view.layout(0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());
            view.setDrawingCacheEnabled(true);
            view.buildDrawingCache();
            arrayList.add(view.getDrawingCache());
            i += view.getMeasuredHeight();
        }
        Bitmap createBitmap = Bitmap.createBitmap(listView.getMeasuredWidth(), i, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(createBitmap);
        Paint paint = new Paint();
        int i3 = 0;
        for (int i4 = 0; i4 < arrayList.size(); i4++) {
            Bitmap bitmap = (Bitmap) arrayList.get(i4);
            canvas.drawBitmap(bitmap, 0.0f, (float) i3, paint);
            i3 += bitmap.getHeight();
            bitmap.recycle();
        }
        return createBitmap;
    }


    public interface OnGenerateListener {

        void onGenerateFinished(Throwable throwable);

    }
}
