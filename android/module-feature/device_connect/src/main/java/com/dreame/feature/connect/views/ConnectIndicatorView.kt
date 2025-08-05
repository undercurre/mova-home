package com.dreame.feature.connect.views

import android.content.Context
import android.dreame.module.manager.LanguageManager
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import androidx.annotation.IntRange
import com.dreame.smartlife.connect.R

class ConnectIndicatorView : LinearLayout {

    private var tvIndex: TextView
    private var tvIndexIndex: TextView
    private var view1: View
    private var view2: View
    private var view3: View
    private var view4: View
    private var view5: View

    constructor(context: Context) : this(context, null, 0)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0)
    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) :
            super(context, attrs, defStyleAttr) {

        LayoutInflater.from(context).inflate(R.layout.layout_connect_indicator, this)

        tvIndex = findViewById(R.id.tv_index)
        tvIndexIndex = findViewById(R.id.tv_index_count)
        view1 = findViewById(R.id.view1)
        view2 = findViewById(R.id.view2)
        view3 = findViewById(R.id.view3)
        view4 = findViewById(R.id.view4)
        view5 = findViewById(R.id.view5)
    }


    fun setIndex(@IntRange(from = 1, to = 5) index: Int) {
        tvIndex.text = index.toString()
        view1.setBackgroundResource(if (index >= 1) R.drawable.shape_horizontal_indicator_start_enable else R.drawable.shape_horizontal_indicator_start_disable)
        view2.setBackgroundResource(if (index >= 2) R.color.common_brandAccent2 else R.color.common_Gray2)
        view3.setBackgroundResource(if (index >= 3) R.color.common_brandAccent2 else R.color.common_Gray2)
        view4.setBackgroundResource(if (index >= 4) R.color.common_brandAccent2 else R.color.common_Gray2)
        view5.setBackgroundResource(if (index >= 5) R.drawable.shape_horizontal_indicator_end_enable else R.drawable.shape_horizontal_indicator_end_disable)
    }
}