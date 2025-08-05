package android.dreame.module.rn.bridge.rawdata;

import android.dreame.module.util.LogUtil;
import android.media.MediaCodec;
import android.media.MediaCodecInfo;
import android.media.MediaFormat;
import android.media.MediaMuxer;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Vector;

import kotlin.jvm.functions.Function1;

public class Mp4VideoEncoder {

    private static final String TAG = "Mp4VideoEncoder";
    private static final int MSG_CODE_ENCODE_VIDEO = 0x11;
    private static final int MSG_CODE_ENCODE_AUDIO = 0x12;

    private static final int MSG_CODE_INIT = 0x20;
    private static final int MSG_CODE_STOP = 0x21;
    private static final int MSG_CODE_FINISH = 0x22;
    private static final int MSG_CODE_SUCCESS = 0x23;

    private final static String MIME_TYPE = MediaFormat.MIMETYPE_VIDEO_AVC;
    private static final String AUDIO_MIME_TYPE = MediaFormat.MIMETYPE_AUDIO_AAC;
    public static final int AUDIO_SAMPLES_PER_FRAME = 960;
    private static final int AUDIO_SAMPLE_RATE = 48000;
    private static final int AUDIO_BIT_RATE = 64000;
    private static final long DEFAULT_TIMEOUT_US = 10000L;
    private static final String TRACK_AUDIO = "TRACK_AUDIO";
    private static final String TRACK_VIDEO = "TRACK_VIDEO";
    private static volatile Mp4VideoEncoder mVideoDecoder;

    private MediaCodec videoEncoder;
    private MediaCodec audioEncoder;
    private MediaMuxer mMediaMuxer;
    private int videoTrackIndex = -1;
    private int audioTrackIndex = -1;
    private volatile boolean isAddAudioTrack = false;
    private volatile boolean isAddVideoTrack = false;
    private Vector<byte[]> videoFrameBytes;
    private byte[] videoFrameData;
    private Vector<byte[]> audioFrameBytes;
    private final Handler mHandler;
    private final Handler audioHandler;
    private final Handler mMainHandler;
    private boolean isInitSuccess;
    private volatile boolean isExit = false;
    // 视频宽高参数
    private int mWidth;
    private int mHeight;
    private String outputPath;
    /**
     * 是否保存音频
     */
    private boolean needMixAudio = false;
    private Function1<String, Void> callback;
    private Function1<String, Void> startCallback;
    private MediaFormat audioFormat;

    public static Mp4VideoEncoder getInstance() {
        if (mVideoDecoder == null) {
            synchronized (Mp4VideoEncoder.class) {
                if (mVideoDecoder == null) {
                    mVideoDecoder = new Mp4VideoEncoder();

                }
            }
        }
        return mVideoDecoder;
    }

    private Mp4VideoEncoder() {
        HandlerThread handlerThread = new HandlerThread("mp4-encoder");
        handlerThread.start();
        mMainHandler = new Handler(Looper.getMainLooper(), msg -> {
            switch (msg.what) {
                case MSG_CODE_INIT:
                    EncoderInitParams params = (EncoderInitParams) msg.obj;
                    outputPath = params.getOutputPath();
                    mWidth = params.getWidth();
                    mHeight = params.getHeight();
                    needMixAudio = params.isNeedMixAudio();
                    initInternal();
                    break;
                case MSG_CODE_SUCCESS:
                    if (callback != null) {
                        callback.invoke(outputPath);
                    }
                    break;
                case MSG_CODE_FINISH:
                    if (callback != null) {
                        callback.invoke("");
                    }
                    break;
                case MSG_CODE_STOP:
                    isExit = true;
                    release();
                    break;
                default:
                    break;
            }
            return true;
        });
        mHandler = new Handler(handlerThread.getLooper(), msg -> {
            if (msg.what == MSG_CODE_ENCODE_VIDEO) {
                if (videoFrameBytes != null && isInitSuccess) {
                    byte[] videoData = (byte[]) msg.obj;
                    videoFrameBytes.add(videoData);
                    try {
                        encodeVideoFrame();
                    } catch (Exception e) {
                        Log.e(TAG, "解码视频(Video)数据 失败");
                    }
                }
            }
            return true;
        });
        audioHandler = new Handler(handlerThread.getLooper(), msg -> {
            if (msg.what == MSG_CODE_ENCODE_AUDIO) {
                if (audioFrameBytes != null && isInitSuccess) {
                    byte[] audioData = (byte[]) msg.obj;
                    audioFrameBytes.add(audioData);
                    try {
                        encodeAudioFrame();
                    } catch (Exception e) {
                        Log.e(TAG, "解码音频(Audio)数据 失败");
                    }
                }
            }
            return true;
        });
    }

    /**
     * 写视频数据
     */
    private void encodeVideoFrame() {
        if (isExit) {
            return;
        }
        if (videoEncoder == null || mMediaMuxer == null) {
            LogUtil.e(TAG, "encodeVideoFrame or mMediaMuxer is null");
            return;
        }
        if (videoFrameBytes.isEmpty()) {
            LogUtil.e(TAG, "encodeVideoFrame videoFrameBytes is empty");
            return;
        }

        byte[] bytes = videoFrameBytes.remove(0);
        NV21toI420SemiPlanar(bytes, videoFrameData, this.mWidth, this.mHeight);

        int inputBufferIndex = videoEncoder.dequeueInputBuffer(DEFAULT_TIMEOUT_US);
        if (inputBufferIndex >= 0) {
            ByteBuffer inputBuffer = videoEncoder.getInputBuffer(inputBufferIndex);
            inputBuffer.clear();
            inputBuffer.put(videoFrameData);
            videoEncoder.queueInputBuffer(inputBufferIndex, 0, videoFrameData.length, System.nanoTime() / 1000, 0);
        } else {
            Log.e(TAG, "encodeVideoFrame input buffer not available");
        }

        MediaCodec.BufferInfo bufferInfo = new MediaCodec.BufferInfo();
        int outputBufferIndex = videoEncoder.dequeueOutputBuffer(bufferInfo, DEFAULT_TIMEOUT_US);

        do {
            if (isExit) {
                break;
            }
            if (outputBufferIndex == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED) {
                LogUtil.d("encodeVideoFrame format改变，加入视频轨道");
                MediaFormat newFormat = videoEncoder.getOutputFormat();
                addTrackIndex(TRACK_VIDEO, newFormat);
            } else if (outputBufferIndex < 0) {
//                Log.e(TAG, "encodeVideoFrame outputBufferIndex < 0");
            } else {
                ByteBuffer outputBuffer = videoEncoder.getOutputBuffer(outputBufferIndex);
                if ((bufferInfo.flags & MediaCodec.BUFFER_FLAG_CODEC_CONFIG) != 0) {
                    bufferInfo.size = 0;
                }
                if (bufferInfo.size != 0) {
                    if (!isAddVideoTrack) {
                        MediaFormat newFormat = videoEncoder.getOutputFormat();
                        addTrackIndex(TRACK_VIDEO, newFormat);
                    }
                    outputBuffer.position(bufferInfo.offset);
                    outputBuffer.limit(bufferInfo.offset + bufferInfo.size);

                    if (isStart()) {
//                        Log.e(TAG, "encodeVideoFrame: 写入视频");
                        mMediaMuxer.writeSampleData(videoTrackIndex, outputBuffer, bufferInfo);
                    }
                }
                videoEncoder.releaseOutputBuffer(outputBufferIndex, false);
            }
            outputBufferIndex = videoEncoder.dequeueOutputBuffer(bufferInfo, DEFAULT_TIMEOUT_US);
        } while (outputBufferIndex >= 0);
    }

    /**
     * 写音频数据
     */
    private void encodeAudioFrame() {
        if (isExit) {
            return;
        }
        if (audioEncoder == null || mMediaMuxer == null) {
            LogUtil.e(TAG, "encodeAudioFrame audioEncoder or mMediaMuxer is null");
            return;
        }
        if (audioFrameBytes.isEmpty()) {
            LogUtil.e(TAG, "encodeAudioFrame audioFrameBytes is empty");
            return;
        }
        long presentationTimeUs = System.nanoTime() / 1000;
        final ByteBuffer buffer = ByteBuffer.allocateDirect(AUDIO_SAMPLES_PER_FRAME);
        byte[] audioByte = audioFrameBytes.remove(0);
        buffer.clear();
        buffer.put(audioByte);
        if (audioByte.length > 0) {
            buffer.position(audioByte.length);
            buffer.flip();
        }

        int inputBufferIndex = audioEncoder.dequeueInputBuffer(0);
        if (inputBufferIndex >= 0) {
            ByteBuffer inputBuffer = audioEncoder.getInputBuffer(inputBufferIndex);
            inputBuffer.clear();
            inputBuffer.put(buffer);
            if (audioByte.length <= 0) {
                Log.e(TAG, "send BUFFER_FLAG_END_OF_STREAM");
                audioEncoder.queueInputBuffer(inputBufferIndex, 0, 0, presentationTimeUs, MediaCodec.BUFFER_FLAG_END_OF_STREAM);
            } else {
                audioEncoder.queueInputBuffer(inputBufferIndex, 0, audioByte.length, presentationTimeUs, 0);
            }
        }

        MediaCodec.BufferInfo bufferInfo = new MediaCodec.BufferInfo();
        int outputBufferIndex;
        do {
            if (isExit) {
                break;
            }
            outputBufferIndex = audioEncoder.dequeueOutputBuffer(bufferInfo, 0);
            if (outputBufferIndex == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED) {
                LogUtil.d("encodeAudioFrame format改变，加入音轨");
                MediaFormat format = audioEncoder.getOutputFormat();
                addTrackIndex(TRACK_AUDIO, format);
            } else if (outputBufferIndex < 0) {
//                Log.e(TAG, "encodeAudioFrame outputBufferIndex < 0");
            } else {
                ByteBuffer outputBuffer = audioEncoder.getOutputBuffer(outputBufferIndex);
                if ((bufferInfo.flags & MediaCodec.BUFFER_FLAG_CODEC_CONFIG) != 0) {
                    bufferInfo.size = 0;
                }
                if (bufferInfo.size != 0 && isStart()) {
//                    Log.e(TAG, "encodeAudioFrame: 写入音频");
                    bufferInfo.presentationTimeUs = presentationTimeUs;
                    mMediaMuxer.writeSampleData(audioTrackIndex, outputBuffer, bufferInfo);
                }
                audioEncoder.releaseOutputBuffer(outputBufferIndex, false);
            }
        } while (outputBufferIndex >= 0);
    }

    private void initInternal() {
        isExit = false;
        isAddVideoTrack = false;
        isAddAudioTrack = false;
        try {
            mMediaMuxer = new MediaMuxer(this.outputPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4);
            initVideoEncoder();
            if (this.needMixAudio) {
                initAudioEncoder();
            }
            isInitSuccess = true;
        } catch (IOException e) {
            LogUtil.e(TAG, "initInternal error:" + e.getMessage());
        }
    }

    /**
     * 初始化视频编码器
     **/
    private void initVideoEncoder() {
        videoTrackIndex = -1;
        videoFrameBytes = new Vector<>();
        videoFrameData = new byte[this.mWidth * this.mHeight * 3 / 2];
        MediaFormat mediaFormat = MediaFormat.createVideoFormat(MIME_TYPE, this.mWidth, this.mHeight);
        mediaFormat.setInteger(MediaFormat.KEY_COLOR_FORMAT, MediaCodecInfo.CodecCapabilities.COLOR_FormatYUV420Planar);
        mediaFormat.setInteger(MediaFormat.KEY_BIT_RATE, 900 * 1024);
        mediaFormat.setInteger(MediaFormat.KEY_FRAME_RATE, 15);
        mediaFormat.setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1);
        try {
            videoEncoder = MediaCodec.createByCodecName("OMX.google.h264.encoder");
            videoEncoder.configure(mediaFormat, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE);
            videoEncoder.start();
        } catch (IOException e) {
            LogUtil.e(TAG, "initVideoEncoder error:" + e.getMessage());
        }
    }

    /**
     * 初始化音频编码器
     */
    private void initAudioEncoder() {
        audioTrackIndex = -1;
        audioFrameBytes = new Vector<>();
        audioFormat = MediaFormat.createAudioFormat(AUDIO_MIME_TYPE, AUDIO_SAMPLE_RATE, 1);
        audioFormat.setInteger(MediaFormat.KEY_BIT_RATE, AUDIO_BIT_RATE);
        audioFormat.setInteger(MediaFormat.KEY_CHANNEL_COUNT, 1);
        audioFormat.setInteger(MediaFormat.KEY_PROFILE, 2);
        audioFormat.setInteger(MediaFormat.KEY_LEVEL, 0);
        audioFormat.setInteger(MediaFormat.KEY_SAMPLE_RATE, AUDIO_SAMPLE_RATE);
        try {
            audioEncoder = MediaCodec.createEncoderByType(AUDIO_MIME_TYPE);
            audioEncoder.configure(audioFormat, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE);
            audioEncoder.start();
        } catch (IOException e) {
            e.printStackTrace();
            LogUtil.e(TAG, "initAudioCodec: " + e.getMessage());
        }
    }

    private void release() {
        if (videoFrameBytes != null) {
            videoFrameBytes.clear();
        }
        if (audioFrameBytes != null) {
            audioFrameBytes.clear();
        }
        if (!isInitSuccess) {
            if (callback != null) {
                LogUtil.i(TAG, "release: MSG_CODE_FINISH ");
                mMainHandler.sendEmptyMessage(MSG_CODE_FINISH);
            }
            return;
        }
        isInitSuccess = false;
        if (videoEncoder != null) {
            videoEncoder.stop();
            videoEncoder.release();
            videoEncoder = null;
            videoTrackIndex = -1;
            isAddVideoTrack = false;
        }
        if (audioEncoder != null) {
            audioEncoder.stop();
            audioEncoder.release();
            audioEncoder = null;
            audioTrackIndex = -1;
            isAddAudioTrack = false;
        }
        if (mMediaMuxer != null) {
            try {
                mMediaMuxer.stop();
            } catch (Exception e) {
                Log.e(TAG, "mediaMuxer.stop() 异常:" + e);
            }
            try {
                mMediaMuxer.release();
            } catch (Exception e) {
                Log.e(TAG, "mediaMuxer.release() 异常:" + e);
            }
            mMediaMuxer = null;
        }
        mMainHandler.sendEmptyMessage(MSG_CODE_SUCCESS);
    }

    public void addVideoData(byte[] i420, int width, int height) {
        final Message message = mHandler.obtainMessage(MSG_CODE_ENCODE_VIDEO, width, height, i420);
        mHandler.sendMessage(message);
    }

    public void addAudioData(byte[] audioData) {
        final Message message = audioHandler.obtainMessage(MSG_CODE_ENCODE_AUDIO, audioData);
        audioHandler.sendMessage(message);
    }

    public void stop() {
        final Message message = mMainHandler.obtainMessage(MSG_CODE_STOP);
        mMainHandler.sendMessage(message);
    }

    /**
     * 初始化
     */
    public boolean init(String outPath, int width, int height, boolean needMixAudio) {
        Message initMessage = mMainHandler.obtainMessage(MSG_CODE_INIT, new EncoderInitParams(width, height, outPath, needMixAudio));
        mMainHandler.sendMessage(initMessage);
        return true;
    }

    public void setCallback(Function1<String, Void> callback) {
        this.callback = callback;
    }

    public void setStartCallback(Function1<String, Void> startCallback) {
        this.startCallback = startCallback;
    }

    private synchronized void addTrackIndex(String track, MediaFormat format) {
        if (this.needMixAudio) {
            if (isAddAudioTrack && isAddVideoTrack) {
                return;
            }
        } else {
            if (isAddVideoTrack) {
                return;
            }
        }

        if (!isAddVideoTrack && track.equals(TRACK_VIDEO)) {
            LogUtil.d(TAG, "添加视频轨");
            videoTrackIndex = mMediaMuxer.addTrack(format);
            if (videoTrackIndex >= 0) {
                isAddVideoTrack = true;
                LogUtil.d(TAG, "添加视频轨完成 " + videoTrackIndex);
            }
        }

        if (!isAddAudioTrack && track.equals(TRACK_AUDIO)) {
            LogUtil.d(TAG, "添加音频轨");
            audioTrackIndex = mMediaMuxer.addTrack(format);
            if (audioTrackIndex >= 0) {
                isAddAudioTrack = true;
                LogUtil.d(TAG, "添加音频轨完成 " + audioTrackIndex);
            }
        }

        if (isStart()) {
            mMediaMuxer.start();
            if (startCallback != null) {
                startCallback.invoke(null);
            }
        }
    }

    private boolean isStart() {
        if (this.needMixAudio) {
            return isAddAudioTrack && isAddVideoTrack;
        }
        return isAddVideoTrack;
    }

    private void NV21toI420SemiPlanar(byte[] nv21bytes, byte[] i420bytes, int width,
                                      int height) {
        System.arraycopy(nv21bytes, 0, i420bytes, 0, width * height);
        for (int i = width * height; i < nv21bytes.length; i += 2) {
            i420bytes[i] = nv21bytes[i + 1];
            i420bytes[i + 1] = nv21bytes[i];
        }
    }
}

class EncoderInitParams {
    private int width;
    private int height;
    private String outputPath;
    /**
     * 是否保存音频
     */
    private boolean needMixAudio;

    public EncoderInitParams(int width, int height, String outputPath, boolean needMixAudio) {
        this.width = width;
        this.height = height;
        this.outputPath = outputPath;
        this.needMixAudio = needMixAudio;
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public String getOutputPath() {
        return outputPath;
    }

    public void setOutputPath(String outputPath) {
        this.outputPath = outputPath;
    }

    public boolean isNeedMixAudio() {
        return needMixAudio;
    }

    public void setNeedMixAudio(boolean needMixAudio) {
        this.needMixAudio = needMixAudio;
    }
}
