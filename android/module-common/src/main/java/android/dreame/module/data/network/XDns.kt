package android.dreame.module.data.network

import okhttp3.Dns
import java.lang.Exception
import java.net.InetAddress
import java.net.UnknownHostException
import java.util.*
import java.util.concurrent.FutureTask
import java.util.concurrent.TimeUnit

/**
 * dns解析
 */
class XDns(private val timeout: Long) : Dns {
    @Throws(UnknownHostException::class)
    override fun lookup(hostname: String): List<InetAddress> {
        return runCatching {
            val task = FutureTask { listOf(*InetAddress.getAllByName(hostname)) }
            Thread(task).start()
            task[timeout, TimeUnit.MILLISECONDS]
        }.onFailure {
            val unknownHostException = UnknownHostException("Broken system behaviour for dns lookup of $hostname")
            unknownHostException.initCause(it)
            throw unknownHostException
        }.getOrThrow()
    }
}