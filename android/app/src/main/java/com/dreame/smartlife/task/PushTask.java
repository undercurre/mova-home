package com.dreame.smartlife.task;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.dreame.module.LocalApplication;
import android.dreame.module.RoutPath;
import android.dreame.module.RouteServiceProvider;
import android.dreame.module.manager.AccountManager;
import android.dreame.module.task.RunInstantTask;
import android.dreame.module.util.DeviceIdUtil;
import android.dreame.module.util.LogUtil;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

;
import com.dreame.module.service.app.flutter.IFlutterBridgeService;
import com.dreame.smartlife.common.IMessageHandler;
import com.dreame.smartlife.common.IPushLogger;
import com.dreame.smartlife.service.push.PushManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * @ClassName: PushTask
 * @Author: sunzhibin
 * @Email: sunzhibin@dreame.tech
 * @CreateDate: 9.8.21 3:29 下午
 * @Description: 推送回调处理
 * @UpdateRemark: 更新说明：
 * @UpdateDate:
 * @Version: 1.0
 */
public class PushTask extends RunInstantTask {

    private static final String TAG = PushTask.class.getSimpleName();

    public PushTask(@NonNull String id) {
        super(id, false);
    }

    public PushTask(@NonNull String id, boolean isAsyncTask) {
        super(id, isAsyncTask);
    }

    @Override
    protected void run(@NonNull String s) {
        setCallback();
    }

    public void setCallback() {
        PushManager.INSTANCE.setLogEnable(true);
        PushManager.INSTANCE.setLogger(new IPushLogger() {
            @Override
            public void log(@NonNull String tag, @NonNull String s1) {
                Log.i(tag, "pushLog," + s1);
            }

            @Override
            public void log(@NonNull String tag, @NonNull String s1, @Nullable Throwable throwable) {
                Log.e(tag, "pushLog," + s1 + "," + Log.getStackTraceString(throwable));
            }
        });
        PushManager.INSTANCE.setMessageHandler(new IMessageHandler() {
            @Override
            public void onPassThroughMessageArrived(@Nullable Context context, @Nullable String s, @Nullable String s1, @NonNull Map<String, ?> map) {
                Log.i(TAG, "onPassThroughMessageArrived: " + s + "," + s1);
            }

            @Override
            public void onNotificationMessageArrived(@Nullable Context context, @Nullable String s, @Nullable String s1, @NonNull Map<String, ?> map) {
                Log.i(TAG, "onNotificationMessageArrived: " + s + "," + s1);
            }

            @Override
            public boolean onNotificationMessageClicked(@Nullable Context context, @Nullable String s, @Nullable String s1, @NonNull Map<String, ?> map) {
                Log.i(TAG, "onNotificationMessageClicked: " + s + "," + s1);
                return handleNotificationClick(context, map);
            }
        });
        PushManager.INSTANCE.setOnNewDeviceTokenCallBack(deviceToken -> {
            boolean isAccountValid = AccountManager.getInstance().isAccountValid();
            LogUtil.i("PushTask", "onNewDeviceTokenCallBack:" + deviceToken + ",isAccountValid:" + isAccountValid);
            if (isAccountValid) {
                Map<String, String> params = new HashMap<>();
                params.put("token", deviceToken.getToken());
                params.put("tokenType", deviceToken.getTokenType());
                params.put("deviceUUID", DeviceIdUtil.INSTANCE.getDeviceId(LocalApplication.getInstance()));
                IFlutterBridgeService service = RouteServiceProvider.getService(IFlutterBridgeService.class);
                service.refreshPushToken(params);
            }
            return null;
        });
    }

    private boolean handleNotificationClick(Context context, Map<String, ?> map) {
        for (Map.Entry<String, ?> stringEntry : map.entrySet()) {
            Log.i(TAG, "handleNotificationClick: " + stringEntry.getKey() + "=" + stringEntry.getValue());
        }
        if (!isMsgCurrentAccount(map)) {
            return true;
        }

        try {
            String scheme = (String) map.get("scheme");

            if (!TextUtils.isEmpty(scheme)) {
                Uri uri = Uri.parse(scheme);
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                intent.setPackage(context.getPackageName());
                if (intent.resolveActivity(context.getPackageManager()) != null) {
                    if (!(context instanceof Activity)) {
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    }
                    context.startActivity(intent);
                    return true;
                }
                return false;
            }
            return false;

        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return false;

    }

    /**
     * 判断是否是当前账号
     *
     * @return
     */
    private boolean isMsgCurrentAccount(Map<String, ?> paramMap) {
        if (isAllScopeMsg(paramMap)) {
            return true;
        }
        String uid = (String) paramMap.get("uid");
        if (!TextUtils.isEmpty(uid)) {
            return isMsgCurrentAccount2(uid);
        } else {
            return isMsgCurrentAccount((String) paramMap.get("body"));
        }


    }


    private boolean isMsgCurrentAccount(String msgBody) {
        if (!TextUtils.isEmpty(msgBody) && AccountManager.getInstance().getAccount() != null) {
            try {
                JSONObject jsonObject = new JSONObject(msgBody);
                String uid = jsonObject.optString("uid");
                String currentUid = AccountManager.getInstance().getAccount().getUid();
                if (TextUtils.equals(uid, currentUid)) {
                    return true;
                }
                LogUtil.i("msg is arrived: uid: " + uid + " currentUid: " + currentUid);
            } catch (JSONException e) {
                e.printStackTrace();
                return true;
            }
        }
        return false;
    }


    private static boolean isAllScopeMsg(Map<String, ?> paramMap) {
        String pushScope = (String) paramMap.get("push_scope");
        return "ALL".equals(pushScope);
    }

    private boolean isMsgCurrentAccount2(String uid) {
        if (AccountManager.getInstance().getAccount() != null) {
            String currentUid = AccountManager.getInstance().getAccount().getUid();
            if (TextUtils.equals(uid, currentUid)) {
                return true;
            }
            LogUtil.i("msg is arrived2: uid: " + uid + " currentUid: " + currentUid);
        }
        return false;
    }

}
