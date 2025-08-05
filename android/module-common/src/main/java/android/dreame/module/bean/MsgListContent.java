package android.dreame.module.bean;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.Map;

public class MsgListContent implements Parcelable {

    public static final int TYPE_NORMAL = 0;
    public static final int TYPE_ERROR = 1;

    private String messageId;
    private String uid;
    private Integer deviceId;
    private String model;
    private Integer type;
    private Integer share;
    private boolean read;
    private Map<String,String> localizationContents;
    private String sendTime;
    private String readTime;
    private Map<String,String> localizationSolutions;
    private String solutionUrl;
    private SourceEntry source;

    private boolean selected;

    protected MsgListContent(Parcel in) {
        messageId = in.readString();
        uid = in.readString();
        if (in.readByte() == 0) {
            deviceId = null;
        } else {
            deviceId = in.readInt();
        }
        model = in.readString();
        if (in.readByte() == 0) {
            type = null;
        } else {
            type = in.readInt();
        }
        if (in.readByte() == 0) {
            share = null;
        } else {
            share = in.readInt();
        }
        read = in.readByte() != 0;
        sendTime = in.readString();
        readTime = in.readString();
        solutionUrl = in.readString();
        source = in.readParcelable(SourceEntry.class.getClassLoader());
        selected = in.readByte() != 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(messageId);
        dest.writeString(uid);
        if (deviceId == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(deviceId);
        }
        dest.writeString(model);
        if (type == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(type);
        }
        if (share == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(share);
        }
        dest.writeByte((byte) (read ? 1 : 0));
        dest.writeString(sendTime);
        dest.writeString(readTime);
        dest.writeString(solutionUrl);
        dest.writeParcelable(source, flags);
        dest.writeByte((byte) (selected ? 1 : 0));
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<MsgListContent> CREATOR = new Creator<MsgListContent>() {
        @Override
        public MsgListContent createFromParcel(Parcel in) {
            return new MsgListContent(in);
        }

        @Override
        public MsgListContent[] newArray(int size) {
            return new MsgListContent[size];
        }
    };

    public SourceEntry getSource() {
        return source;
    }

    public void setSource(SourceEntry source) {
        this.source = source;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    public String getMessageId() {
        return messageId;
    }

    public void setMessageId(String messageId) {
        this.messageId = messageId;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public Integer getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(Integer deviceId) {
        this.deviceId = deviceId;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getShare() {
        return share;
    }

    public void setShare(Integer share) {
        this.share = share;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public Map<String, String> getLocalizationContents() {
        return localizationContents;
    }

    public void setLocalizationContents(Map<String, String> localizationContents) {
        this.localizationContents = localizationContents;
    }

    public String getSendTime() {
        return sendTime;
    }

    public void setSendTime(String sendTime) {
        this.sendTime = sendTime;
    }

    public String getReadTime() {
        return readTime;
    }

    public void setReadTime(String readTime) {
        this.readTime = readTime;
    }

    public Map<String, String> getLocalizationSolutions() {
        return localizationSolutions;
    }

    public void setLocalizationSolutions(Map<String, String> localizationSolutions) {
        this.localizationSolutions = localizationSolutions;
    }

    public String getSolutionUrl() {
        return solutionUrl;
    }

    public void setSolutionUrl(String solutionUrl) {
        this.solutionUrl = solutionUrl;
    }

    public static class SourceEntry implements Parcelable{
        private String piid;
        private String eiid;
        private String value;
        private String ssid;
        private String aiid;

        protected SourceEntry(Parcel in) {
            piid = in.readString();
            eiid = in.readString();
            value = in.readString();
            ssid = in.readString();
            aiid = in.readString();
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeString(piid);
            dest.writeString(eiid);
            dest.writeString(value);
            dest.writeString(ssid);
            dest.writeString(aiid);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<SourceEntry> CREATOR = new Creator<SourceEntry>() {
            @Override
            public SourceEntry createFromParcel(Parcel in) {
                return new SourceEntry(in);
            }

            @Override
            public SourceEntry[] newArray(int size) {
                return new SourceEntry[size];
            }
        };

        public String getPiid() {
            return piid;
        }

        public void setPiid(String piid) {
            this.piid = piid;
        }

        public String getEiid() {
            return eiid;
        }

        public void setEiid(String eiid) {
            this.eiid = eiid;
        }

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public String getSsid() {
            return ssid;
        }

        public void setSsid(String ssid) {
            this.ssid = ssid;
        }

        public String getAiid() {
            return aiid;
        }

        public void setAiid(String aiid) {
            this.aiid = aiid;
        }
    }
}
