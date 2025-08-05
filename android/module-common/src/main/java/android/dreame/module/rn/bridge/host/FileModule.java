package android.dreame.module.rn.bridge.host;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.dreame.module.BuildConfig;
import android.dreame.module.LocalApplication;
import android.dreame.module.rn.bridge.rawdata.DiskLruCachePic;
import android.dreame.module.rn.bridge.rawdata.DownloadAndDecodeFileUtils;
import android.dreame.module.rn.net.RNNetRequest;
import android.dreame.module.rn.net.RNNetRequestCallBack;
import android.dreame.module.rn.utils.MediaStoreUtil;
import android.dreame.module.rn.utils.ScreenShot;
import android.dreame.module.rn.viewshot.ViewShot;
import android.dreame.module.util.DisplayUtil;
import android.dreame.module.util.download.CommonPluginManager;
import android.dreame.module.util.download.DownloadFileUtils;
import android.dreame.module.util.download.DownloadTask;
import android.dreame.module.util.download.EndCause;
import android.dreame.module.util.download.SimpleOnDownloadListener;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.text.TextUtils;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.webkit.MimeTypeMap;
import android.widget.ListView;
import android.widget.ScrollView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.blankj.utilcode.util.EncodeUtils;
import com.blankj.utilcode.util.EncryptUtils;
import com.blankj.utilcode.util.FileIOUtils;
import com.blankj.utilcode.util.FileUtils;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.uimanager.UIManagerModule;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.Iterator;
import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;

public class FileModule extends ReactContextBaseJavaModule {
    private static String CACHEDIR = "";
    private String VIDEO_PATH;
    private String FILE_PATH;
    private String PIC_PATH;
    private String CACHE_PATH;

    public FileModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        CACHEDIR = reactContext.getFilesDir() + File.separator + "plugin-data-cache";
        final File file = new File(CACHEDIR);
        if (!file.exists()) {
            file.mkdir();
        }
        CACHEDIR += File.separator;
        DiskLruCachePic.INSTANCE.open(new File(getPicCachePath()), DiskLruCachePic.MAX_CACHE_SIZE);

        String pluginCache = CACHEDIR + "plugin_cache" + File.separator;
        VIDEO_PATH = pluginCache + "video" + File.separator;
        FILE_PATH = pluginCache + "file" + File.separator;
        PIC_PATH = pluginCache + "picture" + File.separator;
        CACHE_PATH = pluginCache + "cache" + File.separator;

    }

    /**
     * @return
     */
    public static String getPicCachePath() {
        return getPluginCachePath() + "cache" + File.separator;
    }

    public static String getPicPath() {
        return getPluginCachePath() + "picture" + File.separator;
    }

    public static String getRecordPath() {
        return getPluginCachePath() + "record" + File.separator;
    }

    public static String getPluginCachePath() {
        return LocalApplication.getInstance().getFilesDir() + File.separator + "plugin_cache" + File.separator;
    }

    @NonNull
    @Override
    public String getName() {
        return "File";
    }

    @ReactMethod
    public void screenShotInRect(String imageName, int l1, int t1, int w1, int h1, Callback callback) {
        Activity context = getCurrentActivity();
        if (isActivityValid()) {
            float l = DisplayUtil.dpToPx(context, l1);
            float t = DisplayUtil.dpToPx(context, t1);
            float w = DisplayUtil.dpToPx(context, w1);
            float h = DisplayUtil.dpToPx(context, h1);
            if (l < 0) {
                l = 0;
            } else if (l + w > DisplayUtil.getScreenWidth(context)) {
                l = DisplayUtil.getScreenWidth(context) - w;
            }
            float r = l + w;
            float b = t + h;
            String targetPath = CACHEDIR + imageName;
            ScreenShot.getInstance().generate(context.getWindow().getDecorView().getRootView(), new Rect((int) l, (int) t, (int) r, (int) b), targetPath, new ScreenShot.OnGenerateListener() {
                @Override
                public void onGenerateFinished(Throwable throwable) {
                    //出错不处理继续返回图片地址
                    callback.invoke(true, targetPath);
                }
            });
        }
    }

    @ReactMethod
    public void copyFileToCache(String fileName, String filePath, String fileUrl, Callback callback) {
        if (filePath == null || filePath.length() == 0) {
            callback.invoke(false, "filePath is null");
            return;
        }
        if (fileUrl == null || fileUrl.length() == 0) {
            callback.invoke(false, "fileUrl is null");
            return;
        }
        int index = fileUrl.indexOf("?");
        String fileUrlSub = fileUrl;
        if (index > 0) {
            fileUrlSub = fileUrl.substring(0, index);
        }
        String fileKey = EncryptUtils.encryptMD5ToString(fileUrlSub);
        if (BuildConfig.DEBUG) {
            Log.d("sunzhibin", "DiskLruCachePic:get start " + fileKey);
        }
        if (new File(filePath).getName().endsWith(".mp4")) {
            String saveFilePath = VIDEO_PATH + fileName;
            FileUtils.copy(filePath, saveFilePath);
            DiskLruCachePic.INSTANCE.put(fileKey, saveFilePath);
            callback.invoke(Boolean.TRUE, saveFilePath);
        } else {
            String s = EncodeUtils.base64Encode2String(FileIOUtils.readFile2BytesByChannel(filePath));
            DiskLruCachePic.INSTANCE.put(fileKey, s);
            callback.invoke(Boolean.TRUE, fileKey);
        }


    }

    @ReactMethod
    public void readFileToBase64(String imageName, Promise promise) {
        File file = new File(CACHEDIR + imageName);
        try {
            FileInputStream fis = new FileInputStream(file);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            byte[] b = new byte[1024];
            int n;
            while ((n = fis.read(b)) != -1) {
                bos.write(b, 0, n);
            }
            fis.close();
            promise.resolve(Base64.encodeToString(bos.toByteArray(), Base64.DEFAULT));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            promise.reject("-1", e.getLocalizedMessage());
        } catch (IOException e) {
            e.printStackTrace();
            promise.reject("-1", e.getLocalizedMessage());
        }

    }

    @ReactMethod
    public void readFileList(String subFolder, Promise promise) {
        File file = new File(CACHEDIR + subFolder);
        if (file.exists() && file.isDirectory()) {
            WritableArray writableArray = new WritableNativeArray();
            for (File item : file.listFiles()) {
                WritableMap writableMap = new WritableNativeMap();
                writableMap.putString("name", item.getName());
                writableMap.putString("size", String.valueOf(item.getTotalSpace()));
                writableArray.pushMap(writableMap);
            }
            promise.resolve(writableArray);
        } else {
            promise.reject("-1", "path error");
        }
    }

    @ReactMethod
    public void deleteFile(String fileName, Promise promise) {
        if (fileName == null) {
            promise.resolve(false);
            return;
        }
        File file;
        if (fileName.contains(CACHEDIR)) {
            file = new File(fileName);
        } else {
            file = new File(CACHEDIR + fileName);
        }
        boolean deleteResult = FileUtils.delete(file);
        promise.resolve(deleteResult);
    }

    /**
     * 删除 解密保存的缓存
     *
     * @param fileName url
     * @param fileType pic video file cache all
     * @param promise
     */
    @ReactMethod
    public void deleteDecodeFile(String fileName, String fileType, Promise promise) {
        if (fileName == null || fileType == null) {
            promise.resolve(false);
            return;
        }
        if (fileName.contains(CACHEDIR)) {
            File file = new File(fileName);
            boolean deleteResult = FileUtils.delete(file);
            promise.resolve(deleteResult);
            return;
        }
        File fileDelete = null;
        switch (fileType) {
            case "pic":
                int index = fileName.indexOf("?");
                if (index > 0) {
                    String fileUrlSub = fileName.substring(0, index);
                    String fileKey = EncryptUtils.encryptMD5ToString(fileUrlSub);
                    DiskLruCachePic.INSTANCE.delete(fileKey);
                } else {
                    fileDelete = new File(PIC_PATH, fileName);
                }
                break;
            case "video":
                fileDelete = new File(VIDEO_PATH, fileName);
                break;
            case "cache":
                fileDelete = new File(CACHE_PATH, fileName);
                break;
            case "file":
                fileDelete = new File(FILE_PATH, fileName);
                break;
            case "all":
                fileDelete = new File(FILE_PATH).getParentFile();
                break;
            default:
                break;
        }
        FileUtils.delete(fileDelete);

    }

    @ReactMethod
    public void isFileExists(String fileName, Promise promise) {
        File file;
        if (fileName != null && fileName.contains(CACHEDIR)) {
            file = new File(fileName);
        } else {
            file = new File(CACHEDIR + fileName);
        }
        boolean exists = FileUtils.isFileExists(file);
        promise.resolve(exists);
    }

    @ReactMethod
    public void uploadFile(ReadableMap params, Promise promise) {
        MultipartBody.Builder bodyBuilder = new MultipartBody.Builder()
                .setType(MultipartBody.FORM);
        if (params.hasKey("fields")) {
            ReadableMap fields = params.getMap("fields");
            if (fields != null) {
                Iterator<Map.Entry<String, Object>> iterator = fields.getEntryIterator();
                while (iterator.hasNext()) {
                    Map.Entry<String, Object> entry = iterator.next();
                    bodyBuilder.addFormDataPart(entry.getKey(), entry.getValue().toString());
                }
            }
        }
        ReadableArray files = params.getArray("files");
        if (files != null) {
            for (int i = 0; i < files.size(); i++) {
                ReadableMap filesMap = files.getMap(i);
                if (filesMap != null) {
                    String filePath = filesMap.getString("filePath");
                    filePath = filePath == null ? "" : filePath;
                    File targetFile = new File(filePath);
                    if (targetFile.exists()) {
                        String finalFileName = targetFile.getName();
                        String finalName = finalFileName;
                        if (filesMap.hasKey("formData")) {
                            ReadableMap formData = filesMap.getMap("formData");
                            if (formData != null) {
                                if (formData.hasKey("filename")) {
                                    String filename = formData.getString("filename");
                                    if (!TextUtils.isEmpty(filename)) {
                                        finalFileName = filename;
                                    }
                                }
                                if (formData.hasKey("name")) {
                                    String name = formData.getString("name");
                                    if (!TextUtils.isEmpty(name)) {
                                        finalName = name;
                                    }
                                }
                            }
                        }
                        bodyBuilder.addFormDataPart(finalName, finalFileName,
                                RequestBody.create(targetFile, MediaType.parse("application/octet-stream")));
                    }
                }
            }
        }
        String uploadUrl = params.getString("uploadUrl");
        String method = params.getString("method");
        RNNetRequest.TYPE type = RNNetRequest.TYPE.POST;
        if ("put".equalsIgnoreCase(method)) {
            type = RNNetRequest.TYPE.PUT;
        }
        RNNetRequest.uploadFile(uploadUrl, type, bodyBuilder.build(), new RNNetRequestCallBack() {
            @Override
            public void onSuccess(String response) {
                promise.resolve(response);
            }

            @Override
            public void onError(int code, String error) {
                promise.reject(String.valueOf(code), error);
            }
        });
    }

    @ReactMethod
    public void downloadFile(String url, String filename, ReadableMap params, Callback callback) {
        if (TextUtils.isEmpty(filename)) {
            callback.invoke(Boolean.FALSE, filename + ", this folder is not valid, cannot contains ...");
        } else {
            DownloadTask task = new DownloadTask(url, CACHEDIR, filename);
            if (params != null) {
                task.setTaskId(params.getString("taskID"));
            }
            DownloadFileUtils.downloadFile(task, new SimpleOnDownloadListener() {
                @Override
                public void onSuccess(@NonNull DownloadTask task) {
                    callback.invoke(Boolean.TRUE, url);
                }

                @Override
                public void onError(@NonNull DownloadTask task, @NonNull EndCause cause, @NonNull Exception e) {
                    callback.invoke(Boolean.FALSE, e.getMessage());
                }
            });
        }
    }

    @ReactMethod
    public void cancelDownloadFile(String taskId, Callback callback) {
        if (TextUtils.isEmpty(taskId)) {
            callback.invoke(Boolean.FALSE, "taskId is empty...");
            return;
        }
        DownloadTask downloadTask = DownloadFileUtils.getDownloadTask(taskId);
        if (downloadTask != null) {
            DownloadFileUtils.cancelDownloadFile(downloadTask);
            callback.invoke(Boolean.TRUE);
            return;
        }
        callback.invoke(Boolean.FALSE, "can not find this taskId, taskId is " + taskId);
    }

    @ReactMethod
    public final void saveImageToPhotosAlbum(String filename, Callback callback) {
        try {
            saveImageToPhotosDidAlbumPub(null, filename, callback);
        } catch (Exception e) {
            callback.invoke(Boolean.FALSE, createMap(-1, "saveImageToPhotosAlbum error:" + e.getMessage()));
        }
    }

    @ReactMethod
    public void saveFileToPhotosAlbum(String filename, Callback callback) {
        File file;
        if (filename != null && filename.startsWith(CACHEDIR)) {
            file = new File(filename);
        } else {
            file = new File(CACHEDIR + filename);
        }
        String pathName = file.getPath();
        String mimeType = getMimeType(pathName);
        if (!TextUtils.isEmpty(mimeType) && mimeType.contains("image")) {
            Log.d("TAG", "saveFileToPhotosAlbum, image");
            saveImageToPhotosDidAlbumPub(null, filename, callback);
        } else if (TextUtils.isEmpty(mimeType) || !mimeType.contains("video")) {
            Log.d("TAG", "saveFileToPhotosAlbum, other");
            saveFilePub(filename, callback);
        } else {
            Log.d("TAG", "saveFileToPhotosAlbum, video");
            saveVideoToPhotosDidAlbumPub(null, filename, callback);
        }
    }

    @ReactMethod
    public final void saveImageToPhotosDidAlbum(String did, String fileName, Callback callback) {
        if (TextUtils.isEmpty(did)) {
            callback.invoke(Boolean.FALSE, createMap(-2, "albumName is illegal"));
            return;
        }
        try {
            saveImageToPhotosDidAlbumPub(did, fileName, callback);
        } catch (Exception e) {
            callback.invoke(Boolean.FALSE, createMap(-1, "saveImageToPhotosDidAlbum error:" + e.getMessage()));
        }
    }

    @ReactMethod
    public final void saveVideoToPhotosDidAlbum(String did, String fileName, Callback callback) {
        if (TextUtils.isEmpty(did)) {
            callback.invoke(Boolean.FALSE, createMap(-2, "albumName is illegal"));
            return;
        }
        try {
            saveVideoToPhotosDidAlbumPub(did, fileName, callback);
        } catch (Exception e) {
            callback.invoke(Boolean.FALSE, createMap(-1, "saveVideoToPhotosDidAlbum error:" + e.getMessage()));
        }
    }

    private void saveFilePub(final String filename, final Callback callback) {
        // todo
    }

    @SuppressLint("CheckResult")
    private void saveImageToPhotosDidAlbumPub(final String albumName, String fileName, final Callback callback) {
        File file = new File(CACHEDIR + fileName);
        String pathName = file.getPath();
        String generateFileNameByTime = generateFileNameByTime(1);
        Observable.just(0).subscribeOn(Schedulers.io()).subscribe(integer -> {
            WritableMap writableMap;
            try {
                MediaStoreUtil.insertImage(getCurrentActivity().getApplicationContext(), pathName, albumName, generateFileNameByTime);
                callback.invoke(Boolean.TRUE, createMap(0, "success"));
            } catch (MediaStoreUtil.AccessMediaError e) {
                int errorCode = e.getErrorCode();
                if (errorCode == -6) {
                    writableMap = createMap(-5, "filepath cannot convert to a image");
                } else if (errorCode != -5) {
                    writableMap = errorCode != -1 ? createMap(-100, "failed to save image") : createMap(-3, "path is illegal or file not exist");
                } else {
                    writableMap = createMap(-2, "albumName is illegal");
                }
                callback.invoke(Boolean.FALSE, writableMap);
            } catch (Exception e2) {
                callback.invoke(Boolean.FALSE, createMap(-100, "saveImageToPhotosDidAlbumPub error:" + e2.getMessage()));
            }
        });
    }

    private void saveVideoToPhotosDidAlbumPub(final String albumName, String fileName, final Callback callback) {
        File file;
        if (fileName != null && fileName.startsWith(CACHEDIR)) {
            file = new File(fileName);
        } else {
            file = new File(CACHEDIR + fileName);
        }
        String pathName = file.getPath();
        String generateFileNameByTime = generateFileNameByTime(2);
        Observable.just(0).subscribeOn(Schedulers.io()).subscribe(integer -> {
            WritableMap writableMap;
            try {
                MediaStoreUtil.insertVideo(getCurrentActivity().getApplicationContext(), pathName, albumName, generateFileNameByTime);
                callback.invoke(Boolean.TRUE, createMap(0, "success"));
            } catch (MediaStoreUtil.AccessMediaError e) {
                int errorCode = e.getErrorCode();
                if (errorCode == -7) {
                    writableMap = createMap(-4, "filepath cannot seek to be video file");
                } else if (errorCode != -5) {
                    writableMap = errorCode != -1 ? createMap(-100, "failed to save video") : createMap(-3, "path is illegal or file not exist");
                } else {
                    writableMap = createMap(-2, "albumName is illegal");
                }
                callback.invoke(Boolean.FALSE, writableMap);
            } catch (Exception e2) {
                callback.invoke(Boolean.FALSE, createMap(-100, "saveVideoToPhotosDidAlbumPub error:" + e2.getMessage()));
            }
        });
    }

    @ReactMethod
    public void longScreenShot(int id, final String filename, final Callback callback) {
        try {
            String pathName = CACHEDIR + filename;
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("format", "jpg");
            jSONObject.put("result", "tmpfile");
            jSONObject.put("snapshotContentContainer", true);
            jSONObject.put("fileName", filename);
            jSONObject.put("pathName", pathName);
            jSONObject.put("quality", 0.8d);

            final View view = getCurrentActivity().findViewById(id);

            if (view == null) {
                callback.invoke(Boolean.FALSE, "can not find view Id, id is ".concat(String.valueOf(id)));
            } else if (view instanceof ScrollView) {
                this.captureRef(id, jSONObject, callback);
            } else {
                view.post(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            Bitmap bitmap = null;
                            if (view instanceof ScrollView) {
                                bitmap = ScreenShot.captureFromSV((ScrollView) view);
                            }
                            if (view instanceof ListView) {
                                bitmap = ScreenShot.captureFromLV((ListView) view);
                            }
                            if (view instanceof RecyclerView) {
                                bitmap = ScreenShot.captureFromRV((RecyclerView) view);
                            }
                            if (bitmap != null) {
                                bitmap.compress(Bitmap.CompressFormat.JPEG, 90, new BufferedOutputStream(new FileOutputStream(pathName)));
                                callback.invoke(true, pathName);
                            } else {
                                callback.invoke(false, "bitmap is empty");
                            }
                        } catch (FileNotFoundException e) {
                            callback.invoke(false, e.getLocalizedMessage());
                        }
                    }
                });
            }
        } catch (JSONException e) {
            e.printStackTrace();
            callback.invoke(Boolean.FALSE);
        }
    }

    @ReactMethod
    public void screenShot(String imageName, Callback callback) {
        String pathName = CACHEDIR + imageName;
        View v = getCurrentActivity().getWindow().getDecorView().getRootView();
        v.post(new Runnable() {
            @Override
            public void run() {
                int height = v.getHeight();
                int width = v.getWidth();
                Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
                Canvas canvas = new Canvas(bitmap);
                v.draw(canvas);
                if (bitmap != null) {
                    try {
                        bitmap.compress(Bitmap.CompressFormat.JPEG, 90, new BufferedOutputStream(new FileOutputStream(pathName)));
                        callback.invoke(true, pathName);
                    } catch (FileNotFoundException e) {
                        callback.invoke(false, e.getLocalizedMessage());
                    }
                } else {
                    callback.invoke(false, "bitmap is empty");
                }
            }
        });
    }

    /**
     * 将url解密保存 图片则返回 base64， 其他返回 path
     *
     * @param url      url
     * @param params   -name 加密算法 - key: 密钥 - transformation:偏移量 -iv:向量
     * @param params   -fileName 期望文件名 null就是图片
     * @param callback
     */
    @ReactMethod
    public void decodeUrlFileToBase64(String url, ReadableMap params, Callback callback) {
        if (url == null || url.length() == 0) {
            callback.invoke(Boolean.FALSE, "decode url = null");
            return;
        }
        Disposable subscribe = Observable.just(0).subscribeOn(Schedulers.io()).subscribe(integer -> {
            String fileName = null;
            if (params.hasKey("fileName")) {
                fileName = params.getString("fileName");
            }
            int index = url.indexOf("?");
            String substring = url;
            if (index > 0) {
                substring = url.substring(0, index);
            }
            if (fileName == null || fileName.endsWith(".jpg") || fileName.endsWith(".png")) {
                DownloadAndDecodeFileUtils.decodeUrlFileToBase64Pic(url, substring, fileName, true, CACHE_PATH, VIDEO_PATH, params.toHashMap(), callback);
            } else {
                DownloadAndDecodeFileUtils.decodeUrlFileToBase64Pic(url, substring, fileName, false, CACHE_PATH, VIDEO_PATH, params.toHashMap(), callback);
            }
        });
    }

    /**
     * 将url解密保存 图片则返回 base64， 其他返回 path
     *
     * @param url      url
     * @param params   -name 加密算法 - key: 密钥 - transformation:偏移量 -iv:向量
     * @param params   -fileName 期望文件名 非空
     * @param callback
     */
    @ReactMethod
    public void downloadBase64UrlFile(String url, String fileName, ReadableMap params, Callback callback) {
        if (url == null || url.length() == 0) {
            callback.invoke(Boolean.FALSE, "decode url = null");
            return;
        }
        if (fileName == null || fileName.length() == 0) {
            callback.invoke(Boolean.FALSE, "decode fileName = null");
            return;
        }
        Disposable subscribe = Observable.just(0).subscribeOn(Schedulers.io()).subscribe(integer -> {
            DownloadAndDecodeFileUtils.downloadFile(url, fileName, null, CACHE_PATH, CACHEDIR, false, params.toHashMap(), callback);
        });
    }


    /**
     * 判断activity 有效
     *
     * @return
     */
    private boolean isActivityValid() {
        return getCurrentActivity() != null && !getCurrentActivity().isFinishing() && !getCurrentActivity().isDestroyed();
    }

    private boolean runOnUiThread(Runnable runnable) {
        if (isActivityValid()) {
            getCurrentActivity().runOnUiThread(runnable);
            return true;
        }
        return false;
    }

    @ReactMethod
    public void downloadBase64File(String base64File, String fileName, Callback callback) {
        byte[] bytes = EncodeUtils.base64Decode(base64File);
        // 保存沙盒
        File file = new File(CACHEDIR, fileName);
        boolean b = FileIOUtils.writeFileFromBytesByStream(file, bytes);
        callback.invoke(b ? Boolean.TRUE : Boolean.FALSE, "result");
    }

    /**
     * 获取通用插件
     *
     * @param pluginType 插件名
     * @param min        插件支持的最小版本
     * @param appV       app版本,默认 1
     */
    @ReactMethod
    public void getCommonPlugin(String pluginType, String min, String appV, Promise promise) {
        int minVersion = 0;
        String appVersion = "1";
        if (!TextUtils.isEmpty(min)) {
            minVersion = Integer.parseInt(min);
        }
        if (!TextUtils.isEmpty(appVersion)) {
            appVersion = appV;
        }
        CommonPluginManager.INSTANCE.getCommonPlugin2(pluginType, appVersion, minVersion, false, filePath -> {
            Log.d("TAG", "upgradePlugin: " + filePath);
            if (!TextUtils.isEmpty(filePath)) {
                promise.resolve(filePath);
            } else {
                promise.reject("-1", "filePath is null");
            }
            return null;
        }, error -> {
            promise.reject("-1", error);
            return null;
        });
    }

    private void captureRef(int tag, JSONObject options, Callback callback) {
        final ReactApplicationContext context = getReactApplicationContext();
        final DisplayMetrics dm = context.getResources().getDisplayMetrics();

        final String extension;
        try {
            extension = options.getString("format");

            final int imageFormat = "jpg".equals(extension) ? ViewShot.Formats.JPEG : "webm".equals(extension) ? ViewShot.Formats.WEBP : "raw".equals(extension) ? ViewShot.Formats.RAW : ViewShot.Formats.PNG;

            final double quality = options.getDouble("quality");
            final Integer scaleWidth = options.has("width") ? (int) (dm.density * options.getDouble("width")) : null;
            final Integer scaleHeight = options.has("height") ? (int) (dm.density * options.getDouble("height")) : null;
            final String resultStreamFormat = options.getString("result");
            final Boolean snapshotContentContainer = options.getBoolean("snapshotContentContainer");
            final String pathName = options.getString("pathName");

            File outputFile = null;
            if (ViewShot.Results.TEMP_FILE.equals(resultStreamFormat)) {
                if (TextUtils.isEmpty(pathName)) {
                    outputFile = createTempFile(getReactApplicationContext(), extension);
                } else {
                    outputFile = new File(pathName);
                    if (outputFile.exists()) {
                        outputFile.delete();
                    }
                }
            }

            final Activity activity = getCurrentActivity();
            final UIManagerModule uiManager = context.getNativeModule(UIManagerModule.class);

            uiManager.addUIBlock(new ViewShot(tag, extension, imageFormat, quality, scaleWidth, scaleHeight, outputFile, resultStreamFormat, snapshotContentContainer, context, activity, callback));
        } catch (final Throwable ex) {
            callback.invoke(Boolean.FALSE);
        }
    }

    private File createTempFile(@NonNull final Context context, @NonNull final String ext) throws IOException {
        final File externalCacheDir = context.getExternalCacheDir();
        final File internalCacheDir = context.getCacheDir();
        final File cacheDir;

        if (externalCacheDir == null && internalCacheDir == null) {
            throw new IOException("No cache directory available");
        }

        if (externalCacheDir == null) {
            cacheDir = internalCacheDir;
        } else if (internalCacheDir == null) {
            cacheDir = externalCacheDir;
        } else {
            cacheDir = externalCacheDir.getFreeSpace() > internalCacheDir.getFreeSpace() ? externalCacheDir : internalCacheDir;
        }

        final String suffix = "." + ext;
        return File.createTempFile("ReactNative-snapshot-image", suffix, cacheDir);
    }

    private static String getMimeType(String path) {
        String fileExtensionFromUrl = MimeTypeMap.getFileExtensionFromUrl(path);
        if (fileExtensionFromUrl != null) {
            return MimeTypeMap.getSingleton().getMimeTypeFromExtension(fileExtensionFromUrl);
        }
        return "";
    }

    private static String generateFileNameByTime(int type) {
        Calendar instance = Calendar.getInstance();
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONDAY) + 1;
        int date = instance.get(Calendar.DATE);
        int hour = instance.get(Calendar.HOUR_OF_DAY);
        int min = instance.get(Calendar.MINUTE);
        int sec = instance.get(Calendar.SECOND);
        int milliSec = instance.get(Calendar.MILLISECOND);
        if (type == 1) {
            return String.format("PIC_%d%02d%02d_%02d%02d%02d%03d.jpg", Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(date), Integer.valueOf(hour), Integer.valueOf(min), Integer.valueOf(sec), Integer.valueOf(milliSec));
        } else if (type != 2) {
            return String.format("DIOT_%d%02d%02d_%02d%02d%02d%03d", Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(date), Integer.valueOf(hour), Integer.valueOf(min), Integer.valueOf(sec), Integer.valueOf(milliSec));
        } else {
            return String.format("VIDEO_%d%02d%02d_%02d%02d%02d%03d.mp4", Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(date), Integer.valueOf(hour), Integer.valueOf(min), Integer.valueOf(sec), Integer.valueOf(milliSec));
        }
    }

    public static WritableMap createMap(int code, String message) {
        WritableMap createMap = Arguments.createMap();
        createMap.putInt("code", code);
        if (message == null) {
            message = "";
        }
        createMap.putString("message", message);
        return createMap;
    }


}
