package android.dreame.module.trace

/**
 * 埋点定义：
 * https://dreametech.feishu.cn/sheets/YEfos7BKzhM1KCtM5J6cLcN5n5c?sheet=28db1e&range=MjE4OjIxOA%3D%3D
 * 配网页面定义
 * https://wiki.dreame.tech/pages/viewpage.action?pageId=109440390
 * 配网埋点需求
 * https://dreametech.feishu.cn/docx/Gxuld1sHBoUzt6xu8P2cbNBFn0c
 *
 */
enum class ModuleCode(val code: Int) {
    // 同意隐私
    Privacy(0),

    // 开屏
    Splash(1),

    // 注册
    SignOn(2),

    // 登录
    Login(3),

    // 重置密码
    ResetPassword(4),

    // 我的设备
    HomeDevice(5),

    // 消息
    Message(6),

    // 我的
    Mine(7),

    // 配网
    PairNet(8),

    // 日活
    DailyActive(9),

    // 手机系统
    PhoneInfo(10),

    // app版本
    AppInfo(11),

    // 页面停留时间
    PageActive(12),

    // 阿里设备绑定
    AliBind(13),

    // 小组件
    AppWidget(14),

    // 配网新
    PairNetNew(15),


    // 异常统计
    ExceptionStatistics(100),

    // app事件埋点
    AppEvent(101),

    // 插件事件埋点
    PluginEvent(102),

    //
    OtherStatistics(200),

    ;
}
