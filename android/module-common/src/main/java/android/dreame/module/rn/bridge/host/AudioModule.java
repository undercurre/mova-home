package android.dreame.module.rn.bridge.host;

import android.media.MediaPlayer;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

/**
 * @deprecated 使用MediaPlayerModule替代
 * 新增支持暂停
 */
public class AudioModule extends ReactContextBaseJavaModule implements MediaPlayer.OnPreparedListener, MediaPlayer.OnCompletionListener{

    private MediaPlayer mPlayer;
    private volatile boolean isPrepared = true;
    public AudioModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        mPlayer=new MediaPlayer();

//        mPlayer.setOnErrorListener(this);
//        mPlayer.setOnBufferingUpdateListener(this);
        mPlayer.setOnCompletionListener(this);
        mPlayer.setOnPreparedListener(this);
    }

    @NonNull
    @Override
    public String getName() {
        return "Audio";
    }

    /**
     * 播放MP3文件
     * @param voiceUrl
     */
    @ReactMethod
    public void startPlay(String voiceUrl){
        try {
            if(mPlayer.isPlaying()){
                mPlayer.stop();
                mPlayer.reset();
            }
            //调用setDataSource方法，传入音频文件的http位置，此时处于Initialized状态
            mPlayer.setDataSource(voiceUrl);

            if (!isPrepared) {
                return;
            }
            isPrepared = false;
            mPlayer.prepareAsync();
        } catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        }
    }

    @Override
    public void onPrepared(MediaPlayer mp) {
        isPrepared = true;
        mPlayer.start();
    }

    @Override
    public void onCompletion(MediaPlayer mp) {
        isPrepared = true;
        mPlayer.stop();
        mPlayer.reset();
    }
}
