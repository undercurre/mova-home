package android.dreame.module.base.permission;

import com.hjq.permissions.OnPermissionCallback;

import java.util.List;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 兼容拦截器处理, OnPermissionCallback已废弃
 * @Date: 2021/4/28 9:33
 * @Version: 1.0
 */
public interface OnPermissionCallback2 extends OnPermissionCallback {
    @Deprecated
    @Override
    default void onDenied(List<String> permissions, boolean never) {
    }


    /**
     * 拦截器，拦截拒绝授权的结果
     *
     * @param permissions
     * @param never
     * @return true：自己处理，false:拦截器处理，默认拦截器处理
     */
    default boolean onDenied2(List<String> permissions, boolean never) {
        return false;
    }

    default boolean onDeniedToast(List<String> permissions, boolean never) {
        return false;
    }

    default void onFinish() {
    }

    /**
     * 弹框 确定按钮 点击
     *
     * @param permissions
     * @return
     */
    default boolean onDeniedConfirm(List<String> permissions) {
        return false;
    }

    /**
     * 弹框 取消按钮 点击
     *
     * @param permissions
     * @return
     */
    default boolean onDeniedCancel(List<String> permissions) {
        return false;
    }
}

