package android.dreame.module.bean;

import android.dreame.module.util.LogUtil;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.Nullable;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;
import java.util.List;

public class DeviceListBean extends BaseHttpResult implements Serializable {
    public DeviceListBean(int code, String msg) {
        super(code, msg);
    }

    private Page page;

    public void setPage(Page page) {
        this.page = page;
    }

    public Page getPage() {
        return page;
    }

    public static class Page implements Serializable {
        private List<Device> records;
        private String total;
        private String size;
        private String current;
        private boolean optimizeCountSql;
        private boolean hitCount;
        private boolean searchCount;
        private String pages;

        public boolean isOptimizeCountSql() {
            return optimizeCountSql;
        }

        public void setOptimizeCountSql(boolean optimizeCountSql) {
            this.optimizeCountSql = optimizeCountSql;
        }

        public boolean isHitCount() {
            return hitCount;
        }

        public void setHitCount(boolean hitCount) {
            this.hitCount = hitCount;
        }

        public boolean isSearchCount() {
            return searchCount;
        }

        public void setSearchCount(boolean searchCount) {
            this.searchCount = searchCount;
        }

        public String getPages() {
            return pages;
        }

        public void setPages(String pages) {
            this.pages = pages;
        }

        public List<Device> getRecords() {
            return records;
        }

        public void setRecords(List<Device> records) {
            this.records = records;
        }

        public String getTotal() {
            return total;
        }

        public void setTotal(String total) {
            this.total = total;
        }

        public String getSize() {
            return size;
        }

        public void setSize(String size) {
            this.size = size;
        }

        public String getCurrent() {
            return current;
        }

        public void setCurrent(String current) {
            this.current = current;
        }
    }

    public static class Device implements Parcelable {
        private String id;
        private String did;
        private String model;
        private String property;
        private String sn;
        private boolean master;
        private String bindDomain;
        private String permissions;
        private int sharedTimes;
        private String dispalyName;
        private String customName;
        private String lang;
        private String updateTime;
        private boolean online;
        private DeviceInfo deviceInfo;
        private int sharedStatus;
        /**
         * 设备最近状态，,应该结合online 状态
         * 1: 正在清扫
         * 2: 待机
         * 3: 暂停
         * 4: 暂停
         * 5: 正在回充
         * 6: 正在充电
         * 7: 正在拖地
         */
        private int latestStatus;
        /**
         * 视频监控状态
         * 0: 关闭
         * >=1: 开启
         */
        private int monitorStatus;
        private String videoStatus;
        private String masterUid;
        private String masterName;
        private transient boolean showVideo;
        private int featureCode;
        private int featureCode2;
        private String ver;
        private String iotId;

        private boolean supportFastCommand;
        private List<FastCommand> fastCommandList;

        private int battery;

        private transient int currentControlTab = 0;
        private transient boolean isLocalCache;

        private String lastWill;

        private KeyDefine keyDefine;

        private float cleanArea;
        private int cleanTime;
        private String vendor;

        public Device() {
        }


        protected Device(Parcel in) {
            id = in.readString();
            did = in.readString();
            model = in.readString();
            property = in.readString();
            sn = in.readString();
            master = in.readByte() != 0;
            bindDomain = in.readString();
            permissions = in.readString();
            sharedTimes = in.readInt();
            dispalyName = in.readString();
            customName = in.readString();
            lang = in.readString();
            updateTime = in.readString();
            online = in.readByte() != 0;
            deviceInfo = in.readParcelable(DeviceInfo.class.getClassLoader());
            sharedStatus = in.readInt();
            latestStatus = in.readInt();
            monitorStatus = in.readInt();
            videoStatus = in.readString();
            masterUid = in.readString();
            masterName = in.readString();
            featureCode = in.readInt();
            featureCode2 = in.readInt();
            ver = in.readString();
            iotId = in.readString();
            supportFastCommand = in.readByte() != 0;
            fastCommandList = in.createTypedArrayList(FastCommand.CREATOR);
            battery = in.readInt();
            lastWill = in.readString();
            keyDefine = in.readParcelable(KeyDefine.class.getClassLoader());
            cleanArea = in.readFloat();
            cleanTime = in.readInt();
            vendor = in.readString();
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeString(id);
            dest.writeString(did);
            dest.writeString(model);
            dest.writeString(property);
            dest.writeString(sn);
            dest.writeByte((byte) (master ? 1 : 0));
            dest.writeString(bindDomain);
            dest.writeString(permissions);
            dest.writeInt(sharedTimes);
            dest.writeString(dispalyName);
            dest.writeString(customName);
            dest.writeString(lang);
            dest.writeString(updateTime);
            dest.writeByte((byte) (online ? 1 : 0));
            dest.writeParcelable(deviceInfo, flags);
            dest.writeInt(sharedStatus);
            dest.writeInt(latestStatus);
            dest.writeInt(monitorStatus);
            dest.writeString(videoStatus);
            dest.writeString(masterUid);
            dest.writeString(masterName);
            dest.writeInt(featureCode);
            dest.writeInt(featureCode2);
            dest.writeString(ver);
            dest.writeString(iotId);
            dest.writeByte((byte) (supportFastCommand ? 1 : 0));
            dest.writeTypedList(fastCommandList);
            dest.writeInt(battery);
            dest.writeString(lastWill);
            dest.writeParcelable(keyDefine, flags);
            dest.writeFloat(cleanArea);
            dest.writeInt(cleanTime);
            dest.writeString(vendor);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<Device> CREATOR = new Creator<Device>() {
            @Override
            public Device createFromParcel(Parcel in) {
                return new Device(in);
            }

            @Override
            public Device[] newArray(int size) {
                return new Device[size];
            }
        };

        public String getVendor() {
            return vendor;
        }

        public void setVendor(String vendor) {
            this.vendor = vendor;
        }

        public float getCleanArea() {
            return cleanArea;
        }

        public void setCleanArea(float cleanArea) {
            this.cleanArea = cleanArea;
        }

        public int getCleanTime() {
            return cleanTime;
        }

        public void setCleanTime(int cleanTime) {
            this.cleanTime = cleanTime;
        }

        public int getBattery() {
            return battery;
        }

        public void setBattery(int battery) {
            this.battery = battery;
        }

        public String getVer() {
            return ver;
        }

        public void setVer(String ver) {
            this.ver = ver;
        }

        public String getDispalyName() {
            return dispalyName;
        }

        public void setDispalyName(String dispalyName) {
            this.dispalyName = dispalyName;
        }

        public String getMasterName() {
            return masterName;
        }

        public void setMasterName(String masterName) {
            this.masterName = masterName;
        }

        public String getMasterUid() {
            return masterUid;
        }

        public void setMasterUid(String masterUid) {
            this.masterUid = masterUid;
        }

        public int getLatestStatus() {
            return latestStatus;
        }

        public void setLatestStatus(int latestStatus) {
            Log.i("wufei", "setLatestStatus: " + latestStatus);
            this.latestStatus = latestStatus;
        }

        public int getMonitorStatus() {
            if (!TextUtils.isEmpty(videoStatus)) {
                LogUtil.i("DeviceListBean", "getMonitorStatus videoStatus: " + videoStatus);
                try {
                    // FIXME: 28.2.22 I don't know why videoStatus = 1
                    JsonObject jsonObject = new JsonParser().parse(videoStatus).getAsJsonObject();
                    monitorStatus = jsonObject.get("status").getAsInt();
                    videoStatus = "";
                } catch (Exception e) {
                    LogUtil.e("getMonitorStatus: " + Log.getStackTraceString(e));
                }

            }
            return monitorStatus;
        }

        public void setMonitorStatus(int monitorStatus) {
            this.monitorStatus = monitorStatus;
            this.videoStatus = "";
        }

        public String getVideoStatus() {
            return videoStatus;
        }

        public void setVideoStatus(String videoStatus) {
            this.videoStatus = videoStatus;
        }

        public int getSharedStatus() {
            return sharedStatus;
        }

        public void setSharedStatus(int sharedStatus) {
            this.sharedStatus = sharedStatus;
        }

        public String getLang() {
            return lang;
        }

        public void setLang(String lang) {
            this.lang = lang;
        }

        public String getUpdateTime() {
            return updateTime;
        }

        public void setUpdateTime(String updateTime) {
            this.updateTime = updateTime;
        }

        public boolean isOnline() {
            return online;
        }

        public void setOnline(boolean online) {
            this.online = online;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getDid() {
            return did;
        }

        public void setDid(String did) {
            this.did = did;
        }

        public String getModel() {
            return model;
        }

        public void setModel(String model) {
            this.model = model;
        }

        public String getProperty() {
            return property;
        }

        public void setProperty(String property) {
            this.property = property;
        }

        public boolean isMaster() {
            return master;
        }

        public void setMaster(boolean master) {
            this.master = master;
        }

        public String getPermissions() {
            return permissions;
        }

        public void setPermissions(String permissions) {
            this.permissions = permissions;
        }

        public boolean getVideoPermission() {
            String permissions = getPermissions();
            if (TextUtils.isEmpty(permissions)) {
                return false;
            } else {
                String[] permissionArr = permissions.split(",");
                for (String per : permissionArr) {
                    if (TextUtils.equals(per.toUpperCase(), "VIDEO")) {
                        return true;
                    }
                }
                return false;
            }
        }

        public int getSharedTimes() {
            return sharedTimes;
        }

        public void setSharedTimes(int sharedTimes) {
            this.sharedTimes = sharedTimes;
        }

        public String getCustomName() {
            return customName;
        }

        public void setCustomName(String customName) {
            this.customName = customName;
        }

        public DeviceInfo getDeviceInfo() {
            return deviceInfo;
        }

        public void setDeviceInfo(DeviceInfo deviceInfo) {
            this.deviceInfo = deviceInfo;
        }

        public void setBindDomain(String bindDomain) {
            this.bindDomain = bindDomain;
        }

        public String getBindDomain() {
            return bindDomain;
        }

        public boolean isShowVideo() {
            featureCode = featureCode < 0 ? 0 : featureCode;
            featureCode2 = featureCode2 < 0 ? 0 : featureCode2;
            int value = featureCode | featureCode2;
            return (value & 1) != 0;
        }

        public int getFeatureCode() {
            int code1 = Math.max(featureCode, 0);
            int code2 = Math.max(featureCode2, 0);
            return code1 | code2;
        }

        public void setFeatureCode(int featureCode) {
            this.featureCode = featureCode;
        }

        public boolean isSupportFastCommand() {
            return deviceInfo.feature.contains("fastCommand");
        }

        /**
         * 同时支持清扫与视频
         */
        public boolean supportVideoMultitask() {
            featureCode = Math.max(featureCode, 0);
            featureCode2 = Math.max(featureCode2, 0);
            int value = featureCode | featureCode2;
            return (value & 4) == 4;
        }

        public void setSupportFastCommand(boolean supportFastCommand) {
            this.supportFastCommand = supportFastCommand;
        }

        public int getFeatureCode2() {
            return featureCode2;
        }

        public void setFeatureCode2(int featureCode2) {
            this.featureCode2 = featureCode2;
        }

        public List<FastCommand> getFastCommandList() {
            return fastCommandList;
        }

        public void setFastCommandList(List<FastCommand> fastCommandList) {
            this.fastCommandList = fastCommandList;
        }

        @Nullable
        public FastCommand getExecutingFastCommand() {
            if (fastCommandList != null) {
                for (FastCommand fastCommand : fastCommandList) {
                    if ("1".equals(fastCommand.state) || "0".equals(fastCommand.state)) {
                        return fastCommand;
                    }
                }
            }
            return null;
        }

        public int getCurrentControlTab() {
            return currentControlTab;
        }

        public void setCurrentControlTab(int currentControlTab) {
            this.currentControlTab = currentControlTab;
        }

        public String getSn() {
            return sn;
        }

        public void setSn(String sn) {
            this.sn = sn;
        }

        public String getIotId() {
            if (TextUtils.isEmpty(iotId)) {
                try {
                    JSONObject propertyJson = new JSONObject(property);
                    iotId = propertyJson.optString("iotId", "");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            return iotId;
        }

        public void setIotId(String iotId) {
            this.iotId = iotId;
        }

        public boolean aliDevice() {
            return deviceInfo != null && deviceInfo.feature.contains("video_ali");
        }

        public boolean isLocalCache() {
            return isLocalCache;
        }

        public void setLocalCache(boolean localCache) {
            isLocalCache = localCache;
        }

        public String getLastWill() {
            return lastWill;
        }

        public void setLastWill(String lastWill) {
            this.lastWill = lastWill;
        }

        public KeyDefine getKeyDefine() {
            return keyDefine;
        }

        public void setKeyDefine(KeyDefine keyDefine) {
            this.keyDefine = keyDefine;
        }

        public boolean supportLastWill() {
            boolean supportLastWill = false;
            try {
                JSONObject property = new JSONObject(getProperty());
                supportLastWill = property.optInt("lwt", 0) == 1;
            } catch (Exception exception) {
                LogUtil.e("supportLastWill error");
            }
            return supportLastWill;
        }
    }

    public static class KeyDefine implements Parcelable {
        private int ver;
        private String url;

        protected KeyDefine(Parcel in) {
            ver = in.readInt();
            url = in.readString();
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeInt(ver);
            dest.writeString(url);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<KeyDefine> CREATOR = new Creator<KeyDefine>() {
            @Override
            public KeyDefine createFromParcel(Parcel in) {
                return new KeyDefine(in);
            }

            @Override
            public KeyDefine[] newArray(int size) {
                return new KeyDefine[size];
            }
        };

        public int getVer() {
            return ver;
        }

        public void setVer(int ver) {
            this.ver = ver;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }
    }

    public static class DeviceInfo implements Parcelable {
        private String productId;
        private String categoryPath;
        private String model;
        private String remark;
        private String scType;
        private String status;
        private String updatedAt;
        private String createdAt;
        private MainImage mainImage;
        private MainImage popup;
        private MainImage overlook;
        private String displayName;
        private String feature;
        private boolean videoDynamicVendor;
        private String permit;

        public DeviceInfo() {
        }


        protected DeviceInfo(Parcel in) {
            productId = in.readString();
            categoryPath = in.readString();
            model = in.readString();
            remark = in.readString();
            scType = in.readString();
            status = in.readString();
            updatedAt = in.readString();
            createdAt = in.readString();
            mainImage = in.readParcelable(MainImage.class.getClassLoader());
            popup = in.readParcelable(MainImage.class.getClassLoader());
            overlook = in.readParcelable(MainImage.class.getClassLoader());
            displayName = in.readString();
            feature = in.readString();
            videoDynamicVendor = in.readByte() != 0;
            permit = in.readString();
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeString(productId);
            dest.writeString(categoryPath);
            dest.writeString(model);
            dest.writeString(remark);
            dest.writeString(scType);
            dest.writeString(status);
            dest.writeString(updatedAt);
            dest.writeString(createdAt);
            dest.writeParcelable(mainImage, flags);
            dest.writeParcelable(popup, flags);
            dest.writeParcelable(overlook, flags);
            dest.writeString(displayName);
            dest.writeString(feature);
            dest.writeByte((byte) (videoDynamicVendor ? 1 : 0));
            dest.writeString(permit);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<DeviceInfo> CREATOR = new Creator<DeviceInfo>() {
            @Override
            public DeviceInfo createFromParcel(Parcel in) {
                return new DeviceInfo(in);
            }

            @Override
            public DeviceInfo[] newArray(int size) {
                return new DeviceInfo[size];
            }
        };

        public String getPermit() {
            return permit;
        }

        public void setPermit(String permit) {
            this.permit = permit;
        }

        public boolean isVideoDynamicVendor() {
            return videoDynamicVendor;
        }

        public void setVideoDynamicVendor(boolean videoDynamicVendor) {
            this.videoDynamicVendor = videoDynamicVendor;
        }

        public String getFeature() {
            return feature;
        }

        public void setFeature(String feature) {
            this.feature = feature;
        }

        public MainImage getOverlook() {
            return overlook;
        }

        public void setOverlook(MainImage overlook) {
            this.overlook = overlook;
        }

        public MainImage getPopup() {
            return popup;
        }

        public void setPopup(MainImage popup) {
            this.popup = popup;
        }

        public String getDisplayName() {
            return displayName;
        }

        public void setDisplayName(String displayName) {
            this.displayName = displayName;
        }

        public String getProductId() {
            return productId;
        }

        public void setProductId(String productId) {
            this.productId = productId;
        }

        public String getCategoryPath() {
            return categoryPath;
        }

        public void setCategoryPath(String categoryPath) {
            this.categoryPath = categoryPath;
        }

        public String getModel() {
            return model;
        }

        public void setModel(String model) {
            this.model = model;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }

        public String getScType() {
            return scType;
        }

        public void setScType(String scType) {
            this.scType = scType;
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

        public String getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(String createdAt) {
            this.createdAt = createdAt;
        }

        public void setMainImage(MainImage mainImage) {
            this.mainImage = mainImage;
        }

        public MainImage getMainImage() {
            return mainImage;
        }

    }

    public static class MainImage implements Parcelable {
        private String as;
        private String caption;
        private String height;
        private String width;
        private String imageUrl;
        private String smallImageUrl;

        protected MainImage(Parcel in) {
            as = in.readString();
            caption = in.readString();
            height = in.readString();
            width = in.readString();
            imageUrl = in.readString();
            smallImageUrl = in.readString();
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeString(as);
            dest.writeString(caption);
            dest.writeString(height);
            dest.writeString(width);
            dest.writeString(imageUrl);
            dest.writeString(smallImageUrl);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<MainImage> CREATOR = new Creator<MainImage>() {
            @Override
            public MainImage createFromParcel(Parcel in) {
                return new MainImage(in);
            }

            @Override
            public MainImage[] newArray(int size) {
                return new MainImage[size];
            }
        };

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

        public String getHeight() {
            return height;
        }

        public void setHeight(String height) {
            this.height = height;
        }

        public String getWidth() {
            return width;
        }

        public void setWidth(String width) {
            this.width = width;
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
    }

    public static class FastCommand implements Parcelable {
        private long id;
        private String name;
        /**
         * 1正在执行
         * 0暂停
         * 空字符串：非任务中
         */
        private String state;

        protected FastCommand(Parcel in) {
            id = in.readLong();
            name = in.readString();
            state = in.readString();
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeLong(id);
            dest.writeString(name);
            dest.writeString(state);
        }

        @Override
        public int describeContents() {
            return 0;
        }

        public static final Creator<FastCommand> CREATOR = new Creator<FastCommand>() {
            @Override
            public FastCommand createFromParcel(Parcel in) {
                return new FastCommand(in);
            }

            @Override
            public FastCommand[] newArray(int size) {
                return new FastCommand[size];
            }
        };

        public String getState() {
            return state;
        }

        public void setState(String state) {
            this.state = state;
        }

        public FastCommand(long id, String name) {
            this.id = id;
            this.name = name;
        }


        public long getId() {
            return id;
        }

        public void setId(long id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }


    }
}
