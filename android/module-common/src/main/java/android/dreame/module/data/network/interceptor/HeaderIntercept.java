package android.dreame.module.data.network.interceptor;

import android.dreame.module.BuildConfig;
import android.dreame.module.LocalApplication;
import android.dreame.module.bean.OAuthBean;
import android.dreame.module.manager.AccountManager;
import android.dreame.module.manager.AreaManager;
import android.dreame.module.manager.LanguageManager;
import android.dreame.module.util.LogUtil;
import android.text.TextUtils;

import com.blankj.utilcode.util.EncodeUtils;
import com.blankj.utilcode.util.EncryptUtils;
import com.dreame.hacklibrary.HackJniHelper;

import java.io.IOException;

import okhttp3.HttpUrl;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

/**
 * Created by maqing on 2020/11/10.
 * Email:2856992713@qq.com
 */
public class HeaderIntercept implements Interceptor {
    private static final String TAG = HeaderIntercept.class.getSimpleName();
    // gigxlmqwZ]7oWZUF
    final static byte[] encrypts = {103, 105, 103, 120, 108, 109, 113, 119, 90, 93, 55, 111, 87, 90, 85, 70};

    @Override
    public Response intercept(Chain chain) throws IOException {
        //获取request
        Request request = chain.request();
        //从request中获取原有的HttpUrl实例oldHttpUrl
        HttpUrl oldHttpUrl = request.url();
        //获取request的创建者builder
        Request.Builder builder = request.newBuilder();
        builder.addHeader("Authorization", "Basic " + HackJniHelper.getAuthorizationByType(0));
        //添加Token 请求头
        OAuthBean oAuthBean = AccountManager.getInstance().getAccount();
        if (oAuthBean != null && !TextUtils.isEmpty(oAuthBean.getAccess_token())) {
            LogUtil.i(TAG, "addHeader : " + oAuthBean.getAccess_token());
            builder.addHeader("Dreame-Auth", oAuthBean.getAccess_token());
            // pluginTag
            long timeMillis = System.currentTimeMillis();
            String pluginTag = oAuthBean.getUid() + "|" + timeMillis + "%" + oAuthBean.getDomain();
            pluginTag = EncryptUtils.encryptAES2HexString(
                    pluginTag.getBytes(),
                    encrypts,
                    "AES/GCM/NoPadding", encrypts);
            builder.addHeader("p-tag", pluginTag + "|" + EncodeUtils.base64Encode2String(String.valueOf(timeMillis).getBytes()));
        }
        builder.addHeader("Tenant-Id", LocalApplication.getInstance().getTenantId());
        String rlcHeader = rlcHeader();
        if (!TextUtils.isEmpty(rlcHeader)) {
            builder.addHeader("Dreame-RLC", rlcHeader);
        }
        builder.addHeader("dreame-meta", "cv=a_" + BuildConfig.APP_VERSION_CODE);
        Request newRequest = builder.build();
        return chain.proceed(newRequest);
    }

    /**
     * 计算 在header 拼接Dreame-RLC （RLC = region-language-country,首字母缩写）
     * see https://wiki.dreame.tech/pages/viewpage.action?pageId=56199892
     *
     * @return
     */
    public static String rlcHeader() {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(AreaManager.getRegion()).append("|")
                .append(LanguageManager.getInstance().getLangTag(LocalApplication.getInstance())).append("|")
                .append(AreaManager.getCountryCode());
        String encryptAES = EncryptUtils.encryptAES2HexString(
                stringBuilder.toString().getBytes(),
                encrypts,
                "AES/GCM/NoPadding", encrypts);
        return encryptAES + "-1";
    }
}
