package android.dreame.module.util;

import android.dreame.module.LocalApplication;

import java.io.File;
import java.net.Proxy;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.logging.HttpLoggingInterceptor;

public class FileUploadUtils {
    private static final long DEFAULT_TIMEOUT = 10000;
    private static OkHttpClient mOkHttpClient;

    static {
        HttpLoggingInterceptor logging = new HttpLoggingInterceptor(message -> LogUtil.i("MOVAhome okhttp", message));
        logging.setLevel(LocalApplication.isLogHttpBODY ? HttpLoggingInterceptor.Level.BODY : HttpLoggingInterceptor.Level.BASIC);
        mOkHttpClient = new OkHttpClient.Builder()
                .addInterceptor(logging)
                .connectTimeout(DEFAULT_TIMEOUT, TimeUnit.MILLISECONDS)
                .writeTimeout(DEFAULT_TIMEOUT, TimeUnit.MILLISECONDS)
                .readTimeout(DEFAULT_TIMEOUT, TimeUnit.MILLISECONDS)
                .proxy(Proxy.NO_PROXY)
                .build();
    }

    public static Response upload(String url, String fileName, File file) throws Exception {
        RequestBody requestBody = RequestBody.create(file, null);
        Request request = new Request.Builder()
                .url(url)
                .put(requestBody)
                .build();
        return mOkHttpClient.newCall(request).execute();
    }

    public static Response upload(String url, String fileName, byte[] file) throws Exception {
        RequestBody requestBody = RequestBody.create(file, null);
        Request request = new Request.Builder()
                .url(url)
                .put(requestBody)
                .build();
        return mOkHttpClient.newCall(request).execute();
    }
}
