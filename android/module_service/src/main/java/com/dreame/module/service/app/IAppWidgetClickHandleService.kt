package com.dreame.module.service.app

import android.content.Context
import android.content.Intent


interface IAppWidgetClickHandleService  {

 

    fun handleAppWidgetClickEvent(context: Context, intent: Intent)
}