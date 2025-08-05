package android.dreame.module.util

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

object ThrottleUtils {
    fun <T> throttleLatest(
        intervalMs: Long = 200L,
        coroutineScope: CoroutineScope,
        destinationFunction: suspend (T) -> Unit
    ): (T) -> Unit {
        var throttleJob: Job? = null
        var latestParam: T
        val function = { param: T ->
            latestParam = param
            if (throttleJob?.isCompleted != false) {
                throttleJob = coroutineScope.launch {
                    delay(intervalMs)
                    destinationFunction(latestParam)
                }
            }
        }
        return function
    }

    fun <T> throttleFirst(
        intervalMs: Long = 300L,
        coroutineScope: CoroutineScope,
        destinationFunction: suspend (T) -> Unit
    ): (T) -> Unit {
        var throttleJob: Job? = null
        return { param: T ->
            if (throttleJob?.isCompleted != false) {
                throttleJob = coroutineScope.launch {
                    destinationFunction(param)
                    delay(intervalMs)
                }
            }
        }
    }

    fun <T> debounce(
        waitMs: Long = 50L,
        coroutineScope: CoroutineScope,
        destinationFunction: suspend (T) -> Unit
    ): (T) -> Unit {
        var debounceJob: Job? = null
        return { param: T ->
            debounceJob?.cancel()
            debounceJob = coroutineScope.launch {
                delay(waitMs)
                destinationFunction(param)
            }
        }
    }


}