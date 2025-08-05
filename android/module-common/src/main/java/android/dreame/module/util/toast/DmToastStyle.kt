package android.dreame.module.util.toast

import android.content.Context
import android.graphics.drawable.Drawable
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import com.hjq.toast.config.IToastStyle

class DmToastStyle : IToastStyle<View> {

    private var mLayoutId = 0
    private var mGravity = 0
    private var mXOffset = 0
    private var mYOffset = 0
    private var mHorizontalMargin = 0f
    private var mVerticalMargin = 0f
    private var mDrawable: Drawable? = null


    constructor(id: Int, drawable: Drawable? = null) : this(id, Gravity.CENTER, drawable)

    constructor(id: Int, gravity: Int, drawable: Drawable?) : this(id, gravity, 0, 0, drawable)

    constructor(id: Int, gravity: Int, xOffset: Int, yOffset: Int, drawable: Drawable?) : this(
        id,
        gravity,
        xOffset,
        yOffset,
        0f,
        0f,
        drawable
    )

    constructor(
        id: Int,
        gravity: Int,
        xOffset: Int,
        yOffset: Int,
        horizontalMargin: Float,
        verticalMargin: Float,
        drawable: Drawable?,
    ) {
        mLayoutId = id
        mGravity = gravity
        mXOffset = xOffset
        mYOffset = yOffset
        mHorizontalMargin = horizontalMargin
        mVerticalMargin = verticalMargin
        mDrawable = drawable
    }

    override fun createView(context: Context?): View? {
        val view = LayoutInflater.from(context).inflate(this.mLayoutId, null)
        val ivIcon = view.findViewById<ImageView>(android.R.id.icon)
        if (mDrawable != null) {
            ivIcon.visibility = View.VISIBLE
            ivIcon.setImageDrawable(mDrawable)
        } else {
            ivIcon.visibility = View.GONE
        }
        return view
    }

    override fun getGravity(): Int {
        return mGravity
    }

    override fun getXOffset(): Int {
        return mXOffset
    }

    override fun getYOffset(): Int {
        return mYOffset
    }

    override fun getHorizontalMargin(): Float {
        return mHorizontalMargin
    }

    override fun getVerticalMargin(): Float {
        return mVerticalMargin
    }
}