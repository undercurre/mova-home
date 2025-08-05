package android.dreame.module.util;

import com.coremedia.iso.Hex;

import java.io.File;
import java.io.FileInputStream;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Created by licrynoob on 2016/guide_2/25 <br>
 * Copyright (C) 2016 <br>
 * Email:licrynoob@gmail.com <p>
 * MD5加密
 */
public class MD5Util {
    /**
     * @param param 参数
     * @return 加密值
     */
    public static String getMD5Str(String param) {
        MessageDigest messageDigest = null;
        try {
            messageDigest = MessageDigest.getInstance("MD5");
            messageDigest.reset();
            messageDigest.update(param.getBytes("UTF-8"));
        } catch (NoSuchAlgorithmException e) {
            System.out.println("NoSuchAlgorithmException caught!");
            System.exit(-1);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        byte[] byteArray = messageDigest.digest();
        StringBuilder md5StrBuff = new StringBuilder();
        for (byte aByteArray : byteArray) {
            if (Integer.toHexString(0xFF & aByteArray).length() == 1)
                md5StrBuff.append("0").append(Integer.toHexString(0xFF & aByteArray));
            else
                md5StrBuff.append(Integer.toHexString(0xFF & aByteArray));
        }
        return md5StrBuff.toString();
    }

    public static String getSHA256Str(String param){
        MessageDigest messageDigest;
        String encodeStr ="";
        try {
            messageDigest= MessageDigest.getInstance("SHA-256");
            byte[] hash = messageDigest.digest(param.getBytes("UTF-8"));
            StringBuilder sha256StrBuff = new StringBuilder();
            for (byte byteArray : hash) {
                String hex = Integer.toHexString(0xFF & byteArray);
                if (hex.length() == 1) {
                    sha256StrBuff.append('0');
                }
                sha256StrBuff.append(hex);
            }
            encodeStr = sha256StrBuff.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return encodeStr;
    }

    public static String getFileMD5(File file) {
        return getFileMD5(file, 64 * 1024);
    }

    public static String getFileMD5(File file, int size) {
        if (!file.isFile()) {
            return null;
        }
        MessageDigest digest = null;
        FileInputStream in = null;
        byte buffer[] = new byte[size];
        int len;
        try {
            digest = MessageDigest.getInstance("MD5");
            in = new FileInputStream(file);
            while ((len = in.read(buffer, 0, size)) != -1) {
                digest.update(buffer, 0, len);
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return bytesToHexString(digest.digest());
    }

    public static String bytesToHexString(byte[] src) {
        StringBuilder stringBuilder = new StringBuilder("");
        if (src == null || src.length <= 0) {
            return null;
        }
        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString();
    }
}
