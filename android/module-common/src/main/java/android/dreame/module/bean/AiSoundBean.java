package android.dreame.module.bean;

import java.io.Serializable;

public class AiSoundBean implements Serializable {
    private String name;
    private String imageUrl;
    private String linkUrl;
    private AndroidSoundBean android;
    private String title;
    private String button;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getButton() {
        return button;
    }

    public void setButton(String button) {
        this.button = button;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
    }

    public AndroidSoundBean getAndroid() {
        return android;
    }

    public void setAndroid(AndroidSoundBean android) {
        this.android = android;
    }

    public static class AndroidSoundBean implements Serializable {
        private String packageName;
        private String downloadUrl;

        public String getPackageName() {
            return packageName;
        }

        public void setPackageName(String packageName) {
            this.packageName = packageName;
        }

        public String getDownloadUrl() {
            return downloadUrl;
        }

        public void setDownloadUrl(String downloadUrl) {
            this.downloadUrl = downloadUrl;
        }
    }
}
