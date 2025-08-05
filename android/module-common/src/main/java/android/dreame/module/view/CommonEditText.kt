package android.dreame.module.view

import android.content.Context
import android.content.res.TypedArray
import android.dreame.module.R
import android.dreame.module.ext.setOnShakeProofClickListener
import android.graphics.Color
import android.text.Editable
import android.text.InputFilter
import android.text.InputType
import android.text.method.DigitsKeyListener
import android.text.method.HideReturnsTransformationMethod
import android.text.method.PasswordTransformationMethod
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.CheckedTextView
import android.widget.LinearLayout
import androidx.appcompat.widget.AppCompatEditText
import androidx.appcompat.widget.AppCompatImageView
import androidx.core.widget.addTextChangedListener

class CommonEditText : LinearLayout {

    private val etContent: AppCompatEditText
    private val ivClear: AppCompatImageView
    private val cbPassword: CheckedTextView
    private var showClear: Boolean = false
    private var showCiphertext = false

    constructor(context: Context) : this(context, null, 0)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0)
    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) :
            super(context, attrs, defStyleAttr) {

        LayoutInflater.from(context).inflate(R.layout.layout_common_edit_text, this)
        etContent = findViewById(R.id.et_content)
        ivClear = findViewById(R.id.iv_clear)
        cbPassword = findViewById(R.id.cb_password)

        val ta: TypedArray = context.obtainStyledAttributes(attrs, R.styleable.CommonEditText)
        showClear = ta.getBoolean(R.styleable.CommonEditText_showClear, false)
        showCiphertext = ta.getBoolean(R.styleable.CommonEditText_showCiphertext, false)
        val defaultCipher = ta.getBoolean(R.styleable.CommonEditText_defaultCipher, false)
        val hint = ta.getString(R.styleable.CommonEditText_android_hint)
        val inputType =
            ta.getInteger(R.styleable.CommonEditText_android_inputType, InputType.TYPE_CLASS_TEXT)
        val maxLength = ta.getInteger(R.styleable.CommonEditText_android_maxLength, 10000)

        val digits = ta.getString(R.styleable.CommonEditText_android_digits)

        val showUnderline = ta.getBoolean(R.styleable.CommonEditText_showUnderline, true)
        findViewById<View>(R.id.view_underline).visibility =
            if (showUnderline) View.VISIBLE else View.GONE

        ivClear.visibility = GONE
        cbPassword.visibility = GONE
        etContent.hint = hint
        digits?.let {
            etContent.keyListener = DigitsKeyListener.getInstance(it)
        }
        etContent.id = ta.getResourceId(R.styleable.CommonEditText_android_id, generateViewId())
        etContent.inputType = inputType
        etContent.filters = listOf(InputFilter.LengthFilter(maxLength)).toTypedArray()

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
                if (showCiphertext) {
                    cbPassword.visibility = View.VISIBLE
                } else {
                    cbPassword.visibility = View.GONE
                }
            } else {
                ivClear.visibility = View.GONE
                cbPassword.visibility = View.GONE
            }
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
                if (showCiphertext) {
                    cbPassword.visibility = View.VISIBLE
                } else {
                    cbPassword.visibility = View.GONE
                }
            } else {
                ivClear.visibility = View.GONE
                cbPassword.visibility = View.GONE
            }

            afterTextChanged.invoke(it)
        }
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

    fun setOnEditorActionListener(
        imeOptions: Int = EditorInfo.IME_ACTION_DONE,
        block: () -> Boolean
    ) {
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