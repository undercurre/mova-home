package android.dreame.module


import com.therouter.TheRouter

object RouteServiceProvider {

    @JvmStatic
    fun <T> getService(clazz: Class<T>): T? {
        try {
            return TheRouter.get(clazz)
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }

    inline fun <reified T> getService(): T? {
        try {
            return TheRouter.get(T::class.java)
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }
}