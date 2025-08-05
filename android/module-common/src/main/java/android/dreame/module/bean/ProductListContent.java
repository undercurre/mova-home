package android.dreame.module.bean;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public class ProductListContent implements Serializable {

    /**
     * categoryPath :
     * createdAt :
     * displayName :
     * images : [{"as":"","caption":"","height":0,"imageUrl":"","smallImageUrl":"","width":0}]
     * mainImage : {"as":"","caption":"","height":0,"imageUrl":"","smallImageUrl":"","width":0}
     * model :
     * productId :
     * remark :
     * scType :
     * status :
     * updatedAt :
     */

    private String categoryPath;
    private String createdAt;
    private String displayName;
    private ImageBean mainImage;
    private ImageBean popup;
    private String model;
    private String productId;
    private String remark;
    private String scType;
    private List<String> extendScType;
    private String feature;
    private String status;
    private String updatedAt;
    private List<ImageBean> images;
    /**
     * 多设备 pid: model
     */
    private Map<String, String> quickConnects;

    /**
     * 本地变量，扫描到wifiName
     */
    private transient String wifiName;

    public String getWifiName() {
        return wifiName;
    }

    public void setWifiName(String wifiName) {
        this.wifiName = wifiName;
    }

    public ImageBean getPopup() {
        return popup;
    }

    public void setPopup(ImageBean popup) {
        this.popup = popup;
    }

    public String getCategoryPath() {
        return categoryPath;
    }

    public void setCategoryPath(String categoryPath) {
        this.categoryPath = categoryPath;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public ImageBean getMainImage() {
        return mainImage;
    }

    public void setMainImage(ImageBean mainImage) {
        this.mainImage = mainImage;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public List<String> getExtendScType() {
        return extendScType;
    }

    public void setExtendScType(List<String> extendScType) {
        this.extendScType = extendScType;
    }

    public String getScType() {
        return scType;
    }

    public void setScType(String scType) {
        this.scType = scType;
    }

    public String getFeature() {
        return feature;
    }

    public void setFeature(String feature) {
        this.feature = feature;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<ImageBean> getImages() {
        return images;
    }

    public void setImages(List<ImageBean> images) {
        this.images = images;
    }

    public Map<String, String> getQuickConnects() {
        return quickConnects;
    }

    public void setQuickConnects(Map<String, String> quickConnects) {
        this.quickConnects = quickConnects;
    }

    public static class ImageBean implements Serializable {
        /**
         * as :
         * caption :
         * height : 0
         * imageUrl :
         * smallImageUrl :
         * width : 0
         */

        private String as;
        private String caption;
        private Integer height;
        private String imageUrl;
        private String smallImageUrl;
        private Integer width;

        public String getAs() {
            return as;
        }

        public void setAs(String as) {
            this.as = as;
        }

        public String getCaption() {
            return caption;
        }

        public void setCaption(String caption) {
            this.caption = caption;
        }

        public Integer getHeight() {
            return height;
        }

        public void setHeight(Integer height) {
            this.height = height;
        }

        public String getImageUrl() {
            return imageUrl;
        }

        public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
        }

        public String getSmallImageUrl() {
            return smallImageUrl;
        }

        public void setSmallImageUrl(String smallImageUrl) {
            this.smallImageUrl = smallImageUrl;
        }

        public Integer getWidth() {
            return width;
        }

        public void setWidth(Integer width) {
            this.width = width;
        }
    }
}
