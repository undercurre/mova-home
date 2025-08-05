package android.dreame.module.base.permission;

import android.app.Activity;
import android.content.Context;
import android.dreame.module.R;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dreame.module.res.BottomConfirmDialog;
import com.hjq.permissions.IPermissionInterceptor;
import com.hjq.permissions.OnPermissionCallback;
import com.hjq.permissions.Permission;
import com.hjq.permissions.XXPermissions;
import android.dreame.module.util.toast.ToastUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * author : Android 轮子哥
 * github : https://github.com/getActivity/XXPermissions
 * time   : 2021/01/04
 * desc   : 权限申请拦截器
 */
public final class PermissionInterceptor implements IPermissionInterceptor {

    private BottomConfirmDialog locationDialog;
    /**
     * 权限申请标记
     */
    private boolean mRequestFlag;

    @Override
    public void deniedPermissionRequest(@NonNull Activity activity, @NonNull List<String> allPermissions, @NonNull List<String> deniedPermissions,
                                        boolean doNotAskAgain, @Nullable OnPermissionCallback callback) {
        if (callback == null) {
            return;
        }
        // 回调授权失败的方法
        // callback2的话，查看onDenied2返回值true，拦截器不做处理，false：拦截器处理
        if (callback instanceof OnPermissionCallback2) {
            if (((OnPermissionCallback2) callback).onDenied2(deniedPermissions, doNotAskAgain)) {
                ((OnPermissionCallback2) callback).onFinish();
                return;
            }
        } else {
            callback.onDenied(deniedPermissions, doNotAskAgain);
        }

        if (doNotAskAgain) {
            showPermissionDialog2(activity, deniedPermissions, callback);
            if (callback instanceof OnPermissionCallback2) {
                ((OnPermissionCallback2) callback).onFinish();
            }
            return;
        }

        if (deniedPermissions.size() == 1) {
            final String deniedPermission = deniedPermissions.get(0);
            if (Permission.ACCESS_BACKGROUND_LOCATION.equals(deniedPermission)) {
                ToastUtils.show(activity.getString(R.string.common_permission_fail_4));
            }

            if (callback instanceof OnPermissionCallback2) {
                ((OnPermissionCallback2) callback).onFinish();
            }
            return;
        }

        if (callback instanceof OnPermissionCallback2) {
            if (((OnPermissionCallback2) callback).onDeniedToast(deniedPermissions, doNotAskAgain)) {
                ((OnPermissionCallback2) callback).onFinish();
                return;
            }
        }
        ToastUtils.show(activity.getString(R.string.common_permission_fail_1));
        if (callback instanceof OnPermissionCallback2) {
            ((OnPermissionCallback2) callback).onFinish();
        }
    }

    @Override
    public void launchPermissionRequest(@NonNull Activity activity, @NonNull List<String> allPermissions, @Nullable OnPermissionCallback callback) {
        IPermissionInterceptor.super.launchPermissionRequest(activity, allPermissions, callback);
        mRequestFlag = true;
    }

    @Override
    public void finishPermissionRequest(@NonNull Activity activity, @NonNull List<String> allPermissions, boolean skipRequest, @Nullable OnPermissionCallback callback) {
        IPermissionInterceptor.super.finishPermissionRequest(activity, allPermissions, skipRequest, callback);
        mRequestFlag = false;

    }


    protected void showPermissionDialog2(Activity activity, List<String> permissions, OnPermissionCallback callback) {
        if (locationDialog != null && locationDialog.isShowing()) {
            return;
        }
        locationDialog = new BottomConfirmDialog(activity);
        locationDialog.show(getPermissionHint(activity, permissions),
                activity.getString(R.string.common_permission_goto),
                activity.getString(R.string.cancel),
                dialog -> {
                    dialog.dismiss();
                    XXPermissions.startPermissionActivity(activity, permissions);
                    if (callback instanceof OnPermissionCallback2) {
                        ((OnPermissionCallback2) callback).onDeniedConfirm(permissions);
                    }
                    return null;
                },
                dialog -> {
                    dialog.dismiss();
                    if (callback instanceof OnPermissionCallback2) {
                        ((OnPermissionCallback2) callback).onDeniedCancel(permissions);
                    }
                    return null;
                });
    }

    /**
     * 根据权限获取提示
     */
    protected String getPermissionHint(Context context, List<String> permissions) {
        if (permissions == null || permissions.isEmpty()) {
            return context.getString(R.string.common_permission_fail_2);
        }

        List<String> hints = new ArrayList<>();
        for (String permission : permissions) {
            switch (permission) {
                case Permission.READ_MEDIA_IMAGES:
                case Permission.READ_MEDIA_VIDEO:
                case Permission.READ_EXTERNAL_STORAGE:
                case Permission.WRITE_EXTERNAL_STORAGE: {
                    String hint = context.getString(R.string.common_permission_storage);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.CAMERA: {
                    String hint = context.getString(R.string.common_permission_camera);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.RECORD_AUDIO: {
                    String hint = context.getString(R.string.common_permission_microphone);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.ACCESS_FINE_LOCATION:
                case Permission.ACCESS_COARSE_LOCATION:
                case Permission.ACCESS_BACKGROUND_LOCATION: {
                    String hint;
                    if (!permissions.contains(Permission.ACCESS_FINE_LOCATION) &&
                            !permissions.contains(Permission.ACCESS_COARSE_LOCATION)) {
                        hint = context.getString(R.string.common_permission_location_background);
                    } else {
                        hint = context.getString(R.string.common_permission_location);
                    }
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.READ_PHONE_STATE:
                case Permission.CALL_PHONE:
                case Permission.ADD_VOICEMAIL:
                case Permission.USE_SIP:
                case Permission.READ_PHONE_NUMBERS:
                case Permission.ANSWER_PHONE_CALLS: {
                    String hint = context.getString(R.string.common_permission_phone);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.GET_ACCOUNTS:
                case Permission.READ_CONTACTS:
                case Permission.WRITE_CONTACTS: {
                    String hint = context.getString(R.string.common_permission_contacts);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.READ_CALENDAR:
                case Permission.WRITE_CALENDAR: {
                    String hint = context.getString(R.string.common_permission_calendar);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.READ_CALL_LOG:
                case Permission.WRITE_CALL_LOG:
                case Permission.PROCESS_OUTGOING_CALLS: {
                    String hint = context.getString(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q ?
                            R.string.common_permission_call_log : R.string.common_permission_phone);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.BODY_SENSORS: {
                    String hint = context.getString(R.string.common_permission_sensors);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.ACTIVITY_RECOGNITION: {
                    String hint = context.getString(R.string.common_permission_activity_recognition);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.SEND_SMS:
                case Permission.RECEIVE_SMS:
                case Permission.READ_SMS:
                case Permission.RECEIVE_WAP_PUSH:
                case Permission.RECEIVE_MMS: {
                    String hint = context.getString(R.string.common_permission_sms);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.REQUEST_INSTALL_PACKAGES: {
                    String hint = context.getString(R.string.common_permission_install);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.NOTIFICATION_SERVICE: {
                    String hint = context.getString(R.string.common_permission_notification);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.SYSTEM_ALERT_WINDOW: {
                    String hint = context.getString(R.string.common_permission_window);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                case Permission.WRITE_SETTINGS: {
                    String hint = context.getString(R.string.common_permission_setting);
                    if (!hints.contains(hint)) {
                        hints.add(hint);
                    }
                    break;
                }
                default:
                    break;
            }
        }

        if (!hints.isEmpty()) {
            StringBuilder builder = new StringBuilder();
            for (String text : hints) {
                if (builder.length() == 0) {
                    builder.append(text);
                } else {
                    builder.append("、")
                            .append(text);
                }
            }
            builder.append(" ");
            return context.getString(R.string.common_permission_fail_3, builder.toString());
        }

        return context.getString(R.string.common_permission_fail_2);
    }

}