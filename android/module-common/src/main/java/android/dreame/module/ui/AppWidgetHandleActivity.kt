package android.dreame.module.ui

import android.content.Intent
import android.dreame.module.RouteServiceProvider
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.dreame.module.service.app.IAppWidgetClickHandleService


class AppWidgetHandleActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleAppWidgetClickEvent()
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        handleAppWidgetClickEvent()
    }


    private fun handleAppWidgetClickEvent() {
        intent?.let {
            RouteServiceProvider.getService<IAppWidgetClickHandleService>()?.handleAppWidgetClickEvent(this, it)
        }
        finish()
    }
}
