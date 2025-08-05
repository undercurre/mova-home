package com.dreame.smartlife.widget

import android.content.Context
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.ScreenUtils
import android.util.AttributeSet
import android.view.View
import androidx.annotation.DrawableRes
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import com.dreame.smartlife.R
import com.dreame.smartlife.databinding.ViewMineItemBinding

/**
 * 绑定账号的item
 */
class MineItemView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : ConstraintLayout(context, attrs) {

    private val binding: ViewMineItemBinding

    fun setContent(content: String?) {
        binding.tvContent.text = content
    }

    fun setTitle(title: String?) {
        binding.tvTitle.text = title
    }

    fun setContentClickListener(block: () -> Unit) {
        binding.tvContent.setOnShakeProofClickListener {
            block()
        }
    }

    fun setClickListener(block: () -> Unit) {
        binding.tvContent.setOnClickListener {
            block()
        }
    }

    fun showRightArrowClickListener(block: () -> Unit) {
        binding.ivRight.setOnShakeProofClickListener {
            block()
        }
    }

    fun setBindAccount(
        wechat: Boolean,
        facebook: Boolean,
        google: Boolean,
        appleId: Boolean = false
    ) {
        binding.ivWechat.visibility = if (wechat) View.VISIBLE else View.GONE
        binding.ivFacebook.visibility = if (facebook) View.VISIBLE else View.GONE
        binding.ivGoogle.visibility = if (google) View.VISIBLE else View.GONE
        binding.ivApple.visibility = if (appleId) View.VISIBLE else View.GONE

        // 有绑定则隐藏
        binding.tvContent.visibility =
            if (wechat || facebook || google || appleId) View.GONE else View.VISIBLE
    }

    init {
        val typedArray = context.obtainStyledAttributes(attrs, R.styleable.MineItemView)
        val titleResId =
            typedArray.getResourceId(R.styleable.MineItemView_mineItemImage, R.mipmap.ic_launcher)
        val arrowImageResId = typedArray.getResourceId(R.styleable.MineItemView_mineItemShowArrowImage, R.drawable.icon_arrow_right)
        val titleText = typedArray.getString(R.styleable.MineItemView_mineItemTitle)
        val isShowRightArrow =
            typedArray.getBoolean(R.styleable.MineItemView_mineItemShowArrow, true)
        val isShowImage = typedArray.getBoolean(R.styleable.MineItemView_mineItemShowImage, true)
        val showDivider = typedArray.getBoolean(R.styleable.MineItemView_mineItemShowDivider, true)
        val titleColor = typedArray.getColor(
            R.styleable.MineItemView_mineItemTitleTextColor,
            ContextCompat.getColor(context, R.color.common_textMain)
        )
        val contentColor = typedArray.getColor(
            R.styleable.MineItemView_mineItemContentTextColor,
            ContextCompat.getColor(context, R.color.common_textSecond)
        )
        val titleMargin =
            typedArray.getDimension(
                R.styleable.MineItemView_mineItemTitleMargin,
                ScreenUtils.dpToPxInt(context, 5f)
            )

        val lines = typedArray.getInt(R.styleable.MineItemView_mineItemLines, 1)
        val maxLines = typedArray.getInt(R.styleable.MineItemView_mineItemMaxLines, 1)
        val titleLines = typedArray.getInt(R.styleable.MineItemView_mineItemTitleLines, 1)
        val titleMaxLines = typedArray.getInt(R.styleable.MineItemView_mineItemTitleMaxLines, 2)
        val showType = typedArray.getInt(R.styleable.MineItemView_mineItemShowType, 0)

        typedArray.recycle()

        val rootView = inflate(context, R.layout.view_mine_item, this)
        binding = ViewMineItemBinding.bind(rootView)
        binding.ivTitle.setImageResource(titleResId)
        binding.tvTitle.apply {
            text = titleText
            setTextColor(titleColor)
        }
        binding.ivRight.setImageResource(arrowImageResId)
        binding.tvContent.setTextColor(contentColor)
        binding.ivRight.visibility = if (isShowRightArrow) VISIBLE else GONE
        binding.ivTitle.visibility = if (isShowImage) VISIBLE else GONE
        binding.viewDivider.visibility = if (showDivider) VISIBLE else GONE
        val params = binding.tvTitle.layoutParams as LayoutParams
        params.marginStart = titleMargin.toInt()
        binding.tvTitle.layoutParams = params


        binding.ivWechat.visibility = View.GONE
        binding.ivFacebook.visibility = View.GONE
        binding.ivGoogle.visibility = View.GONE
        binding.ivApple.visibility = View.GONE

        binding.tvContent.setLines(lines)
        binding.tvContent.maxLines = maxLines

        binding.tvTitle.setLines(titleLines)
        binding.tvTitle.maxLines = titleMaxLines
        when (showType) {
            1 -> {
                binding.glCenter.setGuidelinePercent(0.85f)
            }
            2 -> {
                binding.glCenter.setGuidelinePercent(0.15f)
            }
            else -> {
                binding.glCenter.setGuidelinePercent(0.6f)
            }
        }
    }

    fun showDivider(showDivider: Boolean) {
        binding.viewDivider.visibility = if (showDivider) VISIBLE else GONE
    }

    fun showRightArrow(isShowRightArrow: Boolean) {
        binding.ivRight.visibility = if (isShowRightArrow) VISIBLE else GONE
    }

    fun showTextLeftIcon(@DrawableRes resId: Int = R.drawable.shape_circle_red_8) {
        val drawable = ContextCompat.getDrawable(context, resId)
        binding.tvContent.setCompoundDrawablesWithIntrinsicBounds(drawable, null, null, null);
    }
}