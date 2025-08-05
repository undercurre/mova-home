package com.dreame.smartlife.flutter

import android.dreame.module.util.LogUtil
import android.os.Handler
import android.os.Looper
import com.dreame.smartlife.flutter.engine.FlutterEngineId
import io.flutter.plugin.common.BasicMessageChannel

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
object FlutterMessageChannelHelper {
    private val handler = Handler(Looper.getMainLooper())
    private val messageChannels = mutableMapOf<String, BasicMessageChannel<Any>>()

    fun setMessageChannel(flutterEngineId: String, messageChannel: BasicMessageChannel<Any>?) {
        LogUtil.i("sunzhibin", "setMessageChannel: flutterEngineId: $flutterEngineId ,messageChannel:${messageChannel}")
        if (messageChannel == null) {
            messageChannels.remove(flutterEngineId)?.setMessageHandler(null)
        } else {
            messageChannels[flutterEngineId] = messageChannel
        }
    }

    fun sendMessage(
        eventName: String,
        ext: Map<String, Any?>? = mutableMapOf(),
        replayCallback: ((Any?) -> Unit)? = null
    ) {
        sendMessage(eventName, ext, null, null, replayCallback)
    }

    fun sendMessageMain(
        eventName: String,
        ext: Map<String, Any?>? = mutableMapOf(),
        replayCallback: ((Any?) -> Unit)? = null
    ) {
        val flutterEngineId =
            messageChannels.keys.firstOrNull { it.startsWith(FlutterEngineId.MAIN.id) }
        sendMessage(eventName, ext, flutterEngineId, null, replayCallback)
    }

    fun sendMessage(
        eventName: String,
        ext: Map<String, Any?>? = mutableMapOf(),
        flutterEngineId: String? = null,
        flutterEngineIdPrefix: String? = null,
        replayCallback: ((Any?) -> Unit)? = null
    ) {
        handler.post {
            val data = mutableMapOf<String, Any>()
            data["eventName"] = eventName
            data["ext"] = ext ?: mutableMapOf<String, Any?>()

            fun extracted(basicMessageChannel: BasicMessageChannel<Any>) {
                try {
                    basicMessageChannel.send(data) {
                        replayCallback?.invoke(it)
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    LogUtil.e("FlutterMessageChannelHelper", "sendMessage event:$eventName, error:  $e")
                }
            }
            if (flutterEngineId != null) {
                messageChannels[flutterEngineId]?.let {
                    extracted(it)
                }
            }
            if (flutterEngineIdPrefix != null) {
                messageChannels.entries
                    .filter { it.key.startsWith(flutterEngineIdPrefix) }
                    .onEach {
                        extracted(it.value)
                    }
            }

            if (flutterEngineId == null && flutterEngineIdPrefix == null) {
                messageChannels.values.onEach {
                    extracted(it)
                }
            }
        }
    }

    fun hasMainMessageChannel(): Boolean {
        return messageChannels.containsKey(FlutterEngineId.MAIN.id)
    }

}