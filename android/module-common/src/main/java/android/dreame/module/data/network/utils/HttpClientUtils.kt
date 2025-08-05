package android.dreame.module.data.network.utils

import android.dreame.module.BuildConfig
import okhttp3.CipherSuite
import okhttp3.ConnectionSpec
import okhttp3.TlsVersion
import java.util.Collections

object HttpClientUtils {

    val connectionSpecs: List<ConnectionSpec> =
        if (BuildConfig.BUILD_TYPE.equals("debug")) {
            listOf(ConnectionSpec.MODERN_TLS, ConnectionSpec.CLEARTEXT)
        } else {
            Collections.singletonList(
                ConnectionSpec.Builder(ConnectionSpec.MODERN_TLS)
                    .tlsVersions(TlsVersion.TLS_1_2)
                    .cipherSuites(CipherSuite.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256)
                    .build()
            )
        }

}