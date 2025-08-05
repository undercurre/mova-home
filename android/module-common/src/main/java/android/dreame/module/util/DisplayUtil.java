package android.dreame.module.util;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.WindowManager;
/**
 * Created by licrynoob on 2016/guide_2/14 <br>
 * Copyright (C) 2016 <br>
 * Email:licrynoob@gmail.com <p>
 * 显示屏幕工具类
 */
public class DisplayUtil {

    /**
     * 获取屏幕尺寸与密度
     *
     * @return DisplayMetrics
     */
    public static DisplayMetrics getDisplayMetrics(Context context) {
        Resources resources;
        if (context == null) {
            resources = Resources.getSystem();
        } else {
            resources = context.getResources();
        }
        return resources.getDisplayMetrics();
    }

    /**
     * TypedValue官方源码中的算法 任意单位转换为PX单位
     *
     * @param unit           TypedValue.COMPLEX_UNIT_DIP
     * @param value          对应单位的值
     * @param displayMetrics 密度
     * @return px值
     */
    public static float applyDimension(int unit, float value, DisplayMetrics displayMetrics) {
        switch (unit) {
            case TypedValue.COMPLEX_UNIT_PX:
                return value;
            case TypedValue.COMPLEX_UNIT_DIP:
                return value * displayMetrics.density;
            case TypedValue.COMPLEX_UNIT_SP:
                return value * displayMetrics.scaledDensity;
            case TypedValue.COMPLEX_UNIT_PT:
                return value * displayMetrics.xdpi * (1.0f / 72);
            case TypedValue.COMPLEX_UNIT_IN:
                return value * displayMetrics.xdpi;
            case TypedValue.COMPLEX_UNIT_MM:
                return value * displayMetrics.xdpi * (1.0f / 25.4f);
        }
        return 0;
    }

    /**
     * px 转 dp
     *
     * @param context context
     * @param pxValue px
     * @return dp
     */
    public static float pxToDp(Context context, float pxValue) {
        DisplayMetrics displayMetrics = getDisplayMetrics(context);
        return pxValue / displayMetrics.density;
    }

    /**
     * dp 转 px
     *
     * @param context context
     * @param dpValue dp
     * @return px
     */
    public static float dpToPx(Context context, float dpValue) {
        DisplayMetrics displayMetrics = getDisplayMetrics(context);
        return applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, displayMetrics);
    }

    /**
     * px 转 sp
     *
     * @param context context
     * @param pxValue px
     * @return sp
     */
    public static float pxToSp(Context context, float pxValue) {
        DisplayMetrics displayMetrics = getDisplayMetrics(context);
        return pxValue / displayMetrics.scaledDensity;
    }

    /**
     * sp 转 px
     *
     * @param context context
     * @param spValue sp
     * @return px
     */
    public static float spToPx(Context context, float spValue) {
        DisplayMetrics displayMetrics = getDisplayMetrics(context);
        return applyDimension(TypedValue.COMPLEX_UNIT_SP, spValue, displayMetrics);
    }

    /**
     * 获得屏幕宽度
     *
     * @param context context
     * @return screenWidth
     */
    public static int getScreenWidth(Context context) {
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.widthPixels;
    }

    /**
     * 获得屏幕高度
     *
     * @param context context
     * @return
     */
    public static int getScreenHeight(Context context) {
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics.heightPixels;
    }

    /**
     * 获取屏幕最小滑动距离
     *
     * @param context context
     * @return touchSlop
     */
    public static int getTouchSlop(Context context) {
        return ViewConfiguration.get(context).getScaledTouchSlop();
    }

    /**
     * 获得状态栏的高度
     *
     * @param context context
     * @return statusHeight
     */
    public static int getStatusHeight(Context context) {
        int statusHeight = -1;
        try {
            Class<?> clazz = Class.forName("com.android.internal.R$dimen");
            Object object = clazz.newInstance();
            int height = Integer.parseInt(clazz.getField("status_bar_height").get(object).toString());
            statusHeight = context.getResources().getDimensionPixelSize(height);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return statusHeight;
    }

    /**
     * 获取当前屏幕截图，包含状态栏
     *
     * @param activity activity
     * @return screenShotWithStatusBar
     */
    public static Bitmap screenShotWithStatusBar(Activity activity) {
        View view = activity.getWindow().getDecorView();
        view.setDrawingCacheEnabled(true);
        view.buildDrawingCache();
        Bitmap bmp = view.getDrawingCache();
        int width = getScreenWidth(activity);
        int height = getScreenHeight(activity);
        Bitmap bitmap;
        bitmap = Bitmap.createBitmap(bmp, 0, 0, width, height);
        view.destroyDrawingCache();
        return bitmap;
    }

    /**
     * 获取当前屏幕截图，不包含状态栏
     *
     * @param activity activity
     * @return screenShotWithoutStatusBar
     */
    public static Bitmap screenShotWithoutStatusBar(Activity activity) {
        View view = activity.getWindow().getDecorView();
        view.setDrawingCacheEnabled(true);
        view.buildDrawingCache();
        Bitmap bmp = view.getDrawingCache();
        Rect frame = new Rect();
        activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
        int statusBarHeight = frame.top;
        int width = getScreenWidth(activity);
        int height = getScreenHeight(activity);
        Bitmap bitmap;
        bitmap = Bitmap.createBitmap(bmp, 0, statusBarHeight, width, height - statusBarHeight);
        view.destroyDrawingCache();
        return bitmap;
    }

    /**
     * 获取自定义的大小
     *
     * @param dimensionId
     * @return
     */
    public static int getPixelById(Context context, int dimensionId) {
        return context.getResources().getDimensionPixelSize(dimensionId);
    }

}
