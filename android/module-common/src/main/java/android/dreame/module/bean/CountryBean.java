package android.dreame.module.bean;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.Objects;

public class CountryBean implements Parcelable {

    @SerializedName("short")
    private String countryCode;
    private String en;
    private String pinyin;
    private String name;
    @SerializedName("tel")
    private String code;
    private String domain;
    private String domainAliFy;

    private transient boolean isSelected;

    private transient boolean isIndex;
    private transient String character;

    protected CountryBean(Parcel in) {
        countryCode = in.readString();
        en = in.readString();
        pinyin = in.readString();
        name = in.readString();
        code = in.readString();
        isSelected = in.readByte() != 0;
        isIndex = in.readByte() != 0;
        character = in.readString();
        domain = in.readString();
        domainAliFy = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(countryCode);
        dest.writeString(en);
        dest.writeString(pinyin);
        dest.writeString(name);
        dest.writeString(code);
        dest.writeByte((byte) (isSelected ? 1 : 0));
        dest.writeByte((byte) (isIndex ? 1 : 0));
        dest.writeString(character);
        dest.writeString(domain);
        dest.writeString(domainAliFy);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<CountryBean> CREATOR = new Creator<CountryBean>() {
        @Override
        public CountryBean createFromParcel(Parcel in) {
            return new CountryBean(in);
        }

        @Override
        public CountryBean[] newArray(int size) {
            return new CountryBean[size];
        }
    };

    public boolean isIndex() {
        return isIndex;
    }

    public void setIndex(boolean index) {
        isIndex = index;
    }

    public String getCharacter() {
        return character;
    }

    public void setCharacter(String character) {
        this.character = character;
    }

    public CountryBean() {

    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getEn() {
        return en;
    }

    public void setEn(String en) {
        this.en = en;
    }

    public String getPinyin() {
        return pinyin;
    }

    public void setPinyin(String pinyin) {
        this.pinyin = pinyin;
    }

    public String getDomain() {
        return domain;
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    public String getDomainAliFy() {
        return domainAliFy;
    }

    public void setDomainAliFy(String domainAliFy) {
        this.domainAliFy = domainAliFy;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CountryBean that = (CountryBean) o;
        return Objects.equals(countryCode, that.countryCode) && Objects.equals(en, that.en) && Objects.equals(pinyin, that.pinyin) && Objects.equals(name, that.name) && Objects.equals(code, that.code) && Objects.equals(domain, that.domain);
    }

    @Override
    public int hashCode() {
        return Objects.hash(countryCode, en, pinyin, name, code, domain);
    }
}
