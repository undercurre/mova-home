package com.dreame.smartlife.device

import com.blankj.utilcode.util.TimeUtils
import java.text.SimpleDateFormat
import java.util.*

object DateFormatTimeUtil {
    @JvmStatic
    fun dateFormatFromGMT(dateTime: String?, isHomePage: Boolean = false): String {
        return if (dateTime.isNullOrEmpty()) {
            ""
        } else {
            val fromFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
            fromFormat.timeZone = TimeZone.getTimeZone("GMT")
            val date: Date = TimeUtils.string2Date(dateTime, fromFormat) ?: return ""
            val fromCalendar = Calendar.getInstance()
            fromCalendar.time = date

            val localCalendar = Calendar.getInstance()
            if (TimeUtils.isToday(date)) {
                val hhmmFormat = SimpleDateFormat("HH:mm")
                hhmmFormat.timeZone = localCalendar.timeZone
                return hhmmFormat.format(date)
            } else {
                val localYear = localCalendar.get(Calendar.YEAR)
                val fromYear = fromCalendar.get(Calendar.YEAR)

                return if (localYear == fromYear) {
                    val format =
                        if (isHomePage) SimpleDateFormat("MM/dd") else SimpleDateFormat("MM/dd HH:mm")
                    format.timeZone = localCalendar.timeZone
                    return format.format(date)
                } else {
                    val format =
                        if (isHomePage) SimpleDateFormat("yyyy/M/dd") else SimpleDateFormat("yyyy/M/dd HH:mm")
                    format.timeZone = localCalendar.timeZone
                    return format.format(date)
                }
            }
        }
    }
}