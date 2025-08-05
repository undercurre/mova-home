package android.dreame.module.data.network.interceptor;

import android.dreame.module.LocalApplication;
import android.dreame.module.RouteServiceProvider;
import android.dreame.module.bean.OAuthBean;
import android.dreame.module.constant.Constants;
import android.dreame.module.data.network.service.DreameService;
import android.dreame.module.manager.AccountManager;
import android.dreame.module.trace.EventCommonHelper;
import android.dreame.module.trace.ExceptionStatisticsEventCode;
import android.dreame.module.trace.ModuleCode;
import android.dreame.module.util.ActivityUtil;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.alify.AliAuthHelper;
import android.os.SystemClock;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dreame.module.service.app.flutter.IFlutterBridgeService;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class TokenInterceptor implements Interceptor {

    private static final String TAG = TokenInterceptor.class.getSimpleName();
    private static volatile long lastRefreshTime = 0;
    private final static Object lock = new Object();

    @NonNull
    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();
        String requestPath = request.url().url().getPath();
        Response response = preCheckTokenAndFix(chain);
        if (response != null) {
            return response;
        }

        response = chain.proceed(request);
        byte[] bytes = response.body().bytes().clone();
        String resp = new String(bytes);
        if (isTokenExpired(response.code(), resp)) {
            LogUtil.e(TAG, "Token失效,resp:" + resp + ", url:" + requestPath);
            // 同步请求方式，获取最新的Token
            OAuthBean oAuthBean = refreshToken();
            if (oAuthBean == null) {
                LogUtil.e(TAG, "刷新token失败，退出登录");
                // 有前台页面则，需要重新登录
                if (ActivityUtil.getInstance().getCurrentActivity() != null) {
                    startLoginActivity();
                }
            } else {
                // 新增:网络错误时,不再退出
                if (oAuthBean.getCode() == Constants.NET_ERROR) {
                    return chain.proceed(request);
                }
                // 使用新的Token，创建新的请求
                if (!TextUtils.isEmpty(oAuthBean.getAccess_token())) {
                    Request newRequest = createNewRequest(request, oAuthBean.getAccess_token());
                    AliAuthHelper.INSTANCE.aliAuth(null, null);
                    return chain.proceed(newRequest);
                }
            }
        }
        Response.Builder builder = response.newBuilder();
        Response clone = builder.build();
        ResponseBody body = clone.body();
        MediaType mediaType = body.contentType();
        body = ResponseBody.create(mediaType, bytes);
        return response.newBuilder()
                .body(body)
                .build();
    }

    /**
     * 1. 检验token有效期,[10,0)分钟主动刷新token
     * 2. 更新本地token
     * 3. 使用新token继续请求
     * 4. 刷新失败不做处理,继续请求
     */
    @Nullable
    private Response preCheckTokenAndFix(Chain chain) {
        synchronized (lock) {
            Request request = chain.request();
            String requestPath = request.url().url().getPath();
            long currentTime = System.currentTimeMillis() / 1000;
            long expiresTime = AccountManager.getInstance().getAccount().getExpiresTime();
            long tokenTimeGap = expiresTime - currentTime;
            if (tokenTimeGap <= 10 * 60 && tokenTimeGap > 0) {
                LogUtil.d(TAG, "Token即将失效，刷新Token timeGap: " + tokenTimeGap + ", url:" + requestPath);
                try {
                    String refreshToken = AccountManager.getInstance().getAccount().getRefresh_token();
                    OAuthBean oAuthBean = requestAccessToken(refreshToken);
                    if (oAuthBean != null) {
                        Request newRequest = createNewRequest(request, oAuthBean.getAccess_token());
                        AliAuthHelper.INSTANCE.aliAuth(null, null);
                        return chain.proceed(newRequest);
                    }
                } catch (Exception e) {
                    LogUtil.e(TAG, "preCheckTokenAndFix 失败: " + e.getMessage());
                }
            }
            return null;
        }
    }

    @NonNull
    private Request createNewRequest(Request request, String accessToken) {
        return request.newBuilder()
                .removeHeader("Dreame-Auth")
                .addHeader("Dreame-Auth", accessToken)
                .build();
    }

    /**
     * 根据Response，判断Token以及RefreshToken是否失效
     *
     * @param resp
     * @return
     */
    private boolean isTokenExpired(int code, String resp) {
        if (code == 401) {
            try {
                JSONObject resObject = new JSONObject(resp);
                if (resObject.has("code")) { // Token失效
                    if (resObject.getInt("code") == 401) {
                        return true;
                    }
                } else {  // refresh_token失效,退出登录
                    LogUtil.i(TAG, "refresh_token失效,退出登录 resp:" + resp);
                    AccountManager.getInstance().clear();
                    return false;
                }
            } catch (JSONException e) {
                Log.e(TAG, "isTokenExpired: " + e);
                return false;
            }
        }
        return false;
    }

    /**
     * 请求接口刷新Token
     *
     * @throws Exception
     */
    private OAuthBean requestAccessToken(String refreshToken) throws Exception {
        Map<String, String> map = new HashMap<>();
        map.put("grant_type", "refresh_token");
        map.put("refresh_token", refreshToken);
        Call<OAuthBean> tokenCall = DreameService.INSTANCE.refreshAccessToken(LocalApplication.getInstance().getTenantId(), map);
        OAuthBean oAuthBean = tokenCall.execute().body();
        if (oAuthBean == null) {
            LogUtil.e(TAG, "刷新token失败，接口返回错误");
            return null;
        }
        AccountManager.getInstance().setAccount(oAuthBean);
        lastRefreshTime = System.currentTimeMillis();
        LogUtil.i(TAG, "刷新token成功，新Token: " + oAuthBean.getAccess_token());
        return oAuthBean;
    }

    @Nullable
    private OAuthBean refreshToken() {
        synchronized (lock) {
            IFlutterBridgeService flutterBridgeService = RouteServiceProvider.INSTANCE.getService(IFlutterBridgeService.class);
            OAuthBean account = AccountManager.getInstance().getAccount();
            // account 被清空，或者refresh_token为空不再刷新token
            if (account == null || TextUtils.isEmpty(account.getRefresh_token())) {
                LogUtil.e(TAG, "refreshToken: account is null or refresh_token is empty" + new Gson().toJson(account));
                EventCommonHelper.INSTANCE.eventCommonPageInsert(100, 9, 0, "", "", 0, 0, 0, 0, 0, "", "", "", "原生刷新token失败,account is null or refresh_token is empty");
                if (flutterBridgeService != null) {
                    flutterBridgeService.tokenExpired();
                }
                return null;
            }
            long currentTime = System.currentTimeMillis();
            if (currentTime - lastRefreshTime < 1000) {
                LogUtil.i(TAG, "1s 内不必重新刷新token: " + account.getAccess_token());
                lastRefreshTime = currentTime;
                return account;
            }
            if (flutterBridgeService != null) {
                flutterBridgeService.tokenExpired();
            }
            try {
                OAuthBean oAuthBean = requestAccessToken(account.getRefresh_token());
                if (flutterBridgeService != null) {
                    flutterBridgeService.refreshTokenSuccess();
                }
                return oAuthBean;
            } catch (UnknownHostException | SocketTimeoutException | SocketException e) {
                EventCommonHelper.INSTANCE.eventCommonPageInsert(100, 9, 0, "", "", 0, 0, 0, 0, 0, "", "", "", "原生刷新token失败,网络错误error:" + e.getMessage());
                return new OAuthBean(Constants.NET_ERROR, "error");
            } catch (Exception e) {
                e.printStackTrace();
                EventCommonHelper.INSTANCE.eventCommonPageInsert(100, 9, 0, "", "", 0, 0, 0, 0, 0, "", "", "", "原生刷新token失败,error:" + e.getMessage());
                LogUtil.e(TAG, "refreshToken: error: " + Log.getStackTraceString(e));
            }
            return null;
        }
    }

    /**
     * 跳转登录界面，重新登录
     */
    private long time = 0;
    private static final long INTERVAL_TIME = 10 * 1000;

    private void startLoginActivity() {
        EventCommonHelper.INSTANCE.eventCommonPageInsert(ModuleCode.ExceptionStatistics.getCode(), ExceptionStatisticsEventCode.LoginAgain.getCode(),
                0, 0, 1, 0, 0, 0);
        if (SystemClock.elapsedRealtime() - time > INTERVAL_TIME) {
            LocalApplication.getInstance().startLoginActivity();
            time = SystemClock.elapsedRealtime();
        }
    }
}
