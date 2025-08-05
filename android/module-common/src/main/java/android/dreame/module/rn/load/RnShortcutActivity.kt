package android.mova.module.rn.load

import android.content.Intent
import android.dreame.module.R
import android.net.Uri
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

/**
 * <pre>
 * author : admin
 * e-mail : wufei1@dreame.tech
 * time   : 2022/05/09
 * desc   :
 * version: 1.0
</pre> *
 */
open class RnShortcutActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val schemeUri = intent.getStringExtra("schemeUri")
        if (!schemeUri.isNullOrEmpty()) {
            val i = Intent()
            i.`package` = this.packageName
            i.action = Intent.ACTION_VIEW
            i.data = Uri.parse(schemeUri)
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(i)
        }
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out)
        finish()
    }
}