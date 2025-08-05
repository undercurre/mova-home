package android.dreame.module.manager;


import android.dreame.module.LocalApplication;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.rn.utils.JsLoaderUtil;

public class DeviceManager {
    private static DeviceManager deviceManager = null;
    private static DeviceListBean.Device currentDevice = null;

    /**
     * 机器故障信息json
     */
    private String deviceWarningJson;
    /**
     * 视频直播页面
     */
    private boolean isVideo;

    public DeviceManager() {
    }

    public static DeviceManager getInstance() {
        if (deviceManager == null) {
            synchronized (DeviceManager.class) {
                if (deviceManager == null) {
                    deviceManager = new DeviceManager();
                }
            }
        }
        return deviceManager;
    }

    public DeviceListBean.Device getCurrentDevice() {
        return currentDevice;
    }

    public void setCurrentDevice(DeviceListBean.Device newDevice) {
        if (currentDevice != null && !currentDevice.getModel().equals(newDevice.getModel())) {
            JsLoaderUtil.getNativeHost(LocalApplication.getInstance()).clear();
        }
        currentDevice = newDevice;
    }

    public void setDeviceWarning(String deviceWarningJson) {
        this.deviceWarningJson = deviceWarningJson;
    }

    public String getDeviceWarning() {
        return deviceWarningJson;
    }

    public boolean isVideo() {
        return isVideo;
    }

    public void setVideo(boolean video) {
        isVideo = video;
    }
}
