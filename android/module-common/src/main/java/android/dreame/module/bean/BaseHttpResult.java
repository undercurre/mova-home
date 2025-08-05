package android.dreame.module.bean;

import java.io.Serializable;

public class BaseHttpResult<T> implements Serializable {
  private int code = -100;
  private T data;
  private String msg;
  private boolean success;

  public BaseHttpResult(int code, String msg) {
    this.code = code;
    this.msg = msg;
  }

  public void setSuccess(boolean success) {
    this.success = success;
  }

  public boolean isSuccess() {
    return success;
  }

  public int getCode() {
    return code;
  }

  public void setCode(int code) {
    this.code = code;
  }

  public T getData() {
    return data;
  }

  public void setData(T data) {
    this.data = data;
  }

  public String getMsg() {
    return msg;
  }

  public void setMsg(String msg) {
    this.msg = msg;
  }
}
