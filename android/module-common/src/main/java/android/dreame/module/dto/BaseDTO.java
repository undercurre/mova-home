package android.dreame.module.dto;

import android.dreame.module.util.RequestParamsUtil;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import java.io.Serializable;

import okhttp3.MediaType;
import okhttp3.RequestBody;

public class BaseDTO implements Serializable {

  @NonNull
  @Override
  public String toString() {
    return super.toString();
  }

  public RequestBody getBody() {
    return RequestBody.create(MediaType.parse("application/json"),
      RequestParamsUtil.signParams(new Gson().toJson(this))
    );
  }
}
