package android.dreame.module.event;

public class EventCode {
  public static final int REFRESH_LOCATION = 0x110;   //刷新地区
  public static final int REFRESH_LANGUAGE = 0x111;   //刷新语言
  public static final int REFRESH_USER_INFO = 0x112;  //刷新个人信息
  public static final int UPDATE_DEVICE_NAME = 0x113;  //修改设备名称
  public static final int ADD_DEVICE_SUCCESS = 0x114;  //添加设备成功
  public static final int REFRESH_USER_INFO_WITH_REQUEST = 0x115;//刷新个人信息-请求的方式
  public static final int UMENG_DEVICE_TOKEN = 0x116;//友盟device token获取成功
  public static final int REFRESH_DEVICE_MSG = 0x117;//刷新device消息
  public static final int DELETE_DEVICE_SUCCESS = 0x118;  //删除设备成功
  public static final int POP_ALL_FRAGMENT = 0x119; //关闭所有登录相关fragment
  public static final int ACCEPT_OR_REJECT_DEVICE = 0x120; // 接收/拒绝共享设备
  public static final int REFRESH_SHARE_MSG = 0x121;//刷新分享消息
  public static final int SHARE_OR_DELETE_DEVICE_SUCCESS = 0x122;//分享或取消分享成功
  public static final int WECHAT_LOGIN_AUTH_RESULT = 0x123;//微信登录授权返回

  public static final int UPDATE_DEVICE_STATE = 0x124;  //依据sendCommand更新设备状态
  public static final int REFRESH_FEEDBACK_LIST = 0x125;  //依据刷新意见反馈

  public static final int BIND_ALI_DEVICE = 0x126;//绑定阿里设备成功
  public static final int REFRESH_MALL_SESSION = 0x127;//刷新商城登录Session


  public static final int REFRESH_SYSTEM_MSG = 0x128;//刷新系统消息
  public static final int REFRESH_SERVICE_MSG = 0x129;//刷新服务消息

  public static final int REFRESH_USER_VIP_INFO = 0x130;  //刷新个人VIP信息

    public static final int APP_WIDGET_ADD_SUCCESS = 0x131;  //小组件添加成功

    public static final int PUSH_DEVICE_TOKEN_REFRESH = 0x132;  //推送token刷新事件，针对gms
}
