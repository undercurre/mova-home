package android.dreame.module.util.mqtt


interface IMqttMessageListener {
    fun onMqttMessageArrived(topic: String, message: String)
}