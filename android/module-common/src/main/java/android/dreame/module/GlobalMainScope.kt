package android.dreame.module

import android.os.Handler
import android.os.Looper
import kotlinx.coroutines.*
import java.util.concurrent.Executors
import java.util.concurrent.ThreadFactory
import kotlin.coroutines.CoroutineContext


val globalMainHandler by lazy { Handler(Looper.getMainLooper()) }


object GlobalMainScope {
    private val mainScope = MainScope()

    private val executor = Executors.newSingleThreadExecutor(threadFactory("sql-executor", false))
    val SQL = executor.asCoroutineDispatcher()

    fun launch(
        context: CoroutineContext = Dispatchers.Main,
        start: CoroutineStart = CoroutineStart.DEFAULT,
        block: suspend CoroutineScope.() -> Unit
    ): Job {
        return mainScope.launch(context, start, block)
    }

    suspend inline fun runMain(crossinline block: suspend CoroutineScope.() -> Unit) = withContext(Dispatchers.Main) {
        block()
    }

    suspend inline fun runSql(crossinline block: suspend CoroutineScope.() -> Unit) = withContext(SQL) {
        block()
    }

   private fun threadFactory(
        name: String,
        daemon: Boolean
    ): ThreadFactory = ThreadFactory { runnable ->
        Thread(runnable, name).apply {
            isDaemon = daemon
        }
    }
}

