package android.dreame.module.util.mqtt

object FlutterMqttManager {

    private val topicListenerList: LinkedHashMap<String, IMqttMessageListener?> = LinkedHashMap()
    private val willListenerList: LinkedHashMap<String, IMqttMessageListener?> = LinkedHashMap()

    private fun findTopicListener(topic: String?): IMqttMessageListener? {
        return topicListenerList[topic]
    }

    fun registerTopicListener(topic: String?, listener: IMqttMessageListener?) {
        topicListenerList[topic!!] = listener!!
    }

    fun unregisterTopicListener(topic: String?) {
        topicListenerList.remove(topic)
    }

    fun invokeMqttMessageListener(topic: String, payload: String) {
        val listener: IMqttMessageListener? = findTopicListener(topic)
        listener?.onMqttMessageArrived(topic, payload)
    }

    private fun findWillTopicListener(topic: String?): IMqttMessageListener? {
        return willListenerList[topic]
    }

    fun registerWillTopicListener(topic: String?, listener: IMqttMessageListener?) {
        willListenerList[topic!!] = listener!!
    }

    fun unregisterWillTopicListener(topic: String?) {
        willListenerList.remove(topic)
    }

    fun invokeMqttWillMessageListener(topic: String, payload: String) {
        val listener: IMqttMessageListener? = findWillTopicListener(topic)
        listener?.onMqttMessageArrived(topic, payload)
    }
}