package android.dreame.module.util.okhttp3.convert;

import android.dreame.module.bean.OAuthBean;
import android.dreame.module.bean.OAuthBeanDetail;
import android.dreame.module.constant.Constants;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * @author: sunzhibin
 * @e-mail: sunzhibin@dreame.tech
 * @desc: 登录模块涉及到的code问题
 * @date: 2021/4/20 14:31
 * @version: 1.0
 */
public class LoginModuleErrorCode {

  public static final String INVALID_REQUEST = "invalid_request";
  public static final String INVALID_CLIENT = "invalid_client";
  public static final String INVALID_GRANT = "invalid_grant";
  public static final String UNAUTHORIZED_CLIENT = "unauthorized_client";
  public static final String UNSUPPORTED_GRANT_TYPE = "unsupported_grant_type";
  public static final String INVALID_SCOPE = "invalid_scope";
  public static final String INSUFFICIENT_SCOPE = "insufficient_scope";

  public static final String INVALID_TOKEN = "invalid_token";
  public static final String REDIRECT_URI_MISMATCH = "redirect_uri_mismatch";
  public static final String UNSUPPORTED_RESPONSE_TYPE = "unsupported_response_type";
  public static final String ACCESS_DENIED = "access_denied";

  public static final String INVALID_USER = "invalid_user";
  public static final String INVALID_PHONE = "invalid_phone";
  public static final String LIMIT_ATTEMPTS_UNAUTHORIZED = "limit_attempts_unauthorized";
  public static final String INVALID_VERIFICATION = "invalid_verification";
  public static final String EXCEED_MAX_ATTEMPTS = "exceed_max_attempts";

  public static final Map<String, Integer> sAuthor2CodeMap = new HashMap<>();

  static {
    sAuthor2CodeMap.put(INVALID_REQUEST, Constants.NET_ERROR);
    sAuthor2CodeMap.put(INVALID_CLIENT, Constants.NET_ERROR);
    sAuthor2CodeMap.put(INVALID_GRANT, Constants.NET_ERROR);
    sAuthor2CodeMap.put(UNAUTHORIZED_CLIENT, Constants.NET_ERROR);
    sAuthor2CodeMap.put(UNSUPPORTED_GRANT_TYPE, Constants.NET_ERROR);
    sAuthor2CodeMap.put(INVALID_SCOPE, Constants.NET_ERROR);
    sAuthor2CodeMap.put(INSUFFICIENT_SCOPE, Constants.NET_ERROR);
    sAuthor2CodeMap.put(REDIRECT_URI_MISMATCH, Constants.NET_ERROR);
    sAuthor2CodeMap.put(ACCESS_DENIED, Constants.NET_ERROR);
    sAuthor2CodeMap.put(UNSUPPORTED_RESPONSE_TYPE, Constants.NET_ERROR);
    // token invalid
    sAuthor2CodeMap.put(INVALID_TOKEN, 31001);

    // ----------------业务上 ----------------
    // 账号或密码错误，未授权
    sAuthor2CodeMap.put(INVALID_USER, 20100);
    sAuthor2CodeMap.put(LIMIT_ATTEMPTS_UNAUTHORIZED, 20101);
    // 验证码错误或过期
    sAuthor2CodeMap.put(INVALID_VERIFICATION, 11000);
    // 手机号未注册
    sAuthor2CodeMap.put(INVALID_PHONE, 20100);
    // 错误次数过多
    sAuthor2CodeMap.put(EXCEED_MAX_ATTEMPTS, 20102);
  }

  /**
   * 授权模块转换
   *
   * @param json errorBody
   * @return
   */
  public static OAuthBean convertResult(String json) {
    if (json == null || json.length() == 0) {
      return new OAuthBean(Constants.NET_ERROR, null);
    }
    JSONObject jsonObject = null;
    try {
      jsonObject = new JSONObject(json);
    } catch (JSONException e) {
      e.printStackTrace();
    }
    if (jsonObject == null) {
      return new OAuthBean(Constants.NET_ERROR, null);
    }
    String error = jsonObject.optString("error");
    String error_description = jsonObject.optString("error_description");
    String maxAttempts = jsonObject.optString("maxAttempts");
    String remains = jsonObject.optString("remains");

    Integer integer = sAuthor2CodeMap.get(error);
    if (integer == null) {
      return new OAuthBean(Constants.NET_ERROR, null);
    } else {
      OAuthBean oAuthBean = new OAuthBean(integer, error_description);
      OAuthBeanDetail detail = new OAuthBeanDetail();
      detail.setMaximum(maxAttempts);
      detail.setRemains(remains);
      oAuthBean.setDetail(detail);
      return oAuthBean;
    }

  }

}
