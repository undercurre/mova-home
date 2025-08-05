package android.dreame.module.dto;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class DeviceListDTO extends BaseDTO {

  public static final int STATUS_BE_CONFIRM = 0;
  public static final int STATUS_CONFIRMED = 1;

  public int current;
  public int size;
  public String lang;
  public Boolean master;
  public Integer sharedStatus;
  @SerializedName("userDeviceVO")
  public UserDevice userDevice;


  public DeviceListDTO(int current, int size,String lang) {
    this.current = current;
    this.size = size;
    this.lang = lang;
  }

  public DeviceListDTO(int current, int size,String lang,boolean master) {
    this.current = current;
    this.size = size;
    this.lang = lang;
    this.master = master;
  }

  public DeviceListDTO(int current, int size,String lang,Integer sharedStatus) {
    this.current = current;
    this.size = size;
    this.lang = lang;
    this.master = master;
    this.sharedStatus = sharedStatus;
  }

  public class UserDevice implements Serializable {
    public String customName;
    public int did;
    public int id;
    public String lang;
    public boolean master;
    public String model;
    public String permissions;
    public String property;
    public int sharedTimes;
    public String updateTime;
  }

}
