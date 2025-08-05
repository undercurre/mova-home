package android.dreame.module.data.network.utils

import okhttp3.Dns
import java.net.InetAddress

/**
 * 阿里DNS解析服务
 */
object AliHttpDns : Dns {

    override fun lookup(hostname: String): List<InetAddress> {
        return Dns.SYSTEM.lookup(hostname)
    }
}