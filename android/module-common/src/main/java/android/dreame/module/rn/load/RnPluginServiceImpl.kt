package android.dreame.module.rn.load

import android.content.Context
import android.dreame.module.RoutPath
import com.therouter.router.Route
import com.dreame.module.service.reactnative.RnPluginService

@Route(path = RoutPath.REACT_NATIVE_SERVICE)
class RnPluginServiceImpl : RnPluginService {

    override fun clearAllRnCache() {
        RnCacheManager.clearAllCache()
    }

    override fun clearRnCacheByDid(did: String) {
        RnCacheManager.clearCacheByDid(did)
    }


}

@com.therouter.inject.ServiceProvider
fun rnPluginServiceProvider(): RnPluginService = RnPluginServiceImpl()