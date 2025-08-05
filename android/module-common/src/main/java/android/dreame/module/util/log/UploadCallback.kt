package android.dreame.module.util.log

interface UploadCallback {
    fun onCompleted(code: Int, msg: String?)
}