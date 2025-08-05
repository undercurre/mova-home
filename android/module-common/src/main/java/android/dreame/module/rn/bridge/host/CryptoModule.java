package android.dreame.module.rn.bridge.host;

import android.annotation.SuppressLint;
import android.dreame.module.rn.utils.Crypto;
import android.dreame.module.util.MD5Util;
import android.text.TextUtils;
import android.util.Base64;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import org.json.JSONObject;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.schedulers.Schedulers;

public class CryptoModule extends ReactContextBaseJavaModule {
    Crypto crypto;

    public CryptoModule(@Nullable ReactApplicationContext reactContext) {
        super(reactContext);
        crypto = new Crypto();
    }

    @NonNull
    @Override
    public String getName() {
        return "crypto";
    }

    @SuppressLint("CheckResult")
    @ReactMethod
    public void zhuimiRobotTracesToImageBase64(int width, int height, String params, Promise promise) {
        Observable.just(params)
                .map(s -> crypto.createTracesImageBase64(width, height, params))
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(s -> promise.resolve(s), throwable -> promise.reject(throwable));
    }

    @SuppressLint("CheckResult")
    @ReactMethod
    public void pointsToImageBase64(int width, int height, String pointStr, String colorStr, Promise promise) {
        Observable.just(pointStr)
                .map(s -> crypto.pointsToImageBase64(width, height, pointStr, colorStr))
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(s -> promise.resolve(s), throwable -> promise.reject(throwable));
    }

    @ReactMethod
    public void encodeMD5(String content, Promise promise) {
        promise.resolve(MD5Util.getMD5Str(content));
    }

    @ReactMethod
    public void encodeSHA256(String content, Promise promise) {
        promise.resolve(MD5Util.getSHA256Str(content));
    }

    @ReactMethod
    public void encryptRSA(String key, String content, Promise promise) {
        if (TextUtils.isEmpty(key) || TextUtils.isEmpty(content)) {
            promise.reject("-1", "key or content is null");
            return;
        }
        key = extraKey(key, false);
        final byte[] publicKey = Base64.decode(key, Base64.NO_WRAP);
        final byte[] data = Base64.decode(content, Base64.NO_WRAP);

        try {
            RSAPublicKey pubKey = (RSAPublicKey) KeyFactory.getInstance("RSA").generatePublic(new X509EncodedKeySpec(publicKey));
            //RSA加密
            Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPPadding");
            cipher.init(Cipher.ENCRYPT_MODE, pubKey);
            final byte[] bytes = cipher.doFinal(data);

            final String encode = Base64.encodeToString(bytes, Base64.NO_WRAP);
            promise.resolve(encode);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject("-1", "content encrypt error");
        }

    }

    @ReactMethod
    public void decryptRSA(String key, String content, Promise promise) {
        if (TextUtils.isEmpty(key) || TextUtils.isEmpty(content)) {
            promise.reject("-1", "key or content is null");
            return;
        }
        key = extraKey(key, true);
        final byte[] priKey = Base64.decode(key, Base64.NO_WRAP);
        final byte[] data = Base64.decode(content, Base64.NO_WRAP);
        try {
            RSAPrivateKey privateKey = (RSAPrivateKey) KeyFactory.getInstance("RSA").generatePrivate(new PKCS8EncodedKeySpec(priKey));
            //RSA解密
            Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPPadding");
            cipher.init(Cipher.DECRYPT_MODE, privateKey);
            final byte[] bytes = cipher.doFinal(data);
            final String encode = Base64.encodeToString(bytes, Base64.NO_WRAP);
            promise.resolve(encode);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject("-1", "content decrypt error");
        }

    }

    @ReactMethod
    public void generateRSAKeyPair(Promise promise) {
        try {
            KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
            keyGen.initialize(1024);
            final KeyPair keyPair = keyGen.genKeyPair();
            byte[] publicKey = keyPair.getPublic().getEncoded();
            byte[] privateKey = keyPair.getPrivate().getEncoded();

            JSONObject jsonObject = new JSONObject();
            jsonObject.put("publicKey", Base64.encodeToString(publicKey, Base64.NO_WRAP));
            jsonObject.put("privateKey", Base64.encodeToString(privateKey, Base64.NO_WRAP));
            jsonObject.put("code", 0);
            jsonObject.put("msg", "success");
            promise.resolve(jsonObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject("-1", e.getMessage());
        }

    }

    /**
     * 剔出key文件中存在的 头/尾描述
     * @param key
     * @param isPrivateKey
     * @return
     */
    @NonNull
    private String extraKey(String key, boolean isPrivateKey) {
        String rsaPrefix1 = "";
        String rsaPrefix2 = "";
        String rsaSubffix1 = "";
        String rsaSubffix2 = "";
        if (isPrivateKey) {
            rsaPrefix1 = "-----BEGIN RSA PRIVATE KEY-----";
            rsaSubffix1 = "-----END RSA PRIVATE KEY-----";
            rsaPrefix2 = "-----BEGIN PRIVATE KEY-----";
            rsaSubffix2 = "-----END PRIVATE KEY-----";
        } else {
            rsaPrefix1 = "-----BEGIN RSA PUBLIC KEY-----";
            rsaSubffix1 = "-----END RSA PUBLIC KEY-----";

            rsaPrefix2 = "-----BEGIN PUBLIC KEY-----";
            rsaSubffix2 = "-----END PUBLIC KEY-----";
        }

        int index = key.indexOf(rsaPrefix1);
        if (index != -1) {
            key = key.replace("\n", "").replace("\r", "");
            key = key.substring(index + rsaPrefix1.length());

            index = key.indexOf(rsaSubffix1);
            if (index != -1) {
                key = key.substring(0, index);
            }
        } else if ((index = key.indexOf(rsaPrefix2)) != -1) {
            key = key.replace("\n", "").replace("\r", "");
            key = key.substring(index + rsaPrefix2.length());

            index = key.indexOf(rsaSubffix2);
            if (index != -1) {
                key = key.substring(0, index);
            }
        }
        return key;
    }


}
