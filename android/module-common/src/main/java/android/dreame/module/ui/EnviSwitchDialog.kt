package android.dreame.module.ui

import android.content.Context
import android.content.Intent
import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.R
import android.dreame.module.constant.Constants
import android.dreame.module.manager.AccountManager
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.SPUtil
import android.os.Handler
import android.text.TextUtils
import android.view.Gravity
import android.widget.Button
import android.widget.ImageView
import android.widget.RadioGroup
import android.widget.Toast
import razerdp.basepopup.BasePopupWindow
import kotlin.system.exitProcess

class EnviSwitchDialog(val context: Context) : BasePopupWindow(context) {

    val URL_RELEASE = "https://cn.iot.mova-tech.com:13267"
    val URL_DEV = "http://cn-dev.iot.mova-tech.com:30080"
    val URL_UAT = "https://uat.cn.iot.mova-tech.com"
    val URL_PRE = "https://cn-pre.iot.mova-tech.com:13267"

    private var selectUrl: String = ""
    private var cacheUrl: String = ""

    init {
        popupGravity = Gravity.BOTTOM
        setContentView(R.layout.dialog_envi_switch)

        val url = SPUtil.get(
            LocalApplication.getInstance().applicationContext,
            Constants.NET_BASE_URL, ""
        ) as String
        cacheUrl = if (TextUtils.isEmpty(url)) {
            BuildConfig.API_BASE_URL
        } else {
            url
        }

        findViewById<Button>(R.id.btn_save).setOnClickListener {
            switchUrl()
        }
        findViewById<ImageView>(R.id.iv_close).setOnClickListener { dismiss() }
        findViewById<RadioGroup>(R.id.rg_envi).setOnCheckedChangeListener { group, checkedId ->
            when (checkedId) {
                R.id.rb_dev -> {
                    selectUrl = URL_DEV
                }

                R.id.rb_uat -> {
                    selectUrl = URL_UAT
                }

                R.id.rb_pre -> {
                    selectUrl = URL_PRE
                }

                R.id.rb_pro -> {
                    selectUrl = URL_RELEASE
                }
            }
        }
    }

    private fun switchUrl() {
        if (!TextUtils.isEmpty(selectUrl) && !TextUtils.equals(cacheUrl, selectUrl)) {
            AccountManager.getInstance().clear()
            SPUtil.put(context, Constants.NET_BASE_URL, selectUrl)
            Toast.makeText(context, "切换成功", Toast.LENGTH_SHORT).show()
            dismiss()
            Handler().postDelayed({
                exitProcess(0)
            }, 2000)
        }
    }

    private fun restartApp() {
        val intent =
            context.packageManager.getLaunchIntentForPackage(context.packageName)
        intent?.let {
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            context.startActivity(intent)
            ActivityUtil.getInstance().finishAllActivity()
        }
    }
}