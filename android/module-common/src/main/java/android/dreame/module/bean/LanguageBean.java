package android.dreame.module.bean;

import android.os.Parcel;
import android.os.Parcelable;

public class LanguageBean implements Parcelable {
    private String displayLang;
    private String langTag;
    private String country;
    private boolean isSelected;

    public LanguageBean() {
    }

    public LanguageBean(String displayLang, String langTag) {
        this.displayLang = displayLang;
        this.langTag = langTag;
    }

    public LanguageBean(String displayLang, String langTag, String country) {
        this.displayLang = displayLang;
        this.langTag = langTag;
        this.country = country;
    }

    protected LanguageBean(Parcel in) {
        displayLang = in.readString();
        langTag = in.readString();
        country = in.readString();
        isSelected = in.readByte() != 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(displayLang);
        dest.writeString(langTag);
        dest.writeString(country);
        dest.writeByte((byte) (isSelected ? 1 : 0));
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<LanguageBean> CREATOR = new Creator<LanguageBean>() {
        @Override
        public LanguageBean createFromParcel(Parcel in) {
            return new LanguageBean(in);
        }

        @Override
        public LanguageBean[] newArray(int size) {
            return new LanguageBean[size];
        }
    };

    public String getDisplayLang() {
        return displayLang;
    }

    public void setDisplayLang(String displayLang) {
        this.displayLang = displayLang;
    }

    public String getLangTag() {
        return langTag;
    }

    public void setLangTag(String langTag) {
        this.langTag = langTag;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }
}
