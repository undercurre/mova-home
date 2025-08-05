package android.dreame.module.view.input;

import android.text.Editable;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextWatcher;
import android.widget.EditText;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/30 15:42
 * @Version: 1.0
 */
public class BytesLengthTextWatcher implements TextWatcher {

    private EditText editText;
    private TextWatcher watcher;
    private int byteLength;

    public BytesLengthTextWatcher(EditText editText, int byteLength, TextWatcher watcher) {
        this.editText = editText;
        this.watcher = watcher;
        this.byteLength = byteLength > 0 ? byteLength : 0;

        InputFilter filter = new InputFilter() {
            public CharSequence filter(CharSequence source, int start, int end,
                                       Spanned dest, int dstart, int dend) {
                try {
                    // 在输入之前检查新的文本长度
                    String inputText = dest.toString() + source.toString();
                    byte[] bytes = inputText.getBytes("UTF-8");
                    if (bytes.length > byteLength) {
                        // 如果超过了最大字节数，返回空字符串表示不接受新的输入
                        return "";
                    }
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                // 否则返回null表示接受新的输入
                return null;
            }
        };
        editText.setFilters(new InputFilter[]{filter});
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        if (watcher != null) {
            watcher.beforeTextChanged(s, start, count, after);
        }
    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
        if (watcher != null) {
            watcher.onTextChanged(s, start, before, count);
        }
    }

    @Override
    public void afterTextChanged(Editable s) {
        if (watcher != null) {
            watcher.afterTextChanged(s);
        }
    }
}
