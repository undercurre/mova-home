package android.dreame.module.dto;

public class RenameDTO extends BaseDTO {
  public String deviceCustomName;
  public String did;

  public RenameDTO(String deviceCustomName, String did) {
    this.deviceCustomName = deviceCustomName;
    this.did = did;
  }
}
