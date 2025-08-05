package android.dreame.module.base.delegate;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.hjq.permissions.XXPermissions;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/27 9:42
 * @Version: 1.0
 */
public class BaseFragmentDelegate {

    public static void onActivityResult(int requestCode, int resultCode, @Nullable Intent data, @NonNull Object... receivers) {
        if (requestCode == XXPermissions.REQUEST_CODE) {
            for (Object object : receivers) {
                // 通知，用户从权限设置界面回来，检查必要权限是否授权
                if (object instanceof IPermissionCallBack) {
                    ((IPermissionCallBack) object).permissionSettingBack();
                }
            }
        }
    }
}
