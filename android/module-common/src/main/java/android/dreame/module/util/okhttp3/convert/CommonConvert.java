package android.dreame.module.util.okhttp3.convert;

import android.dreame.module.LocalApplication;
import android.dreame.module.R;
import android.dreame.module.bean.BaseHttpResult;
import android.dreame.module.constant.Constants;
import android.dreame.module.util.ActivityUtil;
import android.util.Log;

import androidx.annotation.StringRes;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.net.UnknownServiceException;

import okhttp3.internal.connection.RouteException;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/4/22 11:27
 * @Version: 1.0
 */
public class CommonConvert {

    /**
     * http code 200 包含 errorCode
     *
     * @param result
     * @return
     */
    public static <T> BaseHttpResult<T> convertCommonCodeResult(BaseHttpResult<T> result) {
        if (result.getCode() != Constants.NET_SUCCESS) {
            // 处理message
            switch (result.getCode()) {
                case ErrorCode.CODE_BUSINESS:
                case ErrorCode.CODE_HTTP_BODY_ERROR:
                case ErrorCode.CODE_HTTP_METHOD_ERROR:
                case ErrorCode.CODE_HTTP_CONTENT_TYPE_ERROR:
                case ErrorCode.CODE_HTTP_OTHER_ERROR:
                case ErrorCode.CODE_SERVER_ERROR:
                    result.setMsg(getString(R.string.toast_server_error));
                    break;
                case ErrorCode.CODE_PARAM_LESS_ERROR:
                case ErrorCode.CODE_PARAM_TYPE_ERROR:
                case ErrorCode.CODE_PARAM_BIND_ERROR:
                case ErrorCode.CODE_PARAM_CHECK_ERROR:
                case ErrorCode.CODE_PARAM_OTHER_ERROR:
                    result.setMsg(getString(R.string.toast_param_error));
                    break;
                case ErrorCode.CODE_TENANT_LESS_ERROR:
                    result.setMsg(getString(R.string.toast_tenant_error));
                    break;
                case ErrorCode.CODE_TENANT_NOT_EXIST_ERROR:
                    result.setMsg(getString(R.string.toast_tenant_error));
                    break;
                case ErrorCode.CODE_TENANT_NO_PERMISSION_ERROR:
                    result.setMsg(getString(R.string.toast_tenant_no_permission));
                    break;
                case ErrorCode.CODE_SIGN_NOT_PASS_ERROR:
                case ErrorCode.CODE_SIGN_TIMESTAMP_ERROR:
                    result.setMsg(getString(R.string.toast_sign_error));
                    break;

                case ErrorCode.CODE_DEVICE_NO_USER_ERROR:
                case ErrorCode.CODE_USER_NOT_EXIST:
                    LocalApplication.getInstance().startLoginActivity();
                    break;
                case ErrorCode.CODE_BIND_OTHER_ACCOUNT:
                    break; 
                default:
                    result.setMsg(getString(R.string.toast_net_error));
                    break;
            }
        }
        return result;
    }

    /**
     * http code 400 包含 errorBody
     *
     * @param json
     * @return
     */
    public static BaseHttpResult<Boolean> convertCommonErrorBodyResult(String json) {
        if (json == null || json.length() == 0) {
            return new BaseHttpResult<>(Constants.NET_ERROR, null);
        }
        JSONObject jsonObject = null;
        try {
            jsonObject = new JSONObject(json);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        if (jsonObject == null) {
            return new BaseHttpResult<>(Constants.NET_ERROR, null);
        }
        int code = jsonObject.optInt("code", Constants.NET_ERROR);
        String msg = jsonObject.optString("msg");
        return new BaseHttpResult<>(code, msg);
    }


    /**
     * convert error信息
     */
    public static String convertErrorResult(Throwable t) {
        if (t instanceof UnknownHostException || t instanceof SocketTimeoutException
                || t instanceof ConnectException || t instanceof RouteException) {
            return getString(R.string.toast_net_error);
        }
        if (t instanceof UnknownServiceException) {
            return getString(R.string.toast_net_error);
        }
        return getString(R.string.toast_common_error);
    }

    public static String getString(@StringRes int stringId) {
        try {
            if (ActivityUtil.getInstance().getCurrentActivity() != null) {
                return ActivityUtil.getInstance().getCurrentActivity().getString(stringId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("CommonConvert", Log.getStackTraceString(e));
        }
        return "";
    }
}
