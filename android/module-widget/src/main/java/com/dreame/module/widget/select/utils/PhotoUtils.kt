package com.dreame.module.widget.select.utils

import android.content.Context
import android.dreame.module.util.LogUtil
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import androidx.core.graphics.drawable.toBitmap
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DecodeFormat
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.RequestOptions
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.dreame.module.widget.service.utils.AppWidgetEnum
import com.dreame.smartlife.widget.R

internal object PhotoUtils {

    internal const val STATUS_GLIDE_START = 1
    internal const val STATUS_GLIDE_FAILED = 2
    internal const val STATUS_GLIDE_SUCCESS = 3
    fun loadBitmap(
        context: Context, url: String, appwidgetType: Int, block: (ret: Int, msg: String, bitmap: Bitmap?) -> Unit
    ) {
        when (appwidgetType) {
            AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE1.code, AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
            AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code -> {
                loadBitmap(context, url, 160, 100, block)
            }

            AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code -> {
                loadBitmap(context, url, 360, 80, block)

            }

            AppWidgetEnum.WIDGET_LARGE_SINGLE.code, AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> {
                loadBitmap(context, url, 360, 80, block)

            }

            else -> {
                loadBitmap(context, url, 360, 80, block)
            }
        }
    }

    private fun loadBitmap(
        context: Context, url: String, width: Int = 480,
        quality: Int = 100, block: (ret: Int, msg: String, bitmap: Bitmap?) -> Unit
    ) {
        Glide.with(context)
            .asBitmap()
            .placeholder(R.drawable.icon_robot_placeholder)
            .timeout(5 * 1000)
            .diskCacheStrategy(DiskCacheStrategy.DATA)
            .apply(
                RequestOptions()
                    .encodeFormat(Bitmap.CompressFormat.JPEG).format(DecodeFormat.PREFER_RGB_565)
                    .encodeQuality(quality)
                    .override(width)
            )
            .load(url)
            .into(object : CustomTarget<Bitmap?>() {
                override fun onLoadCleared(placeholder: Drawable?) {}
                override fun onLoadFailed(errorDrawable: Drawable?) {
                    block(
                        STATUS_GLIDE_FAILED,
                        "pic download error",
                        errorDrawable?.toBitmap() ?: BitmapFactory.decodeResource(context.resources, R.drawable.icon_robot_placeholder)
                    )
                }

                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap?>?) {
                    //设置缩略图
                    LogUtil.d("onResourceReady: ${resource.allocationByteCount} $url")
                    block(STATUS_GLIDE_SUCCESS, "", resource)
                }
            })
    }
}