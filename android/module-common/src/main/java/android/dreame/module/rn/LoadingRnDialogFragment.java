package android.dreame.module.rn;

import android.app.Dialog;
import android.content.DialogInterface;
import android.dreame.module.R;
import android.dreame.module.rn.splashscreen.SplashScreen;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;

import androidx.activity.OnBackPressedCallback;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;

import org.jetbrains.annotations.NotNull;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/6/24 16:10
 * @Version: 1.0
 */
public class LoadingRnDialogFragment extends DialogFragment {

    public static LoadingRnDialogFragment newInstance(int progress) {

        Bundle args = new Bundle();
        args.putInt("progress", progress);
        LoadingRnDialogFragment fragment = new LoadingRnDialogFragment();
        fragment.setArguments(args);
        return fragment;
    }

    @Nullable
    @org.jetbrains.annotations.Nullable
    @Override
    public View onCreateView(@NonNull @NotNull LayoutInflater inflater, @Nullable @org.jetbrains.annotations.Nullable ViewGroup container, @Nullable @org.jetbrains.annotations.Nullable Bundle savedInstanceState) {
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(@NonNull @NotNull View view, @Nullable @org.jetbrains.annotations.Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initProperty();
    }

    @NonNull
    @NotNull
    @Override
    public Dialog onCreateDialog(@Nullable @org.jetbrains.annotations.Nullable Bundle savedInstanceState) {
        // Dialog dialog = new Dialog(getActivity(), R.style.Theme_FullScreenDialogAnimatedFade);
        Dialog dialog = new Dialog(getActivity(), R.style.SplashScreen_Fullscreen);
        dialog.setContentView(R.layout.dialog_layout_loading_rn);
        initProperty(dialog);
        dialog.setOnKeyListener((dialog1, keyCode, event) -> {
            if (keyCode == KeyEvent.KEYCODE_BACK) {
                //监听到回车事件
                SplashScreen.hide();
                requireActivity().finish();
                return true;
            }
            return false;
        });
        return dialog;
    }

   /* @Override
    public void onStart() {
        super.onStart();
        Dialog dialog = getDialog();
        initProperty(dialog);
    }*/

    private void initView() {
        if (getArguments() != null) {
            int progress = getArguments().getInt("progress", 0);
            // LottieAnimationView viewById = mRootView.findViewById(R.id.lottie_layer_name);
            // viewById.setFrame(progress);
        }

    }

    private void initProperty() {
        Dialog dialog = getDialog();
        initProperty(dialog);
    }

    private void initProperty(Dialog dialog) {
        if (dialog != null) {
            Window window = dialog.getWindow();
            window.setBackgroundDrawable(new ColorDrawable(Color.WHITE));
            window.getDecorView().setPadding(0, 0, 0, 0);
            window.setDimAmount(0);
            WindowManager.LayoutParams layoutParams = window.getAttributes();
            layoutParams.width = WindowManager.LayoutParams.MATCH_PARENT;
            layoutParams.height = WindowManager.LayoutParams.MATCH_PARENT;
            layoutParams.horizontalMargin = 0;
            layoutParams.verticalMargin = 0;
            layoutParams.dimAmount = 0;
            window.setAttributes(layoutParams);
            window.getDecorView().setMinimumWidth(getResources().getDisplayMetrics().widthPixels);
            window.getDecorView().setMinimumHeight(getResources().getDisplayMetrics().heightPixels);
            window.getDecorView().setBackgroundColor(Color.WHITE);
            window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);

            dialog.setCanceledOnTouchOutside(false);
        }
    }

    public boolean isShowing() {
        return getDialog() != null && getDialog().isShowing();
    }
}
