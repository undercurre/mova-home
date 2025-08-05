package android.dreame.module.view.dialog;

import android.app.Dialog;
import android.content.Context;
import android.dreame.module.R;
import android.text.TextUtils;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;

import androidx.annotation.NonNull;

public class CustomProgressDialog extends Dialog {
    private TextView tvMessage;

    public CustomProgressDialog(@NonNull Context context) {
        this(context, R.style.Custom_Progress);
    }

    public CustomProgressDialog(@NonNull Context context, int themeResId) {
        super(context, themeResId);
        setContentView(R.layout.dialog_custom_progress);
        tvMessage = findViewById(R.id.tv_message);
        WindowManager.LayoutParams layoutParams = getWindow().getAttributes();
        layoutParams.dimAmount = 0.03f;
        getWindow().setAttributes(layoutParams);
        setCanceledOnTouchOutside(false);
        setCancelable(false);
    }

    public void setMessage(String message) {
        if (!TextUtils.isEmpty(message)) {
            tvMessage.setVisibility(View.VISIBLE);
            tvMessage.setText(message);
        }
    }
}
