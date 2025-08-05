package android.dreame.module.rn.bridge.rawdata;

import android.dreame.module.BuildConfig;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.MD5Util;
import android.dreame.module.util.download.DownloadFileUtils;
import android.dreame.module.util.download.DownloadStreamTask;
import android.dreame.module.util.download.DownloadTask;
import android.dreame.module.util.download.EndCause;
import android.dreame.module.util.download.SimpleOnDownloadListener;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.blankj.utilcode.util.EncodeUtils;
import com.blankj.utilcode.util.EncryptUtils;
import com.blankj.utilcode.util.FileIOUtils;
import com.facebook.react.bridge.Callback;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class DownloadAndDecodeFileUtils {

    private static Handler mHandler = new Handler(Looper.getMainLooper());

    public static void decodeUrlFileToBase64Pic(String url, String fileUrlSub, String fileName, boolean isPic, String cachePath, String videoPath,
                                                HashMap<String, Object> params, Callback callback) {
        String fileKey = EncryptUtils.encryptMD5ToString(fileUrlSub);
        if (BuildConfig.DEBUG) {
            Log.d("sunzhibin", "DiskLruCachePic:get start " + fileKey);
        }
        if (fileKey != null && fileKey.length() > 0) {
            File file = DiskLruCachePic.INSTANCE.get(fileKey);
            if (file != null && file.exists() && file.length() > 0) {
                try {
                    String pic = FileIOUtils.readFile2String(file);
                    if (pic != null && pic.length() > 0 && new File(pic).exists()) {
                        if (BuildConfig.DEBUG) {
                            Log.d("sunzhibin", "DiskLruCachePic:get end  " + fileKey + " " + file.getAbsolutePath() + " " + pic.length());
                        }
                        mHandler.post(() -> callback.invoke(Boolean.TRUE, pic));
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        downloadFile(url, fileName, fileKey, cachePath, videoPath, isPic, params, callback);
    }

    /**
     * 下载并解密文件 isPicture true: 返回base64 false: 返回路径
     *
     * @param url       图片 url
     * @param fileName  文件名
     * @param fileKey   Disk缓存用的key，null则不进行缓存
     * @param cachePath 下载缓存文件目录
     * @param videoPath 文件保存目录
     * @param isPicture 是图片 还是 文件
     * @param params    解码参数
     * @param callback  图片：返回base64, 其他：返回path
     */
    public static void downloadFile(String url, String fileName, String fileKey, String cachePath, String videoPath, boolean isPicture,
                                    HashMap<String, Object> params, Callback callback) {
        DownloadTask task = new DownloadStreamTask(url, cachePath, fileKey, true, params);
        String taskID = params != null ? (params.containsKey("taskID") ? (String) params.get("taskID") : null) : null;
        task.setTaskId(taskID);
        DownloadFileUtils.downloadFile(task, new SimpleOnDownloadListener() {
            @Override
            public void onSuccess(@NonNull DownloadTask task) {
                // 解密
                try {
                    if (task instanceof DownloadStreamTask) {
                        DownloadStreamTask streamTask = (DownloadStreamTask) task;
                        Map<String, Object> params1 = streamTask.getParams();
                        if (params1 != null) {
                            String name = (String) params1.get("name");
                            String key = (String) params1.get("key");
                            String transformation = (String) params1.get("transformation");
                            String iv = (String) params1.get("iv");
                            if (key != null && name != null) {
                                if (!"0".equals(key)) {
                                    streamTask.bodyStream = decryptPic(name.toUpperCase(), transformation,
                                            iv.getBytes(StandardCharsets.UTF_8), streamTask.bodyStream,
                                            MD5Util.getMD5Str(key).getBytes(StandardCharsets.UTF_8));
                                    if (streamTask.bodyStream == null) {
                                        LogUtil.e("sunzhibin", "Decrypt fail: " + url);
                                        mHandler.post(() -> callback.invoke(Boolean.FALSE));
                                        return;
                                    }
                                }
                            }
                        }
                        if (isPicture) {
                            String s = EncodeUtils.base64Encode2String(streamTask.bodyStream);
                            if (fileKey != null && fileKey.length() > 0) {
                                DiskLruCachePic.INSTANCE.put(fileKey, s);
                            }
                            mHandler.post(() -> callback.invoke(Boolean.TRUE, s));
                        } else {
                            String filePath = videoPath + fileName;
                            boolean result = FileIOUtils.writeFileFromBytesByStream(filePath, streamTask.bodyStream);
                            if (result && fileKey != null && fileKey.length() > 0) {
                                DiskLruCachePic.INSTANCE.put(fileKey, filePath);
                            }
                            mHandler.post(() -> callback.invoke(Boolean.TRUE, filePath));
                        }
                    } else {
                        mHandler.post(() -> callback.invoke(Boolean.FALSE, "download error"));
                    }
                } catch (
                        Exception e) {
                    mHandler.post(() -> callback.invoke(Boolean.FALSE, e.getMessage()));
                }

            }

            @Override
            public void onError(@NonNull DownloadTask task, @NonNull EndCause cause, @NonNull Exception e) {
                super.onError(task, cause, e);
                mHandler.post(() -> callback.invoke(Boolean.FALSE, e.getMessage()));
            }
        });
    }

    private static byte[] decryptPic(String encryptName, String transformation, byte[] iv, byte[] pics, byte[] keys) {
        if (pics == null || pics.length == 0) {
            return null;
        }
        if (encryptName == null || encryptName.length() == 0) {
            return pics;
        }
        // 解密 图片
        switch (encryptName) {
            case "AES":
                if (keys == null || keys.length == 0) {
                    return pics;
                }
                return EncryptUtils.decryptAES(pics, keys, transformation, iv);
            case "RSA":
                if (keys == null || keys.length == 0) {
                    return pics;
                }
                return EncryptUtils.decryptRSA(pics, keys, keys.length, transformation);
            case "DES":
                if (keys == null || keys.length == 0) {
                    return pics;
                }
                return EncryptUtils.decryptDES(pics, keys, transformation, iv);
            case "DESede":
                if (keys == null || keys.length == 0) {
                    return pics;
                }
                return EncryptUtils.decrypt3DES(pics, keys, transformation, iv);
            case "BASE64":
                return EncodeUtils.base64Decode(pics);
            default:
                return pics;
        }
    }

}
