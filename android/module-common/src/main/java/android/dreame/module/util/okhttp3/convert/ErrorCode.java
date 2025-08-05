package android.dreame.module.util.okhttp3.convert;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: <p>参看文档 <ref="http://wiki.dreame.com/pages/viewpage.action?pageId=25626205"/></p>
 * @Date: 2021/4/22 13:11
 * @Version: 1.0
 */
public class ErrorCode {

  //全局 Http Status Code = 200
  public static final int CODE_BUSINESS = 10000;//; //业务异常"),

  // http
  public static final int CODE_HTTP_BODY_ERROR = 10001; //body 错误"),
  public static final int CODE_HTTP_METHOD_ERROR = 10002; //Http Method 不支持"),
  public static final int CODE_HTTP_CONTENT_TYPE_ERROR = 10003; //ContentType 不支持"),
  public static final int CODE_HTTP_OTHER_ERROR = 10004; //http预留"),

  //  参数 Http Status Code = 200
  public static final int CODE_PARAM_LESS_ERROR = 10005; //缺少必要的请求参数"),
  public static final int CODE_PARAM_TYPE_ERROR = 10006; //参数类型错误"),
  public static final int CODE_PARAM_BIND_ERROR = 10007; //参数绑定错误"),
  public static final int CODE_PARAM_CHECK_ERROR = 10008; //参数校验失败"),
  public static final int CODE_PARAM_OTHER_ERROR = 10009; //参数预留"),

  // 租户 Http Status Code = 200
  public static final int CODE_TENANT_LESS_ERROR = 10010; //没提供租户参数"),
  public static final int CODE_TENANT_NOT_EXIST_ERROR = 10011; //提供的租户不存在"),
  public static final int CODE_TENANT_NO_PERMISSION_ERROR = 10012; //租户无权限"),

  public static final int CODE_HTTP_BAND_ERROR = 10013; //IP禁用"),

  // 验签

  public static final int CODE_SIGN_TIMESTAMP_ERROR = 10120; //验签时间戳过期"),
  public static final int CODE_SIGN_NOT_PASS_ERROR = 10121; //验签未通过"),

  // 服务器error

  public static final int CODE_SERVER_ERROR = 10500; //服务器异常"),

  // 验证码

  public static final int CODE_VERIFY_INVALID_ERROR = 11000; //验证码无效或过期"),
  public static final int CODE_VERIFY_ERROR = 11001; //验证码错误"),
  public static final int CODE_VERIFY_SEND_ERROR = 11002; //验证码发送失败"),
  public static final int CODE_VERIFY_SEND_OFTEN_ERROR = 11003; //验证码发送太频繁"),
  public static final int CODE_VERIFY_SEND_OFTEN_2H_ERROR = 11004; //验证码短期发送次数太多"),
  public static final int CODE_VERIFY_NO_VERIFY_ERROR = 11005; //验证码未验证"),

  //授权

  //  用户
    //注册
  public static final int CODE_USER_REG_PHONE_REGISTERED_ERROR = 30900; //手机已注册"),
  public static final int CODE_USER_REG_EMAIL_REGISTERED_ERROR = 30901; //邮箱已注册"),

  public static final int CODE_PHONE_NOT_EXIST = 30400; //手机未注册"),
  public static final int CODE_EMAIL_NOT_EXIST = 30401; //邮箱未注册"),
  public static final int CODE_USER_NOT_EXIST = 30410; //用户不存在"),

  public static final int CODE_CHANGE_PHONE_REGISTERED_ERROR = 30910; //修改的手机已注册"),
  public static final int CODE_CHANGE_EMAIL_REGISTERED_ERROR = 30911; //修改的邮箱已注册"),
  public static final int CODE_CHANGE_PHONE_ORIGIN_ERROR = 30912; //不能修改为原手机"),
  public static final int CODE_CHANGE_EMAIL_ORIGIN_ERROR = 30913; //不能修改为原邮箱"),
  public static final int CODE_UNBIND_EMAIL_PASSWORD_ERROR = 30914; //解绑邮箱密码不匹配"),

  public static final int CODE_UNBIND_EMAIL_PHONE_ERROR = 30915; //不允许解绑手机/邮箱"),
  public static final int CODE_PASSWORD_ORIGIN_ERROR = 30916; //原密码错误"),
  public static final int CODE_PASSWORD_ERROR_OFTEN_ERROR = 30917; //密码验证错误次数过多"),
  public static final int CODE_PASSWORD_UNCHANGED_ERROR = 30918; //新密码和老密码相同"),
  public static final int CODE_USER_INVALID_ERROR = 30920; //无效的最近联系人"),

  //  用户设备管理

  public static final int CODE_DEVICE_SHARE_OVER_ERROR = 40010; //设备分享次数超限"),
  public static final int CODE_DEVICE_SHARE_DATA_ERROR = 40020; //数据错误"),
  public static final int CODE_DEVICE_SHARE_UNCONFIRMED_ERROR = 40030; //设备已经分享,待对方确认"),
  public static final int CODE_DEVICE_SHARE_SHARED_ERROR = 40031; //对方已确认分享"),
  public static final int CODE_DEVICE_SHARE_NO_YOURS_ERROR = 40032; //非设备主人，不能分享"),
  public static final int CODE_DEVICE_SHARE_TO_YOU_ERROR = 40033; //不能分享给自己"),
  public static final int CODE_DEVICE_NO_DEVICES_ERROR = 40040; //没有该设备"),
  public static final int CODE_DEVICE_NO_USER_ERROR = 40050; //用户不存在"),
  public static final int CODE_DEVICE_SHARE_CANCELED_ERROR = 40060; //设备已取消分享"),

  // 产品
  public static final int CODE_DEVICE_INFO_NO_EXIST_ERROR = 50400	; //产品不存在"),
  public static final int CODE_DEVICE_GUIDE_NO_EXIST_ERROR = 50410; //配网引导不存在"),
  // 消息
  public static final int CODE_MESSAGE_SHARE_UNANSWERABLE_ERROR = 60000; //分享消息不可被答复"),
  public static final int CODE_MESSAGE_SHARE_NO_EXIST_ERROR = 60400; //分享消息不存在"),
  public static final int CODE_MESSAGE_SHARE_FAILED_ERROR = 60900; //分享已失效"),
  public static final int CODE_MESSAGE_SHARE_ANSWERED_ERROR = 60901; //分享消息已经被答复"),

  public static final int CODE_NAME_SENSITIVE_WORDS = 30000; //含有敏感词"),


  public static final int CODE_BIND_OTHER_ACCOUNT = 30513; //第三方用户已绑定账号xxx "),


    public static final int CODE_PRODUCT_MODEL_NOT_EXIST = 40041; //该型号不存在 "),
    public static final int CODE_PRODUCT_MODE_NOT_SUPPORT = 40042; //该型号不支持配网模式 "),
    public static final int CODE_PRODUCT_MODEL_ILLEGAL = 40043; //非法设备 "),
    public static final int CODE_PRODUCT_SIGN_ERROR = 40044; //参数签名错误 "),
    public static final int CODE_PRODUCT_HAS_OWNER = 40045; //设备已有主人，不可配网 "),


}
