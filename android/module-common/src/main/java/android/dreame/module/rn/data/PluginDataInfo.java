package android.dreame.module.rn.data;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/06/08
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class PluginDataInfo implements Parcelable {

    private String sdkVersion;
    private String realSdkVersion;
    private String sdkPath;
    private long sdkSize;
    private String sdkMd5;
    private String pluginVersion;
    private String pluginPath;
    private long pluginSize;
    private String pluginMd5;

    private int pluginResVersion;
    private String pluginResPath;
    private long pluginResSize;
    private String pluginResMd5;
    private int commonPluginVer;

    public PluginDataInfo() {

    }

    protected PluginDataInfo(Parcel in) {
        sdkVersion = in.readString();
        realSdkVersion = in.readString();
        sdkPath = in.readString();
        sdkSize = in.readLong();
        sdkMd5 = in.readString();
        pluginVersion = in.readString();
        pluginPath = in.readString();
        pluginSize = in.readLong();
        pluginMd5 = in.readString();

        pluginResVersion = in.readInt();
        pluginResPath = in.readString();
        pluginResSize = in.readLong();
        pluginResMd5 = in.readString();
        commonPluginVer = in.readInt();
    }

    public static final Creator<PluginDataInfo> CREATOR = new Creator<PluginDataInfo>() {
        @Override
        public PluginDataInfo createFromParcel(Parcel in) {
            return new PluginDataInfo(in);
        }

        @Override
        public PluginDataInfo[] newArray(int size) {
            return new PluginDataInfo[size];
        }
    };

    public String getSdkVersion() {
        return sdkVersion;
    }

    public void setSdkVersion(String sdkVersion) {
        this.sdkVersion = sdkVersion;
    }

    public String getRealSdkVersion() {
        return realSdkVersion;
    }

    public void setRealSdkVersion(String realSdkVersion) {
        this.realSdkVersion = realSdkVersion;
    }

    public String getSdkPath() {
        return sdkPath;
    }

    public void setSdkPath(String sdkPath) {
        this.sdkPath = sdkPath;
    }

    public long getSdkSize() {
        return sdkSize;
    }

    public void setSdkSize(long sdkSize) {
        this.sdkSize = sdkSize;
    }

    public String getSdkMd5() {
        return sdkMd5;
    }

    public void setSdkMd5(String sdkMd5) {
        this.sdkMd5 = sdkMd5;
    }

    public String getPluginVersion() {
        return pluginVersion;
    }

    public void setPluginVersion(String pluginVersion) {
        this.pluginVersion = pluginVersion;
    }

    public String getPluginPath() {
        return pluginPath;
    }

    public void setPluginPath(String pluginPath) {
        this.pluginPath = pluginPath;
    }

    public long getPluginSize() {
        return pluginSize;
    }

    public void setPluginSize(long pluginSize) {
        this.pluginSize = pluginSize;
    }

    public String getPluginMd5() {
        return pluginMd5;
    }

    public void setPluginMd5(String pluginMd5) {
        this.pluginMd5 = pluginMd5;
    }

    public int getPluginResVersion() {
        return pluginResVersion;
    }

    public void setPluginResVersion(int pluginResVersion) {
        this.pluginResVersion = pluginResVersion;
    }

    public String getPluginResPath() {
        return pluginResPath;
    }

    public void setPluginResPath(String pluginResPath) {
        this.pluginResPath = pluginResPath;
    }

    public long getPluginResSize() {
        return pluginResSize;
    }

    public void setPluginResSize(long pluginResSize) {
        this.pluginResSize = pluginResSize;
    }

    public String getPluginResMd5() {
        return pluginResMd5;
    }

    public void setPluginResMd5(String pluginResMd5) {
        this.pluginResMd5 = pluginResMd5;
    }

    public int getCommonPluginVer() {
        return commonPluginVer;
    }

    public void setCommonPluginVer(int commonPluginVer) {
        this.commonPluginVer = commonPluginVer;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(sdkVersion);
        dest.writeString(realSdkVersion);
        dest.writeString(sdkPath);
        dest.writeLong(sdkSize);
        dest.writeString(sdkMd5);
        dest.writeString(pluginVersion);
        dest.writeString(pluginPath);
        dest.writeLong(pluginSize);
        dest.writeString(pluginMd5);

        dest.writeInt(pluginResVersion);
        dest.writeString(pluginResPath);
        dest.writeLong(pluginResSize);
        dest.writeString(pluginResMd5);
        dest.writeInt(commonPluginVer);
    }
}
