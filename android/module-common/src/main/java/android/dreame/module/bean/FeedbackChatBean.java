package android.dreame.module.bean;

public class FeedbackChatBean {
    public static final int CONTENT_TYPE_TEXT = 1;
    public static final int CONTENT_TYPE_IMAGE = 2;
    public static final int REPLY_TYPE_RECEIVE = 1;
    public static final int REPLY_TYPE_SEND = 0;

    private String content;
    private int contentType;
    private long createTime;
    private String feedbackId;
    private long id;
    private int reply;
    private String tenantId;
    private String uid;
    private long updateTime;

    public FeedbackChatBean(String content, int contentType, int reply) {
        this.content = content;
        this.contentType = contentType;
        this.reply = reply;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getContentType() {
        return contentType;
    }

    public void setContentType(int contentType) {
        this.contentType = contentType;
    }

    public long getCreateTime() {
        return createTime;
    }

    public void setCreateTime(long createTime) {
        this.createTime = createTime;
    }

    public String getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(String feedbackId) {
        this.feedbackId = feedbackId;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getReply() {
        return reply;
    }

    public void setReply(int reply) {
        this.reply = reply;
    }

    public String getTenantId() {
        return tenantId;
    }

    public void setTenantId(String tenantId) {
        this.tenantId = tenantId;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public long getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(long updateTime) {
        this.updateTime = updateTime;
    }
}
