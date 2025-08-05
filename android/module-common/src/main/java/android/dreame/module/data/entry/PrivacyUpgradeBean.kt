package android.dreame.module.data.entry

/**
 * @property version 版本号
 * @property model 通过model，type，tag，lang从富文本接口点击调用跳转
 * @property type  版本id_版本号_类型（用户协议1 隐私政策2）1：用户协议 2：隐私政策
 * @property tag  XXXXXX_1_1   XXXXXX_1_2 通过主键id，verion，type组合
 * @property changelog 更新日志
 * @property lang 富文本配置的语言（中国大陆地区：默认中文，可切换英语 海外地区：默认英语，可切换其他小语种）
 * @property langs 支持的语言
 * @property url 前端协议url拼参数
 *
 */
data class PrivacyListBean(
    val version: Int, val model: String, val type: String, val tag: String,
    val changelog: String, val lang: String, val langs: List<String>, var url: String
)

data class PrivacyUpgradeBean(
    val privacyList: List<PrivacyListBean>,
)

