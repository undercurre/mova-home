package android.dreame.module.manager;

import android.content.Context;
import android.content.SharedPreferences;
import android.dreame.module.LocalApplication;
import android.dreame.module.bean.OAuthBean;
import android.dreame.module.bean.UserInfoBean;
import android.dreame.module.constant.Constants;
import android.dreame.module.util.GsonUtils;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.privacy.PrivacyPolicyHelper;
import android.text.TextUtils;
import android.util.Log;

import com.dreame.hacklibrary.HackJniHelper;
import com.tencent.mmkv.MMKV;

import java.util.Date;

public class AccountManager {
    private static String FILENAME = "sp_account";
    private static String ACCOUNTINFO = "account";
    private static String LAST_REFRESH_TIME = "lastRefreshTime";
    private static String LOGIN_ACCOUNT = "loginAccount";

    private static String USER_INFO = "userInfo";
    private static String USER_IS_FIRST_LOGIN = "userIsFirstLogin";
    private static final String ALI_AUTH_CODE = "aliAuthCode_v1";

    private static AccountManager mInstance;
    private MMKV accountKv;
    private SharedPreferences accountSp;
    // 空对象
    private static OAuthBean sOAuthBean = new OAuthBean(Constants.NET_ERROR, "error");
    private AccountChangedCallback mAccountChangedCallback;

    private AccountManager() {
        accountKv = MMKV.mmkvWithID(FILENAME, MMKV.SINGLE_PROCESS_MODE, HackJniHelper.getCryptKey());
        accountSp = LocalApplication.getInstance().getSharedPreferences(FILENAME, Context.MODE_PRIVATE);
    }

    public static AccountManager getInstance() {
        if (mInstance == null) {
            synchronized (AccountManager.class) {
                if (mInstance == null) {
                    mInstance = new AccountManager();
                }
            }
        }
        return mInstance;
    }

    public void setAccountChangedCallback(AccountChangedCallback accountChangedCallback) {
        this.mAccountChangedCallback = accountChangedCallback;
    }

    public void setAccount(OAuthBean oAuthBean) {
        accountSp.edit().putString(ACCOUNTINFO, GsonUtils.toJson(oAuthBean)).apply();
        if (mAccountChangedCallback != null) {
            mAccountChangedCallback.onAuthBeanChanged(oAuthBean);
        }
        accountSp.edit().putLong(LAST_REFRESH_TIME, new Date().getTime()).apply();
    }

    public OAuthBean getAccount() {
        return getAccount(accountSp);
    }

    public Long getLastRefreshTime() {
        return accountSp.getLong(LAST_REFRESH_TIME, 0);
    }

    /**
     * 适用于provider,获取进程间数据
     *
     * @param context applicationContext
     */
    public OAuthBean getAccount(Context context) {
        return getAccount(accountSp);
    }

    private OAuthBean getAccount(SharedPreferences accountSp) {
        String accountStr = accountSp.getString(ACCOUNTINFO, "");
        if (TextUtils.isEmpty(accountStr)) {
            accountStr = accountKv.decodeString(ACCOUNTINFO);
            if (!TextUtils.isEmpty(accountStr)) {
                Log.i("AccountManager", "defaultGet getAccount: " + accountStr.length());
                accountSp.edit().putString(ACCOUNTINFO, accountStr).apply();
            }
        }
        if (!TextUtils.isEmpty(accountStr)) {
            OAuthBean oAuthBean = GsonUtils.fromJson(accountStr, OAuthBean.class);
            if (oAuthBean != null) {
                return oAuthBean;
            }
        }
        if (sOAuthBean == null) {
            sOAuthBean = new OAuthBean(Constants.NET_ERROR, "error");
        }
        return sOAuthBean;
    }

    public void setUserInfo(UserInfoBean userInfo) {
        accountSp.edit().putString(USER_INFO, GsonUtils.toJson(userInfo)).apply();
    }

    public UserInfoBean getUserInfo() {
        return getUserInfo(accountSp);
    }

    /**
     * 适用于provider,获取进程间数据
     *
     * @param context applicationContext
     */
    public UserInfoBean getUserInfo(Context context) {
        return getUserInfo(accountSp);
    }

    private UserInfoBean getUserInfo(SharedPreferences accountSp) {
        String userInfoStr = accountSp.getString(USER_INFO, "");
        if (TextUtils.isEmpty(userInfoStr)) {
            userInfoStr = accountKv.decodeString(USER_INFO, "");
            if (!TextUtils.isEmpty(userInfoStr)) {
                accountSp.edit().putString(USER_INFO, userInfoStr).apply();
            }
        }
        if (TextUtils.isEmpty(userInfoStr)) {
            return new UserInfoBean();
        } else {
            return GsonUtils.fromJson(userInfoStr, UserInfoBean.class);
        }
    }

    /**
     * 本地用户信息是否有效
     *
     * @return
     */
    public boolean isAccountValid() {
        OAuthBean account = getAccount();
        return account != null && account.getCode() == Constants.NET_SUCCESS;
    }

    public void setAliAuthCode(String aliAuthCode) {
        accountSp.edit().putString(ALI_AUTH_CODE, aliAuthCode).apply();
    }

    /**
     * 是否存在阿里认证信息
     */
    public boolean haveAliAuth() {
        return !TextUtils.isEmpty(accountSp.getString(ALI_AUTH_CODE, ""));
    }

    public void clear() {
        LogUtil.i("clear: ");
        sOAuthBean = null;
        accountKv.remove(ACCOUNTINFO);
        accountKv.remove(USER_INFO);
        accountKv.async();
        accountSp.edit()
                .remove(ACCOUNTINFO)
                .remove(USER_INFO)
                .remove(ALI_AUTH_CODE)
                .apply();
        PrivacyPolicyHelper.INSTANCE.clearPrivacyMMkv();
    }

    public void clearAll() {
        LogUtil.i("clearAll: ");
        clear();
        clearLoginAccount();
    }

    /**
     * 清空登录账号
     */
    public void clearLoginAccount() {
        accountKv.remove(LOGIN_ACCOUNT);
        accountSp.edit().remove(LOGIN_ACCOUNT).commit();
    }

    public boolean isFirstLogin() {
        boolean isFirstLogin = accountKv.decodeBool(USER_IS_FIRST_LOGIN, true);
        boolean androidSpFirstLogin = accountSp.getBoolean(USER_IS_FIRST_LOGIN, true);
        return isFirstLogin && androidSpFirstLogin;
    }

    public void putIsFirstLogin() {
        accountKv.edit().putBoolean(USER_IS_FIRST_LOGIN, false).apply();
        accountSp.edit().putBoolean(USER_IS_FIRST_LOGIN, false).apply();
    }

    public boolean readHomePermission() {
        int homePermissionFirst = accountKv.decodeInt("home_permission_first", 0);
        if (homePermissionFirst == 0) {
            accountKv.encode("home_permission_first", 1);
        }
        return homePermissionFirst != 0;
    }

    public interface AccountChangedCallback {
        void onAuthBeanChanged(OAuthBean oAuthBean);
    }
}


