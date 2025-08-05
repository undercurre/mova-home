package android.dreame.module.base.delegate;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/27 10:22
 * @Version: 1.0
 */
public interface IPermissionCallBack {
    /**
     * 用户从权限设置界面返回,重新检查必要权限
     */
    void permissionSettingBack();
}
