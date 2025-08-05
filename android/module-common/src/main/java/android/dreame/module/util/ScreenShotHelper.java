package android.dreame.module.util;

import android.app.Activity;
import android.app.Application;
import android.content.ContentResolver;
import android.database.ContentObserver;
import android.database.Cursor;
import android.dreame.module.LocalApplication;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.FileObserver;
import android.os.Handler;
import android.os.HandlerThread;
import android.provider.MediaStore;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.hjq.permissions.Permission;
import com.hjq.permissions.XXPermissions;

import java.io.File;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/03/23
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class ScreenShotHelper {
    private static final String TAG = "ScreenShot";
    private static final String[] MEDIA_PROJECTIONS = {
            MediaStore.Images.ImageColumns.DATA,
            MediaStore.Images.ImageColumns.DATE_TAKEN,
            MediaStore.Images.ImageColumns.DATE_ADDED,
    };

    /**
     * 截屏依据中的路径判断关键字
     */
    private static final String[] KEYWORDS = {
            "screenshot", "screen_shot", "screen-shot", "screen shot", "screencapture",
            "screen_capture", "screen-capture", "screen capture", "screencap", "screen_cap",
            "screen-cap", "screen cap", "截屏", "截图"
    };

    private ContentResolver mContentResolver;
    private CallbackListener mCallbackListener;
    private MediaContentObserver mInternalObserver;
    private MediaContentObserver mExternalObserver;
    private static ScreenShotHelper mInstance;

    private String SCREEN_SHOT_DCIM_DIR = Environment.getExternalStorageDirectory() + File.separator
            + Environment.DIRECTORY_DCIM + File.separator + "Screenshots";
    private String SCREEN_SHOT_PICTURES_DIR = Environment.getExternalStorageDirectory() + File.separator
            + Environment.DIRECTORY_PICTURES + File.separator + "Screenshots";
    ;

    private FileObserver SCREEN_SHOT_DCIM_DIR_OBSERVER = new FileObserver(SCREEN_SHOT_DCIM_DIR + File.separator, FileObserver.ALL_EVENTS) {
        @Override
        public void onEvent(int event, @Nullable String path) {
            if (path != null) {
                String newPath = new File(SCREEN_SHOT_DCIM_DIR, path).getAbsolutePath();
                handleFileEvent(event, newPath);
            }
        }
    };

    private FileObserver SCREEN_SHOT_PICTURES_DIR_OBSERVER = new FileObserver(SCREEN_SHOT_PICTURES_DIR + File.separator, FileObserver.ALL_EVENTS) {
        @Override
        public void onEvent(int event, @Nullable String path) {
            if (path != null) {
                String newPath = new File(SCREEN_SHOT_PICTURES_DIR, path).getAbsolutePath();
                handleFileEvent(event, newPath);
            }
        }
    };

    private boolean fileWatching = false;

    private ScreenShotHelper() {
    }

    /**
     * 获取 ScreenShot 对象
     *
     * @return ScreenShot对象
     */
    public static ScreenShotHelper getInstance() {
        if (mInstance == null) {
            synchronized (ScreenShotHelper.class) {
                mInstance = new ScreenShotHelper();
            }
        }
        return mInstance;
    }

    /**
     * 注册
     *
     * @param application
     * @param callbackListener 回调监听
     */
    public void register(Application application, CallbackListener callbackListener) {
        mCallbackListener = callbackListener;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            Activity.ScreenCaptureCallback screenCaptureCallback = new Activity.ScreenCaptureCallback() {
                @Override
                public void onScreenCaptured() {
                    if (mCallbackListener != null) {
                        mCallbackListener.onShot("");
                    }
                }
            };
            application.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
                @Override
                public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

                }

                @Override
                public void onActivityStarted(@NonNull Activity activity) {
                    activity.registerScreenCaptureCallback(activity.getMainExecutor(), screenCaptureCallback);
                }

                @Override
                public void onActivityResumed(@NonNull Activity activity) {

                }

                @Override
                public void onActivityPaused(@NonNull Activity activity) {

                }

                @Override
                public void onActivityStopped(@NonNull Activity activity) {
                    activity.unregisterScreenCaptureCallback(screenCaptureCallback);
                }

                @Override
                public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

                }

                @Override
                public void onActivityDestroyed(@NonNull Activity activity) {

                }
            });
        } else {
            mContentResolver = application.getContentResolver();

            HandlerThread handlerThread = new HandlerThread(TAG);
            handlerThread.start();
            Handler handler = new Handler(handlerThread.getLooper());

            mInternalObserver = new MediaContentObserver(MediaStore.Images.Media.INTERNAL_CONTENT_URI, handler);
            mExternalObserver = new MediaContentObserver(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, handler);

            mContentResolver.registerContentObserver(MediaStore.Images.Media.INTERNAL_CONTENT_URI,
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q, mInternalObserver);
            mContentResolver.registerContentObserver(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q, mExternalObserver);
            if (XXPermissions.isGranted(LocalApplication.getInstance(), Permission.READ_MEDIA_IMAGES)) {
                startWatchingFileDir();
            }
        }
    }

    public void startWatchingFileDir() {
        SCREEN_SHOT_DCIM_DIR_OBSERVER.stopWatching();
        SCREEN_SHOT_PICTURES_DIR_OBSERVER.stopWatching();

        SCREEN_SHOT_DCIM_DIR_OBSERVER.startWatching();
        SCREEN_SHOT_PICTURES_DIR_OBSERVER.startWatching();
        fileWatching = true;
    }

    private void handleFileEvent(int event, String path) {
        if (event == FileObserver.CREATE) {
            LogUtil.d(TAG, "handleFileEvent: " + event + ",path" + path);
            if (mCallbackListener != null) {
                mCallbackListener.onShot(path);
            }
        }
    }

    /**
     * 注销
     */
    public void unregister() {
        if (mContentResolver != null) {
            mContentResolver.unregisterContentObserver(mInternalObserver);
            mContentResolver.unregisterContentObserver(mExternalObserver);
        }
    }

    private void handleMediaContentChange(Uri uri) {
        Cursor cursor = null;
        try {
            // 数据改变时，查询数据库中最后加入的一条数据
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                Bundle bundle = new Bundle();
                bundle.putStringArray(ContentResolver.QUERY_ARG_SORT_COLUMNS, new String[]{MediaStore.Images.ImageColumns.DATE_ADDED});
                bundle.putInt(ContentResolver.QUERY_ARG_SORT_DIRECTION, ContentResolver.QUERY_SORT_DIRECTION_DESCENDING);
                bundle.putInt(ContentResolver.QUERY_ARG_LIMIT, 1);
                bundle.putInt(ContentResolver.QUERY_ARG_OFFSET, 0);
                cursor = mContentResolver.query(uri, MEDIA_PROJECTIONS, bundle, null);
            } else {
                cursor = mContentResolver.query(uri, MEDIA_PROJECTIONS, null, null,
                        MediaStore.Images.ImageColumns.DATE_ADDED + " desc limit 1");
            }

            if (cursor == null) {
                return;
            }
            if (!cursor.moveToFirst()) {
                return;
            }
            int dataIndex = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
            int dateTaken = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATE_TAKEN);
            int dateAddedIndex = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATE_ADDED);
            Log.i(TAG, "handleMediaContentChange: " + cursor.getString(dataIndex) + "，" + cursor.getLong(dateTaken) + "," + cursor.getLong(dateAddedIndex));
            handleMediaRowData(cursor.getString(dataIndex), cursor.getLong(dateTaken));
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
    }

    /**
     * 处理监听到的资源
     */
    private void handleMediaRowData(String path, long dateAdded) {
        long duration = 0;
        long step = 100;
        while (checkScreenShot(path, dateAdded) && duration <= 500) {
            try {
                duration += step;
                Thread.sleep(step);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        if (checkScreenShot(path, dateAdded)) {
            if (mCallbackListener != null) {
                mCallbackListener.onShot(path);
            }
        }
    }

    /**
     * 判断是否是截屏
     */
    private boolean checkScreenShot(String data, long dateTaken) {
        if (data == null) {
            return false;
        }
        data = data.toLowerCase();
        // 判断图片路径是否含有指定的关键字之一, 如果有, 则认为当前截屏了
        for (String keyWork : KEYWORDS) {
            if (data.contains(keyWork)) {
                return true;
            }
        }
        return false;
    }

    private static long lastTime = 0;

    /**
     * 媒体内容观察者
     */
    private class MediaContentObserver extends ContentObserver {
        private Uri mUri;

        MediaContentObserver(Uri uri, Handler handler) {
            super(handler);
            mUri = uri;
        }

        @Override
        public void onChange(boolean selfChange, @Nullable Uri uri, int flag) {
            if (XXPermissions.isGranted(LocalApplication.getInstance(), Permission.READ_MEDIA_IMAGES)) {
                if (!fileWatching) {
                    startWatchingFileDir();
                }
            } else {
                mCallbackListener.onPermissionRequest();
            }
        }
    }


    /**
     * 回调监听器
     */
    public interface CallbackListener {
        /**
         * 截屏
         *
         * @param path 图片路径
         */
        void onShot(String path);

        void onPermissionRequest();
    }
}