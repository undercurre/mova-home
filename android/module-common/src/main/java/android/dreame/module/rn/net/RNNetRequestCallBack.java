package android.dreame.module.rn.net;

import android.dreame.module.data.network.ErrorCode;
import android.os.Handler;
import android.os.Looper;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

public abstract class RNNetRequestCallBack implements Callback {
    public static final int CODE_SUCCESS = 0;
    public static final String KEY_MSG = "msg";
    public static final String KEY_CODE = "code";
    public static final String KEY_DATA = "data";
    public static final int CODE_ERROR = -1;
    private Handler mUiHandler = new Handler(Looper.getMainLooper());

    @Override
    public void onResponse(Call call, Response response) throws IOException {
        String responseStr = response.body().string();
        if (response.code() == 200) {
            mUiHandler.post(() -> {
                onSuccess(responseStr, response);
            });
        } else {
            mUiHandler.post(() -> onError(CODE_ERROR, responseStr));
        }
    }

    @Override
    public void onFailure(Call call, IOException e) {
        JSONObject responseObject = new JSONObject();
        try {
            responseObject.put(KEY_CODE, ErrorCode.REQUEST_ERROR);
            responseObject.put(KEY_MSG, e.getMessage());
        } catch (JSONException error) {
            error.printStackTrace();
        }
        mUiHandler.post(() -> onError(CODE_ERROR, responseObject.toString()));
    }

    public  void onSuccess(String responseStr){};

    public void onSuccess(String responseStr, Response response) {
        onSuccess(responseStr);
    }

    public abstract void onError(int code, String error);

}
