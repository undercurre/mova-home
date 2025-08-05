package android.dreame.module.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.dreame.module.R;
import android.dreame.module.ext.ViewExtKt;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;


public class NewInputDialog extends Dialog implements View.OnClickListener {
    private final EditText etInput;
    private final TextView tvTitle;
    private final TextView tvNegative;
    private final TextView tvPositive;
    private final ImageView ivDelete;
    private int maxLength;
    private OnDialogCallback onDialogClick;

    public NewInputDialog(@NonNull Context context) {
        super(context, R.style.dialog_bottom_full);
        this.setCanceledOnTouchOutside(true);
        this.setCancelable(true);
        View view = View.inflate(context, R.layout.dialog_new_input, null);
        tvTitle = view.findViewById(R.id.tv_title);
        etInput = view.findViewById(R.id.et_input);
        tvNegative = view.findViewById(R.id.tv_negative);
        tvPositive = view.findViewById(R.id.tv_positive);
        ivDelete = view.findViewById(R.id.iv_delete);

        ViewExtKt.setOnShakeProofClickListener(tvNegative,800,this);
        ViewExtKt.setOnShakeProofClickListener(tvPositive,800,this);
        ViewExtKt.setOnShakeProofClickListener(ivDelete,800,this);
        tvNegative.setOnClickListener(this);
        tvPositive.setOnClickListener(this);
        etInput.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (!TextUtils.isEmpty(s)) {
                    ivDelete.setVisibility(View.VISIBLE);
                    if(s.length() == maxLength && onDialogClick != null){
                        onDialogClick.onMaxLengthCallback();
                    }
                } else {
                    ivDelete.setVisibility(View.GONE);
                }
            }
        });
        setContentView(view);

        setCancelable(false);
        setCanceledOnTouchOutside(false);
        getWindow().setGravity(Gravity.BOTTOM);
        getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
    }

    public NewInputDialog setTitle(String title) {
        tvTitle.setText(title);
        return this;
    }

    public NewInputDialog setOnDialogClick(OnDialogCallback onDialogClick) {
        this.onDialogClick = onDialogClick;
        return this;
    }

    public NewInputDialog setInputText(String content) {
        etInput.setText(content);
        return this;
    }

    public NewInputDialog setMaxLength(int length) {
        this.maxLength = length;
        InputFilter[] filters = {new InputFilter.LengthFilter(length)};
        etInput.setFilters(filters);
        return this;
    }

    public NewInputDialog setInputHint(String hint) {
        etInput.setHint(hint);
        return this;
    }

    public NewInputDialog setDefaultContent(String defaultContent) {
        etInput.setText(defaultContent);
        etInput.requestFocus();
        etInput.setSelection(defaultContent.length());
        if(!TextUtils.isEmpty(defaultContent)){
            ivDelete.setVisibility(View.VISIBLE);
        }
        return this;
    }

    public NewInputDialog setNegative(String defaultContent) {
        tvNegative.setText(defaultContent);
        return this;
    }

    public NewInputDialog setPositive(String defaultContent) {
        tvPositive.setText(defaultContent);
        return this;
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.tv_negative) {
            if (this.onDialogClick != null) {
                this.onDialogClick.onCancelClick(this,v);
            }
        } else if (v.getId() == R.id.tv_positive) {
            if (this.onDialogClick != null) {
                this.onDialogClick.onOKClick(this,etInput.getText().toString(), v);
            }
        }else if(v.getId() == R.id.iv_delete){
            etInput.setText("");
        }
    }

    public interface OnDialogCallback {
        void onOKClick(Dialog dialog, String inputText, View v);

        void onCancelClick(Dialog dialog, View v);

        void onMaxLengthCallback();
    }
}
