package android.dreame.module.view
import android.content.Context;
import android.content.res.TypedArray;
import android.dreame.module.R;
import android.util.AttributeSet;
import android.view.WindowManager;
import android.widget.LinearLayout;

class MaxWidthLinearLayout @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : LinearLayout(context, attrs) {

    private var maxWidthPx = 0

    init {
        context.theme.obtainStyledAttributes(
            attrs,
            R.styleable.MaxWidthLinearLayout,
            0, 0
        ).apply {
            try {
                maxWidthPx = getDimensionPixelSize(R.styleable.MaxWidthLinearLayout_maxWidth, 0)
            } finally {
                recycle()
            }
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        var modifiedWidthSpec = widthMeasureSpec
        if (maxWidthPx > 0) {
            val size = MeasureSpec.getSize(widthMeasureSpec)
            if (size > maxWidthPx) {
                modifiedWidthSpec = MeasureSpec.makeMeasureSpec(maxWidthPx, MeasureSpec.getMode(widthMeasureSpec))
            }
        }
        super.onMeasure(modifiedWidthSpec, heightMeasureSpec)
    }
}
