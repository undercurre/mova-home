package android.dreame.module.bean;

import android.os.Parcel;
import android.os.Parcelable;

public class ShareUserBean implements Parcelable {

    private String avatar;
    private String name;
    private String uid;
    private int sharedStatus;

    public ShareUserBean() {
    }

    protected ShareUserBean(Parcel in) {
        avatar = in.readString();
        name = in.readString();
        uid = in.readString();
        sharedStatus = in.readInt();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(avatar);
        dest.writeString(name);
        dest.writeString(uid);
        dest.writeInt(sharedStatus);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<ShareUserBean> CREATOR = new Creator<ShareUserBean>() {
        @Override
        public ShareUserBean createFromParcel(Parcel in) {
            return new ShareUserBean(in);
        }

        @Override
        public ShareUserBean[] newArray(int size) {
            return new ShareUserBean[size];
        }
    };

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public int getSharedStatus() {
        return sharedStatus;
    }

    public void setSharedStatus(int sharedStatus) {
        this.sharedStatus = sharedStatus;
    }
}
