package android.dreame.module.rn.net;

import android.dreame.module.data.network.service.ServiceCreator;
import android.dreame.module.task.RetrofitInitTask;
import android.dreame.module.util.GsonUtils;
import android.dreame.module.util.RequestParamsUtil;
import android.net.Uri;
import android.text.TextUtils;

import org.json.JSONObject;

import java.io.IOException;
import java.util.Map;

import okhttp3.Call;
import okhttp3.FormBody;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

public class RNNetRequest {
    private static final OkHttpClient mOkHttpClient = ServiceCreator.INSTANCE.getHttpClient();

    public enum TYPE {
        POST,
        GET,
        DELETE,
        PUT
    }

    public static void request(String interfaceName, RNNetRequest.TYPE type, String params, RNNetRequestCallBack requestCallBack) {
        request(interfaceName, type, params, null, requestCallBack);
    }

    public static void request(String interfaceName, RNNetRequest.TYPE type, String params, String headers, RNNetRequestCallBack requestCallBack) {
        if (isNeedAppendBaseUrl(interfaceName)) {
            try {
                JSONObject jsonObject = new JSONObject(params);
                jsonObject.put("host", RetrofitInitTask.getBaseUrl());
                params = jsonObject.toString();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        RequestBody requestBody = TextUtils.isEmpty(params) ? null : RequestBody.create(MediaType.parse("application/json"), RequestParamsUtil.signParams(params));
        request(interfaceName, type, requestBody, headers, requestCallBack);
    }

    public static void request(String interfaceName, RNNetRequest.TYPE type, RequestBody requestBody, RNNetRequestCallBack requestCallBack) {
        request(interfaceName, type, requestBody, null, requestCallBack);
    }

    public static void request(String interfaceName, RNNetRequest.TYPE type, RequestBody requestBody, String headers, RNNetRequestCallBack requestCallBack) {
        String url = RetrofitInitTask.getBaseUrl() + interfaceName;
        if (isNeedAppendBaseUrl(interfaceName)) {
            url = interfaceName;
        }
        Request request = null;
        Request.Builder builder = new Request.Builder().url(url);
        /// 添加Headers
        if (headers != null) {
            Map<String, Object> headerMaps = GsonUtils.parseMaps(headers);
            for (Map.Entry<String, Object> entry : headerMaps.entrySet()) {
                builder.addHeader(entry.getKey(), entry.getValue().toString()).build();
            }
        }

        if (type == TYPE.POST) {
            request = builder.post(requestBody).build();
        } else if (type == TYPE.PUT) {
            request = builder.put(requestBody).build();
        } else {
            request = builder.get().build();
        }
        Call call = mOkHttpClient.newCall(request);
        call.enqueue(requestCallBack);
    }

    public static void uploadFile(String uploadUrl, RNNetRequest.TYPE type, RequestBody requestBody, RNNetRequestCallBack requestCallBack) {
        String url = RetrofitInitTask.getBaseUrl() + uploadUrl;
        if (uploadUrl.startsWith("http") || uploadUrl.startsWith("https")) {
            url = uploadUrl;
        }
        Request.Builder builder = new Request.Builder().url(url);
        Request request;
        if (type == TYPE.PUT) {
            request = builder.put(requestBody).build();
        } else {
            request = builder.post(requestBody).build();
        }
        Call call = mOkHttpClient.newCall(request);
        call.enqueue(requestCallBack);
    }

    private static boolean isNeedAppendBaseUrl(String interfaceName) {
        return (interfaceName.startsWith("http") || interfaceName.startsWith("https")) && Uri.parse(interfaceName).getHost().endsWith("mova-tech.com");
    }

    public static void request(String interfaceName, FormBody formBody, RNNetRequestCallBack requestCallBack) {
        String url = RetrofitInitTask.getBaseUrl() + interfaceName;
        Request request = new Request.Builder()
                .url(url)
                .post(formBody)
                .build();
        Call call = mOkHttpClient.newCall(request);
        call.enqueue(requestCallBack);
    }

    public static String requestPostSync2(String interfaceName, String params) throws IOException {
        String url = RetrofitInitTask.getBaseUrl() + interfaceName;
        if (isNeedAppendBaseUrl(interfaceName)) {
            url = interfaceName;
        }
        RequestBody requestBody = TextUtils.isEmpty(params) ? null : RequestBody.create(RequestParamsUtil.signParams(params), MediaType.parse("application/json"));
        Request request = new Request.Builder().url(url)
                .method("POST", requestBody).build();
        return execSync2(request);
    }

    public static String execSync2(Request request) throws IOException {
        Call call = mOkHttpClient.newCall(request);
        Response response = call.execute();
        if (response.isSuccessful()) {
            ResponseBody body = response.body();
            return body.string();
        } else {
            return null;
        }

    }
}
