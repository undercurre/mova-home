package android.dreame.module.util

object HostFixUtils {
    val PRIVACY_PREFIX = "app-privacy-"

    /// FIXME: 这是一个兼容逻辑，不应该在这里处理
    /// FIXME: 这是一个兼容逻辑，不应该在这里处理
    fun hostFix(host: String): String {
        if (host.isEmpty()) return host;

        // 找到域名开始的位置（在 :// 之后）
        val domainStartIndex = host.indexOf("://") + 3
        if (domainStartIndex < 3) return host; // 如果没有找到 ://，返回原URL
        // 在域名前插入 'app-privacy-'
        return (host.substring(0, domainStartIndex) +
                PRIVACY_PREFIX +
                host.substring(domainStartIndex)).replace(":8080", "")

    }
}
