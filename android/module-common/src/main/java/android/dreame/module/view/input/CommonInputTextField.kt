package android.dreame.module.view.input

import android.content.Context
import android.content.res.TypedArray
import android.dreame.module.R
import android.dreame.module.util.LogUtil
import android.text.Editable
import android.text.InputFilter
import android.text.InputType
import android.text.TextWatcher
import android.text.method.DigitsKeyListener
import android.text.method.HideReturnsTransformationMethod
import android.text.method.PasswordTransformationMethod
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.CheckedTextView
import android.widget.EditText
import android.widget.ImageView
import android.widget.LinearLayout
import androidx.core.widget.doAfterTextChanged
import java.io.UnsupportedEncodingException


class CommonInputTextField : LinearLayout {
    private val etContent: EditText
    private val ivClear: ImageView
    private val cbPassword: CheckedTextView
    private var showClear: Boolean = false
    private var showCiphertext = false

    private var defaultShowCiphertext: Boolean = false
    private var defaultShowClear = false

    constructor(context: Context) : this(context, null, 0)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0)
    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) :
            super(context, attrs, defStyleAttr) {

        LayoutInflater.from(context).inflate(R.layout.common_layout_input_text_field, this)
        etContent = findViewById(R.id.et_content)
        ivClear = findViewById(R.id.iv_clear)
        cbPassword = findViewById(R.id.cb_password)

        val ta: TypedArray = context.obtainStyledAttributes(attrs, R.styleable.CommonInputTextField)
        showClear = ta.getBoolean(R.styleable.CommonInputTextField_common_showClear, false)
        showCiphertext = ta.getBoolean(R.styleable.CommonInputTextField_common_showCiphertext, false)
        defaultShowCiphertext = ta.getBoolean(R.styleable.CommonInputTextField_common_defaultShowCiphertext, false)
        defaultShowClear = ta.getBoolean(R.styleable.CommonInputTextField_common_defaultShowClear, false)
        val defaultCipher = ta.getBoolean(R.styleable.CommonInputTextField_common_defaultCipher, false)
        val hint = ta.getString(R.styleable.CommonInputTextField_android_hint)
        val inputType =
            ta.getInteger(R.styleable.CommonInputTextField_android_inputType, InputType.TYPE_CLASS_TEXT)
        val maxLength = ta.getInteger(R.styleable.CommonInputTextField_android_maxLength, 1000)
        val digits = ta.getString(R.styleable.CommonInputTextField_android_digits)

        ivClear.visibility = if (defaultShowClear) View.VISIBLE else View.GONE
        cbPassword.visibility = if (defaultShowCiphertext) View.VISIBLE else View.GONE
        etContent.hint = hint
        digits?.let {
            etContent.keyListener = DigitsKeyListener.getInstance(it)
        }
        etContent.id = ta.getResourceId(R.styleable.CommonInputTextField_android_id, generateViewId())
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
            LogUtil.d("------- setOnFocusChangeListener -------- $v   $hasFocus")
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
                ivClear.visibility = if (defaultShowClear) View.VISIBLE else View.GONE
                cbPassword.visibility = if (defaultShowCiphertext) View.VISIBLE else View.GONE
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
        etContent.doAfterTextChanged {
            if (etContent.hasFocus() && etContent.text?.isEmpty() == false) {
                if (showClear || defaultShowClear) {
                    ivClear.visibility = View.VISIBLE
                } else {
                    ivClear.visibility = View.GONE
                }
                if (showCiphertext || defaultShowCiphertext) {
                    cbPassword.visibility = View.VISIBLE
                } else {
                    cbPassword.visibility = View.GONE
                }
            } else {
                ivClear.visibility = if (defaultShowClear) View.VISIBLE else View.GONE
                cbPassword.visibility = if (defaultShowCiphertext) View.VISIBLE else View.GONE
            }
            LogUtil.d("sunzhibin", "--------------- ${it?.length} $it ")
            afterTextChanged.invoke(it)
        }
    }

    /**
     * 路由器密码长度 8-63
     */
    fun addBytesLengthTextChangedListener(byteLength: Int = 63, afterTextChanged: (text: Editable?) -> Unit = {}) {
        etContent.filters = arrayOf(InputFilter { source, start, end, dest, dstart, dend ->
            try {
                // 在输入之前检查新的文本长度
                val inputText = dest.toString() + source.toString()
                val bytes = inputText.toByteArray(charset("UTF-8"))
                if (bytes.size > byteLength) {
                    // 如果超过了最大字节数，返回空字符串表示不接受新的输入
                    return@InputFilter ""
                }
            } catch (e: UnsupportedEncodingException) {
                e.printStackTrace()
            }
            // 否则返回null表示接受新的输入
            return@InputFilter null
        })
        addAfterTextChangedListener(afterTextChanged)
    }

    fun getEditTextView() = etContent
    fun setHint(text: String) {
        etContent.hint = text
    }

    fun setInputType(inputType: Int) {
        etContent.inputType = inputType
    }

    fun setContent(content: String) {
        LogUtil.d("sunzhibin", "---------------- ${content.length}  content: $content")
        etContent.setText(content)
        etContent.setSelection(content.length)
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