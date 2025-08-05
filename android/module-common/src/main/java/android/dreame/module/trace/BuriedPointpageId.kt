package android.dreame.module.trace

/**
 * 埋点定义：
 * https://dreametech.feishu.cn/sheets/YEfos7BKzhM1KCtM5J6cLcN5n5c?sheet=28db1e&range=MjE4OjIxOA%3D%3D
 * 配网页面定义
 * https://wiki.dreame.tech/pages/viewpage.action?pageId=109440390
 * 配网埋点需求
 * [https://dreametech.feishu.cn/docx/Gxuld1sHBoUzt6xu8P2cbNBFn0c]
 *
 */
enum class PairNetPageId(val code: String) {
    // 二维码扫码页
    QRScanPage("QRScanPage"),

    // 产品列表页
    ProductListPage("ProductListPage"),

    // 连接路由器页面
    ConnectRoutePage("ConnectRoutePage"),

    // 未连接Wi-Fi页面
    UnConnectWifiPage("UnConnectWifiPage"),

    // 开启设备
    TurnOnDevicePage("TurnOnDevicePage"),

    // 释放热点页
    TriggerWifiApPage("TriggerWifiApPage"),

    // 扫描设备页
    ScanDevicePage("ScanDevicePage"),

    // 手动连接设备热点页
    ManualConnectPage("ManualConnectPage"),

    // 配网连接页
    PairDeviceProcessPage("PairDeviceProcessPage"),

    // 查看配网失败原因页
    ViewPairDeviceFailedPage("ViewPairDeviceFailedPage"),

    // 连接指引页
    ConnectGuidePage("ConnectGuidePage"),

    // 扫码配网加入热点引导页
    QRConnectGuidePage("QRConnectGuidePage"),

    // 配网码页面
    GenerateQRPage("GenerateQRPage"),
    ;
}




