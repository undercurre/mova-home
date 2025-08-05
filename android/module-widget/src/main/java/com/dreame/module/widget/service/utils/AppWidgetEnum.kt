package com.dreame.module.widget.service.utils

/**
 * 小组件类型
 */
enum class AppWidgetEnum(val code: Int) {
    // 2*2 单功能
    WIDGET_SMALL_SINGLE(1),

    // 2*2 多功能  支持快捷指令
    WIDGET_SMALL_MULTIFUNCTION(2),

    // 4*2 单功能
    WIDGET_MIDDLE_SINGLE(3),

    // 4*2 多功能  支持快捷指令
    WIDGET_MIDDLE_MULTIFUNCTION(4),

    // 4*4 单功能
    WIDGET_LARGE_SINGLE(5),

    // 4*4 多功能 支持快捷指令
    WIDGET_LARGE_MULTIFUNCTION(6),

    // 2*2 单功能
    WIDGET_SMALL_SINGLE1(7),

    WIDGET_SMALL_SINGLE2(8), ;

    fun getAppWidgetEnum(code: Int): AppWidgetEnum? {
        return when (code) {
            1 -> WIDGET_SMALL_SINGLE
            2 -> WIDGET_SMALL_MULTIFUNCTION
            3 -> WIDGET_MIDDLE_SINGLE
            4 -> WIDGET_MIDDLE_MULTIFUNCTION
            5 -> WIDGET_LARGE_SINGLE
            6 -> WIDGET_LARGE_MULTIFUNCTION
            7 -> WIDGET_SMALL_SINGLE1
            8 -> WIDGET_SMALL_SINGLE2
            else -> null
        }
    }
}