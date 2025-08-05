package android.dreame.module.ui;

import android.dreame.module.R;
import android.dreame.module.base.BaseActivity;
import android.view.View;
import android.widget.TextView;

public class JSExceptionActivity extends BaseActivity {
    TextView tvError;

    @Override
    protected int getContentViewId() {
        return R.layout.activity_js_exception;
    }

    @Override
    protected void initViewModel() {

    }

    @Override
    public void initView() {
        tvError = findViewById(R.id.tv_error);
        tvError.setText(getIntent().getStringExtra("error"));
    }

    @Override
    public void initData() {

    }

    @Override
    public void initEvent() {

    }

    @Override
    public void onClick(View v) {

    }
}
