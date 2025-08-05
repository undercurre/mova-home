// IMqttMessageListener.aidl
package android.dreame.module;

// Declare any non-default types here with import statements

interface IMqttMessageListener {
    void onMqttMessageArrived(in String topic,in String message);
}