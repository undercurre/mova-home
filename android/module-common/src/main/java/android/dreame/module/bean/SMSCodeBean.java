package android.dreame.module.bean;

public class SMSCodeBean {
  private String codeKey;
  private int maxSends;
  private int resetIn;
  private int interval;
  private int expireIn;
  private int remains;
  private boolean unregistered;

  public String getCodeKey() {
    return codeKey;
  }

  public void setCodeKey(String codeKey) {
    this.codeKey = codeKey;
  }

  public int getMaxSends() {
    return maxSends;
  }

  public void setMaxSends(int maxSends) {
    this.maxSends = maxSends;
  }

  public int getResetIn() {
    return resetIn;
  }

  public void setResetIn(int resetIn) {
    this.resetIn = resetIn;
  }

  public int getInterval() {
    return interval;
  }

  public void setInterval(int interval) {
    this.interval = interval;
  }

  public int getExpireIn() {
    return expireIn;
  }

  public void setExpireIn(int expireIn) {
    this.expireIn = expireIn;
  }

  public int getRemains() {
    return remains;
  }

  public void setRemains(int remains) {
    this.remains = remains;
  }

  public boolean isUnregistered() {
    return unregistered;
  }

  public void setUnregistered(boolean unregistered) {
    this.unregistered = unregistered;
  }
}
