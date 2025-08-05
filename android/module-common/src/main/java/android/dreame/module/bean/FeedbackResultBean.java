package android.dreame.module.bean;

import java.util.List;

public class FeedbackResultBean {

    /**
     * id : 1386558429432975361
     * uid : fP556483
     * type : 0
     * contact : 骨头
     * content : 股骨头
     * os : 1
     * plugin : 0
     * images : ["dddd"]
     * videos : ["ddd"]
     * reply : 骨头
     * status : 1
     * appVersion : 3
     * appVersionName : 1.1.1
     * createTime : 1619416265000
     * updateTime : 1619597776000
     */

    private String id;
    private String uid;
    private Integer type;
    private String contact;
    private String content;
    private Integer os;
    private Integer plugin;
    private String reply;
    private Integer status;
    private Integer appVersion;
    private String appVersionName;
    private long createTime;
    private long updateTime;
    private List<String> images;
    private List<String> videos;
    private List<FeedbackChatBean> threads;
    private String model;

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getOs() {
        return os;
    }

    public void setOs(Integer os) {
        this.os = os;
    }

    public Integer getPlugin() {
        return plugin;
    }

    public void setPlugin(Integer plugin) {
        this.plugin = plugin;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getAppVersion() {
        return appVersion;
    }

    public void setAppVersion(Integer appVersion) {
        this.appVersion = appVersion;
    }

    public String getAppVersionName() {
        return appVersionName;
    }

    public void setAppVersionName(String appVersionName) {
        this.appVersionName = appVersionName;
    }

    public long getCreateTime() {
        return createTime;
    }

    public void setCreateTime(long createTime) {
        this.createTime = createTime;
    }

    public long getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(long updateTime) {
        this.updateTime = updateTime;
    }

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }

    public List<String> getVideos() {
        return videos;
    }

    public void setVideos(List<String> videos) {
        this.videos = videos;
    }

    public List<FeedbackChatBean> getThreads() {
        return threads;
    }

    public void setThreads(List<FeedbackChatBean> threads) {
        this.threads = threads;
    }
}
