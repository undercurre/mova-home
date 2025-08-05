package android.dreame.module.rn.bridge.video;

import android.content.Context;
import android.dreame.module.rn.bridge.host.FileModule;
import android.dreame.module.rn.bridge.rawdata.Mp4VideoEncoder;
import android.dreame.module.util.LogUtil;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.media.ThumbnailUtils;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.util.Pair;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import io.agora.advancedvideo.rawdata.MediaDataAudioObserver;
import io.agora.advancedvideo.rawdata.MediaDataObserverPlugin;
import io.agora.advancedvideo.rawdata.MediaDataVideoObserver;
import io.agora.advancedvideo.rawdata.MediaPreProcessing;

/**
 * 声网SDK 升级同时 需要更新raw-data库
 * <a href= "https://github.com/AgoraIO/API-Examples.git">声网github</a>
 *
 * @author edy
 */
public class AgoraRawDataModule extends ReactContextBaseJavaModule implements MediaDataVideoObserver, MediaDataAudioObserver {
    private MediaDataObserverPlugin mediaDataObserverPlugin;
    private volatile boolean flag = false;
    private Context mContext;
    private final File parentFile;
    private boolean isEncodeInitSuccess;
    private int mWidth = 864;
    private int mHeight = 480;
    // 是否已发激活音频流,用于视频录制
    private boolean sentFakeAudio = false;
    private boolean needMixAudio = false;

    public AgoraRawDataModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
        String path = FileModule.getRecordPath();
        parentFile = new File(path);
        if (!parentFile.exists()) {
            parentFile.mkdirs();
        }
    }

    @NonNull
    @Override
    public String getName() {
        return "AgoraRawData";
    }

    @ReactMethod
    public void registerVideoFrameObserver(int uid) {
        Log.d(getName(), "registerVideoFrameObserver: ------0-----" + uid);
        if (mediaDataObserverPlugin == null) {
            Log.d(getName(), "registerVideoFrameObserver: ------1-----" + uid);
            mediaDataObserverPlugin = MediaDataObserverPlugin.the();
            MediaPreProcessing.setCallback(mediaDataObserverPlugin);
            MediaPreProcessing.setVideoCaptureByteBuffer(mediaDataObserverPlugin.byteBufferCapture);
            MediaPreProcessing.setAudioRecordByteBuffer(mediaDataObserverPlugin.byteBufferAudioRecord);
            mediaDataObserverPlugin.addVideoObserver(this);
            mediaDataObserverPlugin.addAudioObserver(this);
        }
        if (mediaDataObserverPlugin != null) {
            Log.d(getName(), "registerVideoFrameObserver: ------2-----" + uid);
            mediaDataObserverPlugin.addDecodeBuffer(uid);
        }
    }

    @ReactMethod
    public void releaseRawData() {
        Log.d(getName(), "releaseRawData: ------0-----");
        if (mediaDataObserverPlugin != null) {
            Log.d(getName(), "releaseRawData: ------1-----");
            mediaDataObserverPlugin.removeAudioObserver(AgoraRawDataModule.this);
            mediaDataObserverPlugin.removeVideoObserver(AgoraRawDataModule.this);
            mediaDataObserverPlugin.removeAllBuffer();
            mediaDataObserverPlugin = null;
            Log.d(getName(), "releaseRawData: ------2-----");
            MediaPreProcessing.releasePoint();
            Log.d(getName(), "releaseRawData: ------3-----");
        }
    }

    @ReactMethod
    public void shot() {

    }

    @ReactMethod
    public void startRecord(int maxDuration) {
        this.flag = true;
        LogUtil.i(getName(), "startRecord flag:" + flag + ", initSuccess:" + isEncodeInitSuccess);
        if (!isEncodeInitSuccess) {
            String recordMp4FileName = System.currentTimeMillis() + ".mp4";
            File recordMp4File = new File(parentFile, recordMp4FileName);
            isEncodeInitSuccess = Mp4VideoEncoder.getInstance().init(recordMp4File.getAbsolutePath(), mWidth, mHeight, false);
            LogUtil.i(getName(), "startRecord initSuccess:" + isEncodeInitSuccess);
        }
    }

    @ReactMethod
    public void startVideoRecord(boolean needMixAudio, Callback callback) {
        this.flag = true;
        this.sentFakeAudio = false;
        this.needMixAudio = needMixAudio;
        LogUtil.i(getName(), "startRecord flag:" + flag + ", initSuccess:" + isEncodeInitSuccess);
        if (isEncodeInitSuccess) {
            callback.invoke(Boolean.FALSE);
        } else {
            String recordMp4FileName = System.currentTimeMillis() + ".mp4";
            File recordMp4File = new File(parentFile, recordMp4FileName);
            isEncodeInitSuccess = Mp4VideoEncoder.getInstance().init(recordMp4File.getAbsolutePath(), mWidth, mHeight, needMixAudio);
            Mp4VideoEncoder.getInstance().setStartCallback(s -> {
                callback.invoke(Boolean.TRUE);
                return null;
            });
            LogUtil.i(getName(), "startRecord initSuccess:" + isEncodeInitSuccess);
        }
    }

    @ReactMethod
    public void stopRecord() {
        if (!flag) {
            LogUtil.e(getName(), "stopRecord fail, flag:" + flag);
            this.flag = false;
            getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit("RecordSuccess", createFailedMap(-1, "fail"));
            return;
        }
        Mp4VideoEncoder.getInstance().setCallback((videoPath) -> {
            if (TextUtils.isEmpty(videoPath)) {
                LogUtil.e(getName(), "stopRecord fail, 视频路径为空 videoPath");
                getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("RecordSuccess", createFailedMap(-1, "fail"));
                return null;
            }
            File videoFile = new File(videoPath);
            long videoSize = 0;
            int duration = 0;
            if (!videoFile.exists()) {
                LogUtil.e(getName(), "stopRecord fail, 视频文件不存在 videoFile:" + videoFile);
                getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("RecordSuccess", createFailedMap(-1, "fail"));
                return null;
            }
            try {
                videoSize = videoFile.length();
                MediaMetadataRetriever media = new MediaMetadataRetriever();
                media.setDataSource(videoPath);
                duration = Integer.parseInt(media.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
                media.release();
            } catch (Exception e) {
                LogUtil.e(getName(), "parse video duration error: " + e + ", videoSize:" + videoSize);
            }
            // parse cover thumb
            Pair<String, Long> thumbPair = extractedThumbnail(videoPath, videoFile.getName().replace("mp4", "jpg"));
            String thumbPath = thumbPair.first;
            long thumbSize = thumbPair.second;
            if (!new File(thumbPath).exists()) {
                getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("RecordSuccess", createFailedMap(-1, "fail"));
                LogUtil.e(getName(), "stopRecord fail, 缩略图获取失败 thumbPath:" + thumbPath);
                Mp4VideoEncoder.getInstance().setCallback(null);
                this.flag = false;
                return null;
            }
            // success
            WritableMap data = createMap(0, "success", thumbPath, thumbSize, videoPath, videoSize, duration);
            LogUtil.i(getName(), "stopRecord success, data:" + data);
            getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit("RecordSuccess", data);
            Mp4VideoEncoder.getInstance().setCallback(null);
            this.flag = false;
            return null;
        });
        Mp4VideoEncoder.getInstance().stop();
        isEncodeInitSuccess = false;
        this.sentFakeAudio = false;
    }

    private Pair<String, Long> extractedThumbnail(String videoPath, String imageName) {
        Bitmap thumbnail = null;
        try {
            thumbnail = ThumbnailUtils.createVideoThumbnail(videoPath, MediaStore.Video.Thumbnails.MINI_KIND);
            if (thumbnail == null) {
                MediaMetadataRetriever media = new MediaMetadataRetriever();
                media.setDataSource(videoPath);
                thumbnail = media.getFrameAtTime(1000 * 1000);
                media.release();
            }
        } catch (Exception e) {
            LogUtil.i(getName(), "extractedThumbnail: " + (thumbnail == null));
        }
        if (thumbnail != null) {
            File thumbnailPic = new File(parentFile, imageName);
            boolean result = saveBitmap(thumbnail, imageName);
            if (result) {
                return new Pair<>(thumbnailPic.getAbsolutePath(), thumbnailPic.length());
            }
        }
        return new Pair<>("", 0L);
    }

    private boolean saveBitmap(Bitmap thumbnail, String fileName) {
        File thumbnailPic = new File(parentFile, fileName);
        if (thumbnailPic.exists()) {
            thumbnailPic.delete();
        }
        try {
            thumbnailPic.createNewFile();
            FileOutputStream fos = new FileOutputStream(thumbnailPic);
            thumbnail.compress(Bitmap.CompressFormat.JPEG, 80, fos);
            fos.flush();
            fos.close();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    private WritableMap createFailedMap(int code, String message) {
        return createMap(-1, message, "", 0, "", 0, 0);
    }

    private WritableMap createMap(int code, String message, String thumbPath, long thumbSize, String videoPath, long videoSize, int duration) {
        WritableMap createMap = Arguments.createMap();
        createMap.putInt("code", code);
        if (message == null) {
            message = "";
        }
        createMap.putString("message", message);

        createMap.putString("thumbPath", thumbPath);
        createMap.putInt("thumbSize", (int) thumbSize);
        createMap.putString("videoPath", videoPath);
        createMap.putInt("videoSize", (int) videoSize);
        createMap.putInt("duration", duration);

        return createMap;
    }

    @Override
    public void onCaptureVideoFrame(byte[] data, int frameType, int width, int height, int bufferLength, int yStride, int uStride, int vStride, int rotation, long renderTimeMs) {
    }

    @Override
    public void onRenderVideoFrame(int uid, byte[] data, int frameType, int width, int height, int bufferLength, int yStride, int uStride, int vStride, int rotation, long renderTimeMs) {
        mWidth = width;
        mHeight = height;
        if (isEncodeInitSuccess) {
            byte[] buffer = new byte[data.length];
            System.arraycopy(data, 0, buffer, 0, data.length);
            Mp4VideoEncoder.getInstance().addVideoData(buffer, width, height);
            if (this.needMixAudio) {
                if (!sentFakeAudio) {
                    Mp4VideoEncoder.getInstance().addAudioData(new byte[960]);
                    sentFakeAudio = true;
                }
            }
        }
    }

    @Override
    public void onPreEncodeVideoFrame(byte[] data, int frameType, int width, int height, int bufferLength, int yStride, int uStride, int vStride, int rotation, long renderTimeMs) {

    }

    @Override
    public void onRecordAudioFrame(byte[] data, int audioFrameType, int samples, int bytesPerSample, int channels, int samplesPerSec, long renderTimeMs, int bufferLength) {
        if (isEncodeInitSuccess && this.needMixAudio) {
            byte[] buffer = new byte[data.length];
            System.arraycopy(data, 0, buffer, 0, data.length);
            Mp4VideoEncoder.getInstance().addAudioData(buffer);
        }
    }

    @Override
    public void onPlaybackAudioFrame(byte[] data, int audioFrameType, int samples, int bytesPerSample, int channels, int samplesPerSec, long renderTimeMs, int bufferLength) {

    }

    @Override
    public void onPlaybackAudioFrameBeforeMixing(int uid, byte[] data, int audioFrameType, int samples, int bytesPerSample, int channels, int samplesPerSec, long renderTimeMs, int bufferLength) {

    }

    @Override
    public void onMixedAudioFrame(byte[] data, int audioFrameType, int samples, int bytesPerSample, int channels, int samplesPerSec, long renderTimeMs, int bufferLength) {

    }

}
