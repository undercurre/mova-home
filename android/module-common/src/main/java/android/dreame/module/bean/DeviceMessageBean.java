package android.dreame.module.bean;

import android.os.Parcel;
import android.os.Parcelable;

public class DeviceMessageBean implements Parcelable {

    /**
     * deviceId : 364862507
     * deviceName : 追觅灵图D9扫拖机器人
     * img : https://cnbj2.fds.api.xiaomi.com/dreame-iot/products/20210311/e1fbd48ee1408825c33c5f81a4979032.png
     * model : dreame.vacuum.p2009
     * message : {"messageId":"842a2811a0f2446fa45dc78889f39c40","uid":"Eu904561","deviceId":364862507,"model":"dreame.vacuum.p2009","type":0,"share":0,"read":true,"localizationContents":{"en-US":"Go Charging","zh-CN":"正在回充"},"sendTime":"2021-03-01T10:00:10.039","readTime":"2021-03-04T06:52:32.908","localizationSolutions":{},"solutionUrl":""}
     * unread : 0
     */

    private String deviceId;
    private String deviceName;
    private String icon;
    private String model;
    private MsgListContent message;
    private Integer unread;

    public DeviceMessageBean() {
    }

    protected DeviceMessageBean(Parcel in) {
        deviceId = in.readString();
        deviceName = in.readString();
        icon = in.readString();
        model = in.readString();
        message = in.readParcelable(MsgListContent.class.getClassLoader());
        if (in.readByte() == 0) {
            unread = null;
        } else {
            unread = in.readInt();
        }
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(deviceId);
        dest.writeString(deviceName);
        dest.writeString(icon);
        dest.writeString(model);
        dest.writeParcelable(message, flags);
        if (unread == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(unread);
        }
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<DeviceMessageBean> CREATOR = new Creator<DeviceMessageBean>() {
        @Override
        public DeviceMessageBean createFromParcel(Parcel in) {
            return new DeviceMessageBean(in);
        }

        @Override
        public DeviceMessageBean[] newArray(int size) {
            return new DeviceMessageBean[size];
        }
    };

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public MsgListContent getMessage() {
        return message;
    }

    public void setMessage(MsgListContent message) {
        this.message = message;
    }

    public Integer getUnread() {
        return unread;
    }

    public void setUnread(Integer unread) {
        this.unread = unread;
    }
}
