package android.dreame.module.bean;

import java.util.Map;

public class ShareMessageContent {

    /**
     * ackResult : 0
     * deviceId : 0
     * img :
     * localizationContents : {}
     * localizationDeviceNames : {}
     * messageId :
     * model :
     * needAck : true
     * ownUid :
     * read : true
     * readTime :
     * sendTime :
     * shareUid :
     * uid :
     */

    private int ackResult;
    private String deviceId;
    private String img;
    private Map<String,String> localizationContents;
    private Map<String,String> localizationDeviceNames;
    private String messageId;
    private String model;
    private boolean needAck;
    private String ownUid;
    private boolean read;
    private String readTime;
    private String sendTime;
    private String shareUid;
    private String uid;
    private String deviceName;
    private String ownUsername;

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public int getAckResult() {
        return ackResult;
    }

    public void setAckResult(int ackResult) {
        this.ackResult = ackResult;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }


    public String getMessageId() {
        return messageId;
    }

    public void setMessageId(String messageId) {
        this.messageId = messageId;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public boolean isNeedAck() {
        return needAck;
    }

    public void setNeedAck(boolean needAck) {
        this.needAck = needAck;
    }

    public String getOwnUid() {
        return ownUid;
    }

    public void setOwnUid(String ownUid) {
        this.ownUid = ownUid;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public String getReadTime() {
        return readTime;
    }

    public void setReadTime(String readTime) {
        this.readTime = readTime;
    }

    public String getSendTime() {
        return sendTime;
    }

    public void setSendTime(String sendTime) {
        this.sendTime = sendTime;
    }

    public String getShareUid() {
        return shareUid;
    }

    public void setShareUid(String shareUid) {
        this.shareUid = shareUid;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public Map<String, String> getLocalizationContents() {
        return localizationContents;
    }

    public void setLocalizationContents(Map<String, String> localizationContents) {
        this.localizationContents = localizationContents;
    }

    public Map<String, String> getLocalizationDeviceNames() {
        return localizationDeviceNames;
    }

    public void setLocalizationDeviceNames(Map<String, String> localizationDeviceNames) {
        this.localizationDeviceNames = localizationDeviceNames;
    }

    public String getOwnUsername() {
        return ownUsername;
    }

    public void setOwnUsername(String ownUsername) {
        this.ownUsername = ownUsername;
    }
}
