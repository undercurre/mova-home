package android.dreame.module.rn.utils;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.dreame.module.LocalApplication;
import android.graphics.BitmapFactory;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.RequiresApi;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class MediaStoreUtil {
    @RequiresApi(api = 8)
    private static final String DCIM_NAME = Environment.DIRECTORY_DCIM;

    public static class MediaInfoBean {
        public int outWidth;
        public int outHeight;
        public String imageMimeType;
        public int videoWidth;
        public int videoHeight;
        public String videoMimeType;
        public int videoDuration;
    }

    public static class AccessMediaError extends RuntimeException {
        private int mErrorCode;

        public AccessMediaError(int errorCode) {
            this(errorCode, "");
        }

        public AccessMediaError(int errorCode, String message) {
            super(message);
            this.mErrorCode = errorCode;
        }

        public AccessMediaError(int errorCode, Throwable th) {
            super(th);
            this.mErrorCode = errorCode;
        }

        public int getErrorCode() {
            return this.mErrorCode;
        }
    }

    private static MediaInfoBean parseImageInfo(String str) throws AccessMediaError {
        try {
            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inJustDecodeBounds = true;
            BitmapFactory.decodeFile(str, options);
            MediaInfoBean bean = new MediaInfoBean();
            bean.outWidth = options.outWidth;
            bean.outHeight = options.outHeight;
            bean.imageMimeType = options.outMimeType;
            return bean;
        } catch (Throwable throwable) {
            throw new AccessMediaError(-6, throwable);
        }
    }

    private static MediaInfoBean parseVideo(String str) {
        try {
            MediaInfoBean bean = new MediaInfoBean();
            MediaMetadataRetriever mediaMetadataRetriever = new MediaMetadataRetriever();
            mediaMetadataRetriever.setDataSource(str);
            bean.videoWidth = Integer.parseInt(mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH));
            bean.videoHeight = Integer.parseInt(mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT));
            bean.videoMimeType = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE);
            bean.videoDuration = Integer.parseInt(mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
            mediaMetadataRetriever.release();
            return bean;
        } catch (Throwable throwable) {
            throw new AccessMediaError(-7, throwable);
        }
    }


    public static void insertImage(Context context, String filePath, String albumName, String displayName) throws AccessMediaError {
        if (TextUtils.isEmpty(filePath)) {
            throw new AccessMediaError(-1);
        } else if (new File(filePath).exists()) {
            if (context == null) {
                context = LocalApplication.getInstance().getApplicationContext();
            }
            MediaInfoBean infoBean = parseImageInfo(filePath);
            long currentTimeMillis = System.currentTimeMillis();
            ContentResolver contentResolver = context.getContentResolver();
            Uri uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
            ContentValues contentValues = new ContentValues();
            contentValues.put("width", Integer.valueOf(infoBean.outWidth));
            contentValues.put("height", Integer.valueOf(infoBean.outHeight));
            contentValues.put("mime_type", infoBean.imageMimeType);
            contentValues.put("_display_name", displayName);
            contentValues.put("date_added", Long.valueOf(currentTimeMillis));
            contentValues.put("date_modified", Long.valueOf(currentTimeMillis));
            contentValues.put("datetaken", Long.valueOf(currentTimeMillis));
            if (Build.VERSION.SDK_INT >= 29) {
                if (!TextUtils.isEmpty(albumName)) {
                    contentValues.put("relative_path", DCIM_NAME + File.separator + albumName);
                }
                contentValues.put("is_pending", 1);
                contentValues.put("date_expires", Long.valueOf((System.currentTimeMillis() + 86400000)));
            } else if (!TextUtils.isEmpty(albumName)) {
                File file = new File(Environment.getExternalStoragePublicDirectory(DCIM_NAME), albumName);
                if (!file.exists()) {
                    file.mkdirs();
                }
                contentValues.put(MediaStore.Images.Media.DATA, new File(file, displayName).getAbsolutePath());
            }
            try {
                Uri insert = contentResolver.insert(uri, contentValues);
                if (insert != null) {
                    try {
                        writeFile(new FileInputStream(filePath), contentResolver.openOutputStream(insert));
                        if (Build.VERSION.SDK_INT >= 29) {
                            contentValues.put("is_pending", 0);
                            contentValues.putNull("date_expires");
                            contentResolver.update(insert, contentValues, null, null);
                        }
                    } catch (IOException e) {
                        contentResolver.delete(insert, null, null);
                        Log.e("MediaStoreUtil", "insertImage error:" + Log.getStackTraceString(e));
                        throw new AccessMediaError(-2);
                    }
                } else {
                    Log.e("MediaStoreUtil", "insertImage error,pendingUri=null");
                    throw new AccessMediaError(-3);
                }
            } catch (Exception e2) {
                Log.e("MediaStoreUtil", "insertImage error,resolver.insert exception:" + e2.getMessage());
                throw new AccessMediaError(-3);
            }
        } else {
            throw new AccessMediaError(-1);
        }
    }

    public static void insertVideo(Context context, String filePath, String albumName, String displayName) throws AccessMediaError {
        if (TextUtils.isEmpty(filePath)) {
            throw new AccessMediaError(-1);
        } else if (new File(filePath).exists()) {
            if (context == null) {
                context = LocalApplication.getInstance().getApplicationContext();
            }
            MediaInfoBean infoBean = parseVideo(filePath);
            long currentTimeMillis = System.currentTimeMillis();
            ContentResolver contentResolver = context.getContentResolver();
            Uri uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
            ContentValues contentValues = new ContentValues();
            contentValues.put("width", Integer.valueOf(infoBean.videoWidth));
            contentValues.put("height", Integer.valueOf(infoBean.videoHeight));
            contentValues.put("mime_type", infoBean.videoMimeType);
            contentValues.put("duration", Integer.valueOf(infoBean.videoDuration));
            contentValues.put("_display_name", displayName);
            contentValues.put("date_added", Long.valueOf(currentTimeMillis));
            contentValues.put("date_modified", Long.valueOf(currentTimeMillis));
            contentValues.put("datetaken", Long.valueOf(currentTimeMillis));
            if (Build.VERSION.SDK_INT >= 29) {
                if (!TextUtils.isEmpty(albumName)) {
                    contentValues.put("relative_path", DCIM_NAME + File.separator + albumName);
                }
                contentValues.put("is_pending", 1);
                contentValues.put("date_expires", Long.valueOf((System.currentTimeMillis() + 86400000)));
            } else if (!TextUtils.isEmpty(albumName)) {
                File file = new File(Environment.getExternalStoragePublicDirectory(DCIM_NAME), albumName);
                if (!file.exists()) {
                    file.mkdirs();
                }
                contentValues.put(MediaStore.Images.Media.DATA, new File(file, displayName).getAbsolutePath());
            }
            try {
                Uri insert = contentResolver.insert(uri, contentValues);
                if (insert != null) {
                    try {
                        writeFile(new FileInputStream(filePath), contentResolver.openOutputStream(insert));
                        if (Build.VERSION.SDK_INT >= 29) {
                            contentValues.put("is_pending", 0);
                            contentValues.putNull("date_expires");
                            contentResolver.update(insert, contentValues, null, null);
                        }
                    } catch (IOException e) {
                        contentResolver.delete(insert, null, null);
                        throw new AccessMediaError(-2);
                    }
                } else {
                    Log.e("MediaStoreUtil", "insertVideo error,pendingUri=null");
                    throw new AccessMediaError(-3);
                }
            } catch (Exception e2) {
                Log.e("MediaStoreUtil", "insertVideo error,resolver.insert exception:" + e2.getMessage());
                throw new AccessMediaError(-3);
            }
        } else {
            throw new AccessMediaError(-1);
        }
    }

    private static long writeFile(InputStream inputStream, OutputStream outputStream) throws IOException {
        long progress = 0;
        if (outputStream == null) {
            return 0;
        }
        byte[] bArr = new byte[16384];
        BufferedInputStream bufferedInputStream = new BufferedInputStream(inputStream);
        try {
            BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(outputStream);
            while (true) {
                try {
                    int read = bufferedInputStream.read(bArr);
                    if (read != -1) {
                        bufferedOutputStream.write(bArr, 0, read);
                        progress += read;
                    } else {
                        bufferedOutputStream.flush();
                        bufferedInputStream.close();
                        bufferedOutputStream.close();
                        return progress;
                    }
                } catch (IOException throwable) {
                    bufferedInputStream.close();
                    bufferedOutputStream.close();
                    throw throwable;
                }
            }
        } catch (IOException throwable) {
            bufferedInputStream.close();
            throw throwable;
        }
    }

}
