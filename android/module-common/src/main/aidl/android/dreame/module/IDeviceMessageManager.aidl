// IDeviceMessageManager.aidl
package android.dreame.module;

// Declare any non-default types here with import statements
import android.os.Message;
import android.dreame.module.IMqttMessageListener;

interface IDeviceMessageManager {
    void send(in Message msg);
    void registerMqttMessageListener(in String clientId,in String topic,in IMqttMessageListener listener);
    void unregisterMqttMessageListener(in String clientId,in String topic,in IMqttMessageListener listener);
}