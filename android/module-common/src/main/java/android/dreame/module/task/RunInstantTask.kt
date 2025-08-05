package android.dreame.module.task

import android.dreame.module.BuildConfig
import android.os.Process
import android.os.SystemClock
import android.util.Log
import com.blankj.utilcode.util.ThreadUtils

abstract class RunInstantTask(val id: String, val isAsyncTask: Boolean) : ThreadUtils.Task<Int>(), IRunInstant {

    protected open fun run(name: String) {

    }

    override fun runInstant() {
        val elapsedRealtime = SystemClock.elapsedRealtime()
        run(id)
        if (BuildConfig.DEBUG) {
            Log.d("RunInstantTask", "task: $id  启动耗时: ${SystemClock.elapsedRealtime() - elapsedRealtime}  pid: ${Process.myPid()}")
        }
    }

    override fun doInBackground(): Int {
        calculateTimeSpace("$id before running") {
            callback?.doInBackgroundBefore()
        }
        calculateTimeSpace("$id running") {
            run(id)
        }
        calculateTimeSpace("$id behind running") {
            callback?.doInBackgroundBehind()
        }
        return 0
    }

    override fun onSuccess(result: Int?) {
        callback?.onSuccess(result)
    }

    override fun onCancel() {
        callback?.onCancel()
    }

    override fun onFail(t: Throwable?) {
        callback?.onFail(t)
    }

    var callback: TaskCallback? = null
}

interface TaskCallback {
    fun doInBackgroundBefore() {

    }

    fun doInBackgroundBehind() {

    }

    fun onSuccess(result: Int?) {

    }

    fun onCancel() {
    }

    fun onFail(t: Throwable?) {
    }
}


fun RunInstantTask.onSuccess(block: () -> Unit) {
    this.callback = object : TaskCallback {
        override fun onSuccess(result: Int?) {
            block()
        }
    }
}

fun RunInstantTask.insertBefore(block: () -> Unit) {
    this.callback = object : TaskCallback {
        override fun doInBackgroundBefore() {
            block()
        }
    }
}

fun RunInstantTask.insertBehind(block: () -> Unit) {
    this.callback = object : TaskCallback {
        override fun doInBackgroundBehind() {
            block()
        }
    }
}

/**
 * 计算方法耗时
 */
private fun calculateTimeSpace(name: String, block: () -> Unit) {
    val elapsedRealtime = SystemClock.elapsedRealtime()
    block()
    if (BuildConfig.DEBUG) {
        Log.d("RunInstantTask", "task: $name  启动耗时: ${SystemClock.elapsedRealtime() - elapsedRealtime}  pid: ${Process.myPid()}")
    }
}