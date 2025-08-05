package android.dreame.module.view

import android.content.Context
import android.dreame.module.R
import android.dreame.module.databinding.LayoutCommonTitleViewBinding
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.ScreenUtils
import android.util.AttributeSet
import android.view.View
import android.widget.ImageView
import androidx.annotation.ColorRes
import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible

/**
 * 通用标题栏控件
 * titlePosition为TitlePosition.CENTER时会默认展示投影，此时背景强制为白色
 * 不需要投影使用showShadow(Boolean)进行设置
 */
class CommonTitleView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
) : ConstraintLayout(context, attrs) {

    private var titleTextSize: Float = 28f
    private val rightResId: Int
    private val rightText: String?
    private val showRightIcon: Boolean
    private val showRightText: Boolean
    private val marginStart: Int
    private val rightTextColor: Int

    private var titlePosition = TitlePosition.CENTER
    private val titlePositionsArray = arrayOf(
        TitlePosition.NONE, TitlePosition.CENTER, TitlePosition.BOTTOM
    )
    private var onButtonClickListener: OnButtonClickListener? = null
    private val binding: LayoutCommonTitleViewBinding

    init {
        val rootView = inflate(context, R.layout.layout_common_title_view, this)
        binding = LayoutCommonTitleViewBinding.bind(rootView)

        val ta = context.obtainStyledAttributes(attrs, R.styleable.CommonTitleView)
        rightResId = ta.getResourceId(R.styleable.CommonTitleView_rightIcon, R.drawable.ic_ok)
        val title = ta.getString(R.styleable.CommonTitleView_title)
        val subtitle = ta.getString(R.styleable.CommonTitleView_subtitle)
        rightText = ta.getString(R.styleable.CommonTitleView_rightText)
        showRightIcon = ta.getBoolean(R.styleable.CommonTitleView_showRightImage, false)
        showRightText = ta.getBoolean(R.styleable.CommonTitleView_showRightText, false)
        val showCenterSubtitle = ta.getBoolean(R.styleable.CommonTitleView_showCenterSubtitle, false)
        val useStatusBar = ta.getBoolean(R.styleable.CommonTitleView_useStatusBar, true)

        marginStart = ta.getDimensionPixelSize(
            R.styleable.CommonTitleView_titleMarginStart,
            ScreenUtils.dp2px(context, 20f)
        )
        val titleShowIndex = ta.getInt(R.styleable.CommonTitleView_titleShowPosition, -1)
        rightTextColor = ta.getColor(
            R.styleable.CommonTitleView_rightTextColor,
            ContextCompat.getColor(context, R.color.common_textMain)
        )
        ta.recycle()

        if (titleShowIndex >= 0) {
            setTitlePosition(titlePositionsArray[titleShowIndex])
        } else {
            setTitlePosition()
        }
        setTitle(title)
        setSubtitle(subtitle)
        showSubtitle(showCenterSubtitle)
        binding.tvRight.apply {
            text = rightText
            visibility = if (showRightText) VISIBLE else GONE
            setOnShakeProofClickListener { onButtonClickListener?.onRightTextClick() }
            setTextColor(rightTextColor)
        }
        binding.ivRight.apply {
            setImageResource(rightResId)
            visibility = if (showRightIcon) VISIBLE else GONE
            setOnShakeProofClickListener { onButtonClickListener?.onRightIconClick() }
        }
        binding.viewStatusBar.visibility = if (useStatusBar) VISIBLE else GONE
        binding.ivLeft.setOnShakeProofClickListener { onButtonClickListener?.onLeftIconClick() }


        // title
        if (!showRightText) {
            val params = binding.tvCenterTitle.layoutParams as LayoutParams
            params.marginStart = ScreenUtils.dp2px(context, 45f)
            params.marginEnd = params.marginStart
            binding.tvCenterTitle.layoutParams = params
        }

        if (background != null) {
            binding.clRoot.background = background
            binding.clCenterTitle.background = background
        }
    }

    /**
     * 设置标题展示样式
     */
    fun setTitlePosition(titlePosition: TitlePosition) {
        this.titlePosition = titlePosition
        setTitlePosition()
    }

    private fun setTitlePosition() {
        when (titlePosition) {
            TitlePosition.CENTER -> {
                binding.tvCenterTitle.visibility = VISIBLE
//                setTitleBackgroundColor(R.color.common_layoutBg)
            }

            TitlePosition.BOTTOM -> {
                binding.tvCenterTitle.visibility = GONE
            }

            TitlePosition.NONE -> {
                binding.tvCenterTitle.visibility = GONE
            }
        }
    }

    /**
     * 设置背景颜色
     * TitlePosition.CENTER生效
     */
    fun setTitleBackgroundColor(@ColorRes titleBackgroundColor: Int) {
        binding.clCenterTitle.setBackgroundColor(
            ContextCompat.getColor(
                context,
                titleBackgroundColor
            )
        )
    }

    /**
     * 设置标题String
     */
    fun setTitle(title: String?) {
        binding.tvCenterTitle.text = title
    }

    /**
     * 设置副标题String
     */
    fun setSubtitle(subtitle: String?) {
        binding.tvCenterSubtitle.text = subtitle
    }

    /**
     * 设置副标题String
     */
    fun showSubtitle(show: Boolean) {
        binding.tvCenterSubtitle.visibility = if (show) View.VISIBLE else View.GONE
    }

    /**
     * 设置标题StringResId
     */
    fun setTitle(@StringRes titleRes: Int) {
        setTitle(context.getString(titleRes))
    }

    fun setTitleTextSize(textSize: Float) {
        titleTextSize = textSize;
        binding.tvCenterTitle.textSize = textSize
    }

    /**
     * 设置右边文字
     */
    fun setRightText(rightText: String?) {
        binding.tvRight.text = rightText
    }

    /**
     * 设置左图标
     */
    fun setLeftIcon(@DrawableRes leftIconRes: Int): CommonTitleView {
        binding.ivLeft.setImageResource(leftIconRes)
        return this
    }

    /**
     * 设置右边图标
     */
    fun setRightIcon(@DrawableRes rightResId: Int): CommonTitleView {
        binding.ivRight.setImageResource(rightResId)
        return this
    }

    fun getRightView(): View {
        return if (binding.ivRight.isVisible) binding.ivRight else binding.tvRight
    }

    fun getRightIconView(): ImageView {
        return binding.ivRight
    }

    fun setOnButtonClickListener(onButtonClickListener: OnButtonClickListener?) {
        this.onButtonClickListener = onButtonClickListener
    }

    interface OnButtonClickListener {
        fun onLeftIconClick()
        fun onRightIconClick()
        fun onRightTextClick()
    }

    open class SimpleButtonClickListener : OnButtonClickListener {
        override fun onLeftIconClick() {}
        override fun onRightIconClick() {}
        override fun onRightTextClick() {}
    }

    enum class TitlePosition(val nativeInt: Int) {
        NONE(0), CENTER(1), BOTTOM(2);
    }

}