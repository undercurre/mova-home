package android.dreame.module.exception

import java.lang.Exception

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/29
 *     desc   :
 *     version: 1.0
 * </pre>
 */
open class DreameException(val code: Int, msg: String?) : Exception(msg)