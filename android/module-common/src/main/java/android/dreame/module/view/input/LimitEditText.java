package android.dreame.module.view.input;

import android.content.Context;
import android.util.AttributeSet;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputConnectionWrapper;

import java.util.regex.Pattern;

/**
 * author: sunzhibin
 * e-mail: sunzhibin@dreame.tech
 * desc: 自定义
 * date: 2021/4/15 17:08
 * version: 1.0
 */
public class LimitEditText extends androidx.appcompat.widget.AppCompatEditText {
    /**
     * 不做任何限制
     */
    public final static int TYPE_LIMIT_ALL = 0;
    /**
     * 限制输入密码格式：字母大小写、数组、部分特殊字符
     */
    public final static int TYPE_LIMIT_PWD = 1;
    /**
     * 支持输入PWD+中文汉字
     */
    public final static int TYPE_LIMIT_PWD_CHINESE = 2;
    /**
     * 排除空格
     */
    public final static int TYPE_LIMIT_SPACE = 3;
    /**
     * 其他，暂未实现功能
     */
    public final static int TYPE_LIMIT_OTHER = 4;

    public LimitEditText(Context context) {
        super(context);
    }

    public LimitEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public LimitEditText(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    private int limitType = TYPE_LIMIT_ALL;

    public int getLimitType() {
        return limitType;
    }

    public void setLimitType(int limitType) {
        this.limitType = limitType;
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        // ViewShowHelper.measureTextWidth(this);
    }

    @Override
    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        InputConnection target = super.onCreateInputConnection(outAttrs);

        if (isEnabled() && target != null && limitType != TYPE_LIMIT_ALL) {
            return new InnerInputConnection(target, true);
        } else {
            return target;
        }

    }

    class InnerInputConnection extends InputConnectionWrapper {
        // 数字,字母
        private Pattern pattern = Pattern.compile("^[0-9A-Za-z]$");
        // 标点
        private Pattern patternChar = Pattern.compile("[^\\w\\s]+");
        // EmoJi
        private Pattern patternEmoJi = Pattern.compile("[\ud83c\udc00-\ud83c\udfff]|[\ud83d\udc00-\ud83d\udfff]|[\u2600-\u27ff]", Pattern.UNICODE_CASE | Pattern.CASE_INSENSITIVE);
        // 英文标点
        private Pattern patternEn = Pattern.compile("^[a-z_A-Z0-9-\\.!@#\\$%\\\\\\^&\\*\\)\\(\\+=\\{\\}\\[\\]\\/\",'<>~\\·`\\?:;|]+$");
        // 中文标点
        private Pattern patternCn = Pattern.compile("^[·！#￥（——）：；“”‘、，|《。》？、【】\\[\\]]$");

        /**
         * 数字、字母、英文特殊字符
         */
        private static final String reg = "^[a-z_A-Z0-9-\\.!@#\\$%\\\\\\^&\\*\\)\\(\\+=\\{\\}\\[\\]\\/\",'<>~\\·`\\?:;|]+$";
        /**
         * 数字、字母、英文特殊字符、汉字
         */
        private static final String reg2 = "^[\u4E00-\u9FA5a-z_A-Z0-9-\\.!@#\\$%\\\\\\^&\\*\\)\\(\\+=\\{\\}\\[\\]\\/\",'<>~\\·`\\?:;|]+$";

        private static final String reg3 = "^[\\S]+$";

        /**
         * Initializes a wrapper.
         *
         * <p><b>Caveat:</b> Although the system can accept {@code (InputConnection) null} in some
         * places, you cannot emulate such a behavior by non-null {@link InputConnectionWrapper} that
         * has {@code null} in {@code target}.</p>
         *
         * @param target  the {@link InputConnection} to be proxied.
         * @param mutable set {@code true} to protect this object from being reconfigured to target
         *                another {@link InputConnection}.  Note that this is ignored while the target is {@code null}.
         */
        public InnerInputConnection(InputConnection target, boolean mutable) {
            super(target, mutable);
        }

        @Override
        public boolean commitText(CharSequence text, int newCursorPosition) {
            if (patternEmoJi.matcher(text).find()) {
                return false;
            }
            String regex = null;
            if (limitType == TYPE_LIMIT_PWD) {
                regex = reg;
                text = keyBordSpaceCompat(text);
            } else if (limitType == TYPE_LIMIT_PWD_CHINESE) {
                regex = reg2;
                // 兼容华为键盘 英文小数点“.”为“. ”包含一个空格
                text = keyBordSpaceCompat(text);
            } else if (limitType == TYPE_LIMIT_SPACE) {
                regex = reg3;
                // 兼容华为键盘 英文小数点“.”为“. ”包含一个空格
                text = keyBordSpaceCompat(text);
            } else {
                regex = null;
            }
            if (regex == null || Pattern.matches(regex, text)) {
                return super.commitText(text, newCursorPosition);
            }
            return false;
        }
    }

    /**
     * 兼容华为键盘 英文小数点“.”为“. ”包含一个空格
     * 英文智能联想会带空格
     */
    private CharSequence keyBordSpaceCompat(CharSequence text) {
        if (text.toString().contains(" ")) {
            text = text.toString().replace(" ", "");
        }
        return text;
    }

}
