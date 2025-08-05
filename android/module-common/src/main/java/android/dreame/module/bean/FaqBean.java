package android.dreame.module.bean;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.List;

public class FaqBean {

    private List<ProductFaqsDTO> productFaqs;
    private List<FaqsDTO> appFaqs;

    public List<ProductFaqsDTO> getProductFaqs() {
        return productFaqs;
    }

    public void setProductFaqs(List<ProductFaqsDTO> productFaqs) {
        this.productFaqs = productFaqs;
    }

    public List<FaqsDTO> getAppFaqs() {
        return appFaqs;
    }

    public void setAppFaqs(List<FaqsDTO> appFaqs) {
        this.appFaqs = appFaqs;
    }

    public static class ProductFaqsDTO implements  Parcelable{
        /**
         * productId : 10002
         * model : dreame.vacuum.p2009
         * icon : https://cnbj2.fds.api.xiaomi.com/dreame-public/dev/products/dreame.vacuum.p2009/images/48b2a2be49e79484c17b9bda91af2c46.png
         * displayName : 追觅灵图D9扫拖机器人
         * faqs : [{"id":"faad58e03d914ff78b3fd7562992d882","productId":"10002","locale":"zh-CN","title":"设备1","bodyItems":[{"type":"text","content":"冲555"}],"priority":1,"updatedAt":"2021-05-21 03:12:14","createdAt":"2021-05-21 03:10:11","cat":false},{"id":"6d026362718a4889834ad0af6ef79aca","productId":"10002","locale":"zh-CN","title":"设备2","bodyItems":[{"type":"text","content":"222555"}],"priority":2,"updatedAt":"2021-05-21 03:12:08","createdAt":"2021-05-21 03:10:41","cat":false},{"id":"1d68bedd32e94ef091b71f60be19b3bd","productId":"10002","locale":"zh-CN","title":"设备5 带图","bodyItems":[{"type":"text","content":"sdfds4333"},{"type":"image","url":"https://cnbj2.fds.api.xiaomi.com/dreame-public/dev/faqs/b63599ed7eedbb981e6e9393e1bf0fbc.png"},{"type":"image","url":"https://cnbj2.fds.api.xiaomi.com/dreame-public/dev/faqs/aece283538f7858014c17b0fe2c6250d.png"}],"priority":3,"updatedAt":"2021-05-21 05:30:09","createdAt":"2021-05-21 03:15:19","cat":false}]
         */

        private String productId;
        private String model;
        private String icon;
        private String displayName;
        private List<FaqsDTO> faqs;

        protected ProductFaqsDTO(Parcel in) {
            productId = in.readString();
            model = in.readString();
            icon = in.readString();
            displayName = in.readString();
            faqs = in.createTypedArrayList(FaqsDTO.CREATOR);
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeString(productId);
            dest.writeString(model);
            dest.writeString(icon);
            dest.writeString(displayName);
            dest.writeTypedList(faqs);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<ProductFaqsDTO> CREATOR = new Creator<ProductFaqsDTO>() {
            @Override
            public ProductFaqsDTO createFromParcel(Parcel in) {
                return new ProductFaqsDTO(in);
            }

            @Override
            public ProductFaqsDTO[] newArray(int size) {
                return new ProductFaqsDTO[size];
            }
        };

        public String getProductId() {
            return productId;
        }

        public void setProductId(String productId) {
            this.productId = productId;
        }

        public String getModel() {
            return model;
        }

        public void setModel(String model) {
            this.model = model;
        }

        public String getIcon() {
            return icon;
        }

        public void setIcon(String icon) {
            this.icon = icon;
        }

        public String getDisplayName() {
            return displayName;
        }

        public void setDisplayName(String displayName) {
            this.displayName = displayName;
        }

        public List<FaqsDTO> getFaqs() {
            return faqs;
        }

        public void setFaqs(List<FaqsDTO> faqs) {
            this.faqs = faqs;
        }
    }

    public static class FaqsDTO implements Parcelable  {
        /**
         * id : 7c9e1487697c41c3afba7b12c134999f
         * productId :
         * locale : zh-CN
         * title : app常见问题1
         * bodyItems : [{"type":"text","content":"重启3435"}]
         * priority : 1
         * updatedAt : 2021-05-21 03:13:00
         * createdAt : 2021-05-21 03:09:39
         * cat : false
         */

        private String id;
        private String productId;
        private String locale;
        private String title;
        private Integer priority;
        private String updatedAt;
        private String createdAt;
        private Boolean cat;
        private List<BodyItemsDTO> bodyItems;

        protected FaqsDTO(Parcel in) {
            id = in.readString();
            productId = in.readString();
            locale = in.readString();
            title = in.readString();
            if (in.readByte() == 0) {
                priority = null;
            } else {
                priority = in.readInt();
            }
            updatedAt = in.readString();
            createdAt = in.readString();
            byte tmpCat = in.readByte();
            cat = tmpCat == 0 ? null : tmpCat == 1;
            bodyItems = in.createTypedArrayList(BodyItemsDTO.CREATOR);
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeString(id);
            dest.writeString(productId);
            dest.writeString(locale);
            dest.writeString(title);
            if (priority == null) {
                dest.writeByte((byte) 0);
            } else {
                dest.writeByte((byte) 1);
                dest.writeInt(priority);
            }
            dest.writeString(updatedAt);
            dest.writeString(createdAt);
            dest.writeByte((byte) (cat == null ? 0 : cat ? 1 : 2));
            dest.writeTypedList(bodyItems);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<FaqsDTO> CREATOR = new Creator<FaqsDTO>() {
            @Override
            public FaqsDTO createFromParcel(Parcel in) {
                return new FaqsDTO(in);
            }

            @Override
            public FaqsDTO[] newArray(int size) {
                return new FaqsDTO[size];
            }
        };

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getProductId() {
            return productId;
        }

        public void setProductId(String productId) {
            this.productId = productId;
        }

        public String getLocale() {
            return locale;
        }

        public void setLocale(String locale) {
            this.locale = locale;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public Integer getPriority() {
            return priority;
        }

        public void setPriority(Integer priority) {
            this.priority = priority;
        }

        public String getUpdatedAt() {
            return updatedAt;
        }

        public void setUpdatedAt(String updatedAt) {
            this.updatedAt = updatedAt;
        }

        public String getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(String createdAt) {
            this.createdAt = createdAt;
        }

        public Boolean isCat() {
            return cat;
        }

        public void setCat(Boolean cat) {
            this.cat = cat;
        }

        public List<BodyItemsDTO> getBodyItems() {
            return bodyItems;
        }

        public void setBodyItems(List<BodyItemsDTO> bodyItems) {
            this.bodyItems = bodyItems;
        }
    }

    public static class BodyItemsDTO implements Parcelable{
        /**
         * type : text
         * content : 冲555
         */

        private String type;
        private String content;
        private String url;

        protected BodyItemsDTO(Parcel in) {
            type = in.readString();
            content = in.readString();
            url = in.readString();
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeString(type);
            dest.writeString(content);
            dest.writeString(url);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<BodyItemsDTO> CREATOR = new Creator<BodyItemsDTO>() {
            @Override
            public BodyItemsDTO createFromParcel(Parcel in) {
                return new BodyItemsDTO(in);
            }

            @Override
            public BodyItemsDTO[] newArray(int size) {
                return new BodyItemsDTO[size];
            }
        };

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }
    }
}
