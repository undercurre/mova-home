package android.dreame.module.rn.bridge.host

import android.media.MediaPlayer
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableMap
import com.facebook.react.modules.core.DeviceEventManagerModule
import kotlin.concurrent.Volatile

class MediaPlayerModule(val reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext), MediaPlayer.OnPreparedListener,
    MediaPlayer.OnCompletionListener, MediaPlayer.OnErrorListener {
    private val mPlayer: MediaPlayer by lazy {
        MediaPlayer()
    }

    @Volatile
    private var isPrepared = true

    init {
        mPlayer.setOnCompletionListener(this)
        mPlayer.setOnPreparedListener(this)
        mPlayer.setOnErrorListener(this)
    }

    /**
     * 播放音频
     * @param path 路径，支持在线、本地
     */
    @ReactMethod
    fun startPlay(path: String) {
        try {
            if (mPlayer.isPlaying) {
                mPlayer.stop()
                mPlayer.reset()
            }
            mPlayer.setDataSource(path)
            if (!isPrepared) {
                return
            }
            isPrepared = false
            mPlayer.prepareAsync()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    @ReactMethod
    fun stopPlay() {
        if (mPlayer.isPlaying) {
            mPlayer.stop()
            mPlayer.reset()
        }
    }

    /**
     * @param eventName 事件名 EventPlay
     * @param playState 播放状态：Prepared-准备，Completion-完成，Error-播放错误
     */
    private fun sendEvent(eventName: String = "EventPlay", playState: String) {
        val params: WritableMap = Arguments.createMap()
        params.putString("playState", playState)
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    override fun onError(p0: MediaPlayer?, p1: Int, p2: Int): Boolean {
        sendEvent(playState = "Error")
        return true
    }

    override fun getName(): String = "MediaPlayer"

    override fun onPrepared(p0: MediaPlayer) {
        isPrepared = true
        mPlayer.start()
        sendEvent(playState = "Prepared")
    }

    override fun onCompletion(p0: MediaPlayer) {
        isPrepared = true
        mPlayer.stop()
        mPlayer.reset()
        sendEvent(playState = "Completion")
    }
}