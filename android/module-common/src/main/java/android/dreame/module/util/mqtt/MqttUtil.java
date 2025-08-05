package android.dreame.module.util.mqtt;

import android.dreame.module.LocalApplication;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.data.network.service.DreameMallLoginService;
import android.dreame.module.manager.AccountManager;
import android.dreame.module.manager.AreaManager;
import android.dreame.module.task.RetrofitInitTask;
import android.dreame.module.util.LogUtil;
import android.provider.Settings;
import android.text.TextUtils;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/06/21
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class MqttUtil {
    public static String device2ClientId(DeviceListBean.Device device) {
        String androidId = Settings.System.getString(LocalApplication.getInstance().getContentResolver(), Settings.Secure.ANDROID_ID);
        String clientId = "p_%s_%s_%s";
        String clientTag = getClientTag(device.getBindDomain());
        String uid = AccountManager.getInstance().getAccount().getUid();
        clientId = String.format(clientId, uid, androidId, clientTag);
        return clientId;
    }

    public static String mqttClientId() {
        String androidId = Settings.System.getString(LocalApplication.getInstance().getContentResolver(), Settings.Secure.ANDROID_ID);
        String clientId = "p_%s_%s";
        String uid = AccountManager.getInstance().getAccount().getUid();
        clientId = String.format(clientId, uid, androidId);
        LogUtil.d("-------- clientId ---------: " + clientId);
        return clientId;
    }

    public static String getClientTag(String host) {
        if (TextUtils.isEmpty(host)) {
            return "default";
        }
        int index2 = host.indexOf(".");
        if (index2 == -1) {
            LogUtil.e("MqttUtil", "host " + host);
            return host;
        }
        return host.substring(0, index2);
    }

    public static String getAppMessageTopic() {
        return "/msg/" + AccountManager.getInstance().getAccount().getUid() + "/";
    }

    public static String getDeviceTopic(DeviceListBean.Device device) {
        String topic = String.format("/status/%s/%s/%s/%s/",
                device.getDid(),
                device.getMasterUid(),
                device.getModel(),
                AreaManager.getRegion()
        );
        return topic;
    }

    public static String getDeviceWillsTopic(DeviceListBean.Device device) {
        String willsTopic = String.format("/w/%s/",
                device.getDid()
        );
        return willsTopic;
    }

    public static String getServerUrl() {
        String httpUrl = RetrofitInitTask.getBaseUrl();
        String serverUrl = "ssl://app.mt.%s.iot.mova-tech.com:19974";
        if (httpUrl.contains("dev")) {
            serverUrl = "ssl://devapp.mt.%s.iot.mova-tech.com:31883";
        } else if (httpUrl.contains("test")) {
            serverUrl = "ssl://testapp.mt.%s.iot.mova-tech.com:31883";
        } else if (httpUrl.contains("uat")) {
            serverUrl = "ssl://uatapp.mt.%s.iot.mova-tech.com:31883";
        } else {
            serverUrl = "ssl://app.mt.%s.iot.mova-tech.com:19974";
        }
        String realServerUrl = String.format(serverUrl, AreaManager.getRegion());
        LogUtil.i("Mqtt", realServerUrl);
        return realServerUrl;
    }

    /**
     * 获取mqtt 端口
     *
     * @return
     */
    public static String getServerPort() {
        String httpUrl = RetrofitInitTask.getBaseUrl();
        if (httpUrl.contains("dev")) {
            return "31883";
        } else if (httpUrl.contains("test")) {
            return "31883";
        } else if (httpUrl.contains("uat")) {
            return "31883";
        } else {
            return "19974";
        }
    }
}
