package android.dreame.module.bean;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.List;

public class UserInfoBean implements Parcelable {
    private String account;
    private String avatar;
    private String birthday;
    private String country;
    private String email;
    private String lang;
    private String name;
    private String phone;
    private String phoneCode;
    private String realName;
    private int sex;
    private String uid;
    private boolean hasPass;
    private boolean devOption;
    private List<String> sources; // 绑定的三方账号

    private int mailChecked;

    public UserInfoBean(){}

    protected UserInfoBean(Parcel in) {
        account = in.readString();
        avatar = in.readString();
        birthday = in.readString();
        country = in.readString();
        email = in.readString();
        lang = in.readString();
        name = in.readString();
        phone = in.readString();
        phoneCode = in.readString();
        realName = in.readString();
        sex = in.readInt();
        uid = in.readString();
        hasPass = in.readByte() != 0;
        devOption = in.readByte() != 0;
        sources = in.createStringArrayList();
        mailChecked = in.readInt();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(account);
        dest.writeString(avatar);
        dest.writeString(birthday);
        dest.writeString(country);
        dest.writeString(email);
        dest.writeString(lang);
        dest.writeString(name);
        dest.writeString(phone);
        dest.writeString(phoneCode);
        dest.writeString(realName);
        dest.writeInt(sex);
        dest.writeString(uid);
        dest.writeByte((byte) (hasPass ? 1 : 0));
        dest.writeByte((byte) (devOption ? 1 : 0));
        dest.writeStringList(sources);
        dest.writeInt(mailChecked);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<UserInfoBean> CREATOR = new Creator<UserInfoBean>() {
        @Override
        public UserInfoBean createFromParcel(Parcel in) {
            return new UserInfoBean(in);
        }

        @Override
        public UserInfoBean[] newArray(int size) {
            return new UserInfoBean[size];
        }
    };

    public List<String> getSources() {
        return sources;
    }

    public void setSources(List<String> sources) {
        this.sources = sources;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPhoneCode() {
        return phoneCode;
    }

    public void setPhoneCode(String phoneCode) {
        this.phoneCode = phoneCode;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public int getSex() {
        return sex;
    }

    public void setSex(int sex) {
        this.sex = sex;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public boolean isHasPass() {
        return hasPass;
    }

    public void setHasPass(boolean hasPass) {
        this.hasPass = hasPass;
    }

    public boolean isDevOption() {
        return devOption;
    }

    public void setDevOption(boolean devOption) {
        this.devOption = devOption;
    }

    public int getMailChecked() {
        return mailChecked;
    }

    public void setMailChecked(int mailChecked) {
        this.mailChecked = mailChecked;
    }
}
