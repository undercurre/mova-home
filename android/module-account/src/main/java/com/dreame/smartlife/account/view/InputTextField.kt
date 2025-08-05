package com.dreame.smartlife.account.view

import android.content.Context
import android.content.res.TypedArray
import android.dreame.module.ext.setOnShakeProofClickListener
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.text.Editable
import android.text.InputFilter
import android.text.InputType
import android.text.method.DigitsKeyListener
import android.text.method.HideReturnsTransformationMethod
import android.text.method.PasswordTransformationMethod
import android.util.AttributeSet
import android.util.Log
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.CheckedTextView
import android.widget.LinearLayout
import android.widget.RelativeLayout
import androidx.appcompat.widget.AppCompatEditText
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import androidx.core.view.inputmethod.EditorInfoCompat
import androidx.core.widget.addTextChangedListener
import com.dreame.smartlife.account.R

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/08/18
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class InputTextField : LinearLayout {
    private val llContainer: LinearLayout
    private val llCountryCode: LinearLayout
    private val tvCountryCode: AppCompatTextView
    private val etContent: AppCompatEditText
    private val llVerifCode: LinearLayout
    private val tvVerifCode: AppCompatTextView
    private val ivClear: AppCompatImageView
    private val cbPassword: CheckedTextView
    private var showClear: Boolean = false
    private var showCiphertext = false
    private var onFocusChange :((v: View,hasFocus : Boolean) -> Unit)? = null

    constructor(context: Context) : this(context, null, 0)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0)
    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) :
            super(context, attrs, defStyleAttr) {

        LayoutInflater.from(context).inflate(R.layout.layout_input_text_field, this)
        llContainer = findViewById(R.id.ll_container)
        llCountryCode = findViewById(R.id.ll_country_code)
        tvCountryCode = findViewById(R.id.tv_country_code)
        etContent = findViewById(R.id.et_content)
        llVerifCode = findViewById(R.id.ll_verif_code)
        tvVerifCode = findViewById(R.id.tv_verif_code)
        ivClear = findViewById(R.id.iv_clear)
        cbPassword = findViewById(R.id.cb_password)

        val ta: TypedArray = context.obtainStyledAttributes(attrs, R.styleable.InputTextField)
        val showCountryCode = ta.getBoolean(R.styleable.InputTextField_showCountryCode, false)
        val showVerfiCode = ta.getBoolean(R.styleable.InputTextField_showVerifCode, false)
        showClear = ta.getBoolean(R.styleable.InputTextField_showClear, false)
        showCiphertext = ta.getBoolean(R.styleable.InputTextField_showCiphertext, false)
        val defaultCipher = ta.getBoolean(R.styleable.InputTextField_defaultCipher, false)
        val hint = ta.getString(R.styleable.InputTextField_android_hint)
        val inputType =
            ta.getInteger(R.styleable.InputTextField_android_inputType, InputType.TYPE_CLASS_TEXT)
        val maxLength = ta.getInteger(R.styleable.InputTextField_android_maxLength, 1000)
        val defaultCountryCode = ta.getString(R.styleable.InputTextField_defaultCountryCode)
        val defaultVerfiText = ta.getString(R.styleable.InputTextField_defaultVerifText)

        val digits = ta.getString(R.styleable.InputTextField_android_digits)

//        val showUnderline = ta.getBoolean(R.styleable.InputTextField_showUnderline, false)
//        findViewById<View>(R.id.view_underline).visibility = if (showUnderline) View.VISIBLE else View.GONE

        llCountryCode.visibility = if (showCountryCode) VISIBLE else GONE
        llVerifCode.visibility = if (showVerfiCode) VISIBLE else GONE
        ivClear.visibility = GONE
        cbPassword.visibility = if(showCiphertext) VISIBLE else GONE
        etContent.hint = hint
        digits?.let {
            etContent.keyListener = DigitsKeyListener.getInstance(it)
        }
        etContent.id = ta.getResourceId(R.styleable.InputTextField_android_id, generateViewId())
        etContent.inputType = inputType
        etContent.filters = listOf(InputFilter.LengthFilter(maxLength)).toTypedArray()
        tvCountryCode.text = defaultCountryCode
        tvVerifCode.text = defaultVerfiText

        ivClear.setOnClickListener {
            etContent.setText("")
        }

        cbPassword.setOnClickListener {
            cbPassword.isChecked = !cbPassword.isChecked
            cbPasswordCheckChange()
        }
        etContent.setOnFocusChangeListener { v, hasFocus ->
            if (hasFocus && etContent.text?.isEmpty() == false) {
                if (showClear) {
                    ivClear.visibility = View.VISIBLE
                } else {
                    ivClear.visibility = View.GONE
                }
            } else {
                ivClear.visibility = View.GONE
            }
            onFocusChange?.invoke(v,hasFocus)
        }
        cbPassword.isChecked = !defaultCipher
        cbPasswordCheckChange()
    }

    private fun cbPasswordCheckChange() {
        if (cbPassword.isChecked) {
            etContent.transformationMethod = HideReturnsTransformationMethod.getInstance()
        } else {
            etContent.transformationMethod = PasswordTransformationMethod.getInstance()
        }
        etContent.text?.let {
            etContent.setSelection(it.length)
        }
    }

    fun getText(): String {
        return etContent.text.toString()
    }

    fun countryCodeClickListener(listener: View.OnClickListener) =
        llCountryCode.setOnShakeProofClickListener(listener = listener)

    fun verifCodeClickListener(listener: View.OnClickListener) =
        llVerifCode.setOnShakeProofClickListener(listener = listener)

    fun countryCodeEnable(enable: Boolean) {
        llCountryCode.isEnabled = enable
    }

    fun verifCodeEnable(enable: Boolean) {
        llVerifCode.isEnabled = enable
    }

    fun verifCodeHighlight(highlight: Boolean) {
        if (highlight) {
            tvVerifCode.setTextColor(Color.parseColor("#FFAB8C5E"))
        } else {
            tvVerifCode.setTextColor(Color.parseColor("#AAAAAA"))
        }
    }

    fun setCountryCode(text: String) {
        tvCountryCode.text = text
    }

    fun setVerifCode(text: String) {
        tvVerifCode.text = text
    }

    fun setShowClear(showClear: Boolean) {
        this.showClear = showClear
    }

    fun setClearVisible(visible: Boolean) {
        ivClear.visibility = if (visible) View.VISIBLE else View.GONE
    }

    fun setCiphertextVisible(visible: Boolean) {
        showCiphertext = visible
        cbPassword.visibility = if (visible) View.VISIBLE else View.GONE
    }

    /**
     * 控制 小眼睛 是否显示密文，默认明文
     */
    fun setShowCiphertext(isCiphertext: Boolean = true) {
        cbPassword.isChecked = !isCiphertext
        cbPasswordCheckChange()
    }

    fun addAfterTextChangedListener(afterTextChanged: (text: Editable?) -> Unit = {}) {
        etContent.addTextChangedListener {
            if (etContent.hasFocus() && etContent.text?.isEmpty() == false) {
                if (showClear) {
                    ivClear.visibility = View.VISIBLE
                } else {
                    ivClear.visibility = View.GONE
                }
            } else {
                ivClear.visibility = View.GONE
            }

            afterTextChanged.invoke(it)
        }
    }

    fun setCountryCodeVisibility(visibility: Int) {
        llCountryCode.visibility = visibility
    }

    fun setVerifCodeVisibility(visibility: Int) {
        llVerifCode.visibility = visibility
    }

    fun setHint(text: String) {
        etContent.hint = text
    }

    fun setInputType(inputType: Int) {
        etContent.inputType = inputType
    }

    fun setContent(content: String) {
        etContent.setText(content)
    }

    fun setInputTextColor(color: Int) {
        etContent.setTextColor(color)
    }

    fun setOnFocusChange(onFocusChange :((v: View,hasFocus : Boolean) -> Unit)? = null) {
        this.onFocusChange = onFocusChange
    }

    fun setContainerBackground(drawable: Drawable) {
        llContainer.background = drawable
    }

    fun setOnEditorActionListener(imeOptions: Int = EditorInfo.IME_ACTION_DONE, block: () -> Boolean) {
        etContent.imeOptions = imeOptions
        etContent.setOnEditorActionListener { v, actionId, event ->
            if (actionId == imeOptions) {
                // do something
                block()
            }
            false
        }
    }
}