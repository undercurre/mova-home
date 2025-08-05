package android.dreame.module.util;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AppOpsManager;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.dreame.module.constant.Constants;
import android.location.LocationManager;
import android.media.MediaScannerConnection;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Binder;
import android.os.SystemClock;
import android.provider.MediaStore;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.util.Base64;
import android.view.inputmethod.InputMethodManager;
import android.widget.TextView;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import androidx.core.content.ContextCompat;

/**
 * Created by licrynoob on 2016/guide_2/12 <br>
 * Copyright (C) 2016 <br>
 * Email:licrynoob@gmail.com <p>
 * 常用工具类
 */
public class CommonUtil {
    /**
     * 文本替换工具
     */
    public static String replace(String from, String to, String source) {
        if (source == null || from == null || to == null)
            return null;
        StringBuffer bf = new StringBuffer("");
        int index = -1;
        while ((index = source.indexOf(from)) != -1) {
            bf.append(source.substring(0, index) + to);
            source = source.substring(index + from.length());
            index = source.indexOf(from);
        }
        bf.append(source);
        return bf.toString();
    }

    /**
     * 根据国家code,判断手机号是否正确
     * @param phone
     * @param countryCode
     * @return
     */
    public static boolean isPhone(String phone,int countryCode) {
        if (countryCode == 86){
            return isPhone(phone);
        }else {
            return isForeignPhone(phone);
        }
    }
    /**
     * 判断是否为手机号
     *
     * @param phone 手机号
     * @return true
     */
    public static boolean isPhone(String phone) {
        if (phone == null || phone.length() == 0){
            return false;
        }
        return Pattern.matches("^[1][0-9][0-9]{9}$", phone);
    }

    public static boolean isNumber(String str){
        if(str == null || str.isEmpty()){
            return  false;
        }
        Pattern pattern = Pattern.compile("^[0-9]*$");
        return pattern.matcher(str).matches();
    }

    /**
     * 判断是否是海外手机号 6-15位数字
     * @param phone
     * @return
     */
    public static boolean isForeignPhone(String phone) {
        if (phone == null || phone.length() == 0){
            return false;
        }
        return Pattern.matches("^[0-9]{6,15}$", phone);
    }

    public static final boolean isIp(String ip){
        Pattern p;
        Matcher m;
        boolean b;
        p = Pattern.compile("^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
                "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
                "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." +
                "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$");
        m = p.matcher(ip);
        b = m.matches();
        return b;
    }



    /**
     * 判断是否为中国手机号
     *
     * @param phone 手机号
     * @return true
     */
    public static boolean isChinesePhone(String phone) {
        Pattern p;
        Matcher m;
        boolean b;
        p = Pattern.compile("^[1][0-9][0-9]{9}$");
        m = p.matcher(phone);
        b = m.matches();
        return b;
    }

    /**
     * 判断是否为越南手机号
     *
     * @param phone 手机号
     * @return true
     */
    public static boolean isVietnamPhone(String phone) {
        Pattern p;
        Matcher m;
        boolean b;
        p = Pattern.compile("^(\\d{9}|\\d{10})$");//9位或10位数字
        m = p.matcher(phone);
        b = m.matches();
        return b;

    }

    /**
     * 密码验证
     *
     * @param password
     * @return
     */
    public static boolean isPassword(String password) {
        Pattern p;
        Matcher m;
        boolean b;
        p = Pattern.compile("[A-Za-z0-9~!@#$%^&*()_+;',.:<>]{8,16}");
        m = p.matcher(password);
        b = m.matches();
        return b;
    }

    /**
     * 判断网络是否连接
     *
     * @return
     */
    @SuppressLint("MissingPermission")
    public static boolean isNet(Context context) {
        ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (null != connectivity) {
            NetworkInfo info = connectivity.getActiveNetworkInfo();
            if (null != info && info.isConnected()) {
                if (info.getState() == NetworkInfo.State.CONNECTED) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 判断是否是wifi连接
     */
    @SuppressLint("MissingPermission")
    public static boolean isWifi(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        return cm != null && cm.getActiveNetworkInfo().getType() == ConnectivityManager.TYPE_WIFI;
    }

    /**
     * 判断是否是移动数据连接
     */
    @SuppressLint("MissingPermission")
    public static boolean isMobile(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        return cm != null && cm.getActiveNetworkInfo().getType() == ConnectivityManager.TYPE_MOBILE;
    }

    /**
     * 打开网络设置界面
     */
    public static void openNetSet(Activity activity, int requestCode) {
        Intent intent = new Intent("/");
        ComponentName cm = new ComponentName("com.android.settings", "com.android.settings.WirelessSettings");
        intent.setComponent(cm);
        intent.setAction("android.intent.action.VIEW");
        activity.startActivityForResult(intent, requestCode);
    }

    /**
     * 隐藏软键盘
     */
    public static void hideKeyBoard(Context context) {
        InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm.isActive())
            imm.toggleSoftInput(InputMethodManager.SHOW_IMPLICIT, InputMethodManager.HIDE_NOT_ALWAYS);
    }

    /**
     * 对象转为Base64位字符串
     *
     * @param object Object
     * @return base64
     */
    public static String objectToBase64(Object object) {
        String userBase64;
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ObjectOutputStream oos = null;
        try {
            oos = new ObjectOutputStream(baos);
            oos.writeObject(object);
            userBase64 = new String(Base64.encode(baos.toByteArray(), Base64.DEFAULT));
            return userBase64;
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                baos.close();
                if (oos != null) {
                    oos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * Base64位字符串转为对象
     *
     * @param base64Str 64位字符串
     * @return Object
     */
    public static Object base64ToObject(String base64Str) {
        Object object;
        byte[] buffer = Base64.decode(base64Str, Base64.DEFAULT);
        ByteArrayInputStream bais = new ByteArrayInputStream(buffer);
        ObjectInputStream ois = null;
        try {
            ois = new ObjectInputStream(bais);
            object = ois.readObject();
            return object;
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                bais.close();
                if (ois != null) {
                    ois.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * Map 转 JsonStr
     *
     * @param map Map
     * @return JSON字符串
     */
    public static String mapToJson(Map<String, String> map) {
        if (map == null || map.isEmpty()) {
            return "null";
        }
        String json = "{";
        Set<?> keySet = map.keySet();
        for (Object key : keySet) {
            json += "\"" + key + "\":\"" + map.get(key) + "\",";
        }
        json = json.substring(1, json.length() - 2);
        json += "}";
        return json;
    }

    /**
     * JsonStr 转 Map
     *
     * @param json JSON字符串
     * @return Map
     */
    public static Map jsonToMap(String json) {
        String sb = json.substring(1, json.length() - 1);
        String[] name = sb.split("\\\",\\\"");
        String[] nn;
        Map<String, String> map = new HashMap<>();
        for (String aName : name) {
            nn = aName.split("\\\":\\\"");
            map.put(nn[0], nn[1]);
        }
        return map;
    }

    /**
     * 通过资源设置文字颜色
     */
    public static void setTextColorByRes(TextView textView, int colorRes) {
        textView.setTextColor(ContextCompat.getColor(textView.getContext(), colorRes));
    }

    /**
     * 获取非空Str
     *
     * @param tagStr     目标Str
     * @param defaultStr 默认Str
     * @return ResultStr
     */
    public static String setNoNullStr(String tagStr, String defaultStr) {
        if (!TextUtils.isEmpty(tagStr)) {
            return tagStr;
        }
        return defaultStr;
    }

    /**
     * 去除空字符
     *
     * @param param old
     * @return new
     */
    public static String replaceBlank(String param) {
        String dest = "";
        if (!TextUtils.isEmpty(param)) {
            Pattern p = Pattern.compile("\\s*|\t|\r|\n");
            Matcher m = p.matcher(param);
            dest = m.replaceAll("");
        }
        return dest;
    }


    /**
     * 获取包信息
     *
     * @return PackageInfo
     */
    public static PackageInfo getPackageInfo(Context context) throws PackageManager.NameNotFoundException {

        return context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
    }

    /**
     * 判断qq是否可用
     *
     * @param context
     * @return
     */
    public static boolean isQQClientAvailable(Context context) {
        final PackageManager packageManager = context.getPackageManager();
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName;
                if (pn.equals("com.tencent.mobileqq")) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 检查手机上是否安装了指定的软件
     *
     * @param context
     * @param packageName：应用包名
     * @return
     */
    public static boolean isAvilible(Context context, String packageName) {
        //获取packagemanager
        final PackageManager packageManager = context.getPackageManager();
        //获取所有已安装程序的包信息
        List<PackageInfo> packageInfos = packageManager.getInstalledPackages(0);
        //用于存储所有已安装程序的包名
        List<String> packageNames = new ArrayList<String>();
        //从pinfo中将包名字逐一取出，压入pName list中
        if (packageInfos != null) {
            for (int i = 0; i < packageInfos.size(); i++) {
                String packName = packageInfos.get(i).packageName;
                packageNames.add(packName);
            }
        }
        //判断packageNames中是否有目标程序的包名，有TRUE，没有FALSE
        return packageNames.contains(packageName);
    }


    public static void openGaoDe(Context context, double lat, double lng, String dName) {
        Intent intent = new Intent("android.intent.action.VIEW", Uri.parse("androidamap://route?sourceApplication=FoBenYuan" + "&dlat=" + lat //终点的经度
                + "&dlon=" + lng + "&dname=" + dName//终点的纬度
                + "&dev=0" + "&t=2"));
        intent.addCategory("android.intent.category.DEFAULT");
        context.startActivity(intent);
    }

    public static void openBaiDu(Context context, double lat, double lng, String dName) {
        Intent intent = new Intent();
        intent.setData(Uri.parse("baidumap://map/direction?origin=name:我的位置|latlng:" + "93.076171875"
                + "," + "43.6122167682" + "&destination=name:" + dName + "|latlng:" + lat + "," + lng + "&mode=car&sy=0&index=0&target=1"));
        intent.setPackage("com.baidu.BaiduMap");
        context.startActivity(intent); // 启动调用
    }

    public static double[] gaoDeToBaidu(double gd_lon, double gd_lat) {
        double[] bd_lat_lon = new double[2];
        double PI = 3.14159265358979324 * 3000.0 / 180.0;
        double x = gd_lon, y = gd_lat;
        double z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * PI);
        double theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * PI);
        bd_lat_lon[0] = z * Math.cos(theta) + 0.0065;
        bd_lat_lon[1] = z * Math.sin(theta) + 0.006;
        return bd_lat_lon;
    }

    /**
     * 跳转到拨号界面
     *
     * @param activity
     * @param contactNumber
     */
    public static void jumpToDial(Activity activity, String contactNumber) {
        Intent intent = new Intent(Intent.ACTION_DIAL);
        Uri data = Uri.parse("tel:" + contactNumber);
        intent.setData(data);
        activity.startActivity(intent);
    }

    /**
     * 跳转到外部浏览器
     *
     * @param activity
     * @param url
     */
    public static void jumpToBrowser(Activity activity, String url) {
        Intent intent = new Intent();
        intent.setAction("android.intent.action.VIEW");
        Uri uri = Uri.parse(url);
        intent.setData(uri);
        activity.startActivity(intent);
    }

    /**
     * 判断闰年
     */
    public static boolean isLeapYear(int year) {
        if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
            return true;
        }
        return false;
    }

    /**
     * 判断是否开启浮窗权限,api未公开，使用反射调用
     *
     * @return
     */
    public static boolean hasPermissionFloatWin(Context context) {
        if (android.os.Build.VERSION.SDK_INT < 20) {
            return true;
        }
        try {
            AppOpsManager appOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            Class c = appOps.getClass();
            Class[] cArg = new Class[3];
            cArg[0] = int.class;
            cArg[1] = int.class;
            cArg[2] = String.class;
            Method lMethod = c.getDeclaredMethod("checkOp", cArg);
            //24是浮窗权限的标记
            return (AppOpsManager.MODE_ALLOWED == (Integer) lMethod.invoke(appOps, 24, Binder.getCallingUid(), context.getPackageName()));
        } catch (Exception e) {
            return false;
        }
    }

    public static Map<String, String> mapStringToMap(String str) {
        str = str.substring(1, str.length() - 1);
        String[] strs = str.split(",");
        Map<String, String> map = new HashMap<String, String>();
        for (String string : strs) {
            String key = string.split("=")[0];
            String value = string.split("=")[1];
            map.put(key, value);
        }
        return map;
    }

    /**
     * 身份证验证
     */
    public static boolean isIdCardNo(String idCardNo) {
        Pattern p;
        Matcher m;
        boolean b;
        p = Pattern.compile("(^\\d{15}$)|(^\\d{17}([0-9]|X)$)");
        m = p.matcher(idCardNo);
        b = m.matches();
        return b;
    }


    /**
     * 邮箱验证
     */
    public static boolean isEmail(String email) {
        if (TextUtils.isEmpty(email)) {
            return false;
        }
//        boolean b = Pattern.matches(Constants.verifyMail, email);
        return email.contains("@");
    }

    public static boolean isValidNumber(String phoneNumber,String countryCode){
        if(TextUtils.isEmpty(phoneNumber)){
            return false;
        }
        if (!TextUtils.isDigitsOnly(phoneNumber)) {
            return false;
        }
        if("CN".equalsIgnoreCase(countryCode) || "86".equalsIgnoreCase(countryCode)){
            return phoneNumber.length() == 11 && phoneNumber.startsWith("1");
        }else{
            return phoneNumber.length() >= 6 && phoneNumber.length() <= 15;
        }
    }


    /**
     * 判定输入汉字
     *
     * @param c
     * @return
     */
    public static boolean isChinese(char c) {
        Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
        if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
                || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
                || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
                || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS) {
            return true;
        }
        return false;
    }

     /*
      校验过程：
      1、从卡号最后一位数字开始，逆向将奇数位(1、3、5等等)相加。
     2、从卡号最后一位数字开始，逆向将偶数位数字，先乘以2（如果乘积为两位数，将个位十位数字相加，即将其减去9），再求和。
      3、将奇数位总和加上偶数位总和，结果应该可以被10整除。
     */

    /**
     * 校验银行卡卡号
     */
    public static boolean checkBankCard(String bankCard) {
        if (bankCard.length() < 15 || bankCard.length() > 19) {
            return false;
        }
        char bit = getBankCardCheckCode(bankCard.substring(0, bankCard.length() - 1));
        if (bit == 'N') {
            return false;
        }
        return bankCard.charAt(bankCard.length() - 1) == bit;
    }

    /**
     * 从不含校验位的银行卡卡号采用 Luhm 校验算法获得校验位
     *
     * @param nonCheckCodeBankCard
     * @return
     */
    public static char getBankCardCheckCode(String nonCheckCodeBankCard) {
        if (nonCheckCodeBankCard == null || nonCheckCodeBankCard.trim().length() == 0
                || !nonCheckCodeBankCard.matches("\\d+")) {
            //如果传的不是数据返回N
            return 'N';

        }
        char[] chs = nonCheckCodeBankCard.trim().toCharArray();
        int luhmSum = 0;
        for (int i = chs.length - 1, j = 0; i >= 0; i--, j++) {
            int k = chs[i] - '0';
            if (j % 2 == 0) {
                k *= 2;
                k = k / 10 + k % 10;

            }
            luhmSum += k;

        }
        return (luhmSum % 10 == 0) ? '0' : (char) ((10 - luhmSum % 10) + '0');

    }


    /**
     * 身份证号校验 （支持18位）
     */
    public static boolean checkIdentityCode(String identityCode) {
        if (!identityCode.matches("\\d{17}(\\d|x|X)$")) {
            return false;
        }
        Date d = new Date();
        DateFormat df = new SimpleDateFormat("yyyyMMdd");
        int year = Integer.parseInt(df.format(d));
        if (Integer.parseInt(identityCode.substring(6, 10)) < 1900 || Integer.parseInt(identityCode.substring(6, 10)) > year) {// 7-10位是出生年份，范围应该在1900-当前年份之间
            return false;
        }
        if (Integer.parseInt(identityCode.substring(10, 12)) < 1 || Integer.parseInt(identityCode.substring(10, 12)) > 12) {// 11-12位代表出生月份，范围应该在01-12之间
            return false;
        }
        if (Integer.parseInt(identityCode.substring(12, 14)) < 1 || Integer.parseInt(identityCode.substring(12, 14)) > 31) {// 13-14位是出生日期，范围应该在01-31之间
            return false;
        }
        // 校验第18位
        // S = Sum(Ai * Wi), i = 0, ... , 16 ，先对前17位数字的权求和
        // Ai:表示第i位置上的身份证号码数字值
        // Wi:表示第i位置上的加权因子
        // Wi: 7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2
        String[] tempA = identityCode.split("|");
        int[] a = new int[18];
        for (int i = 0; i < tempA.length - 2; i++) {
            a[i] = Integer.parseInt(tempA[i + 1]);
        }
        int[] w = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2}; // 加权因子
        int sum = 0;
        for (int i = 0; i < 17; i++) {
            sum = sum + a[i] * w[i];
        }
        // Y = mod(S, 11)
        // 通过模得到对应的校验码
        // Y: 0 1 2 3 4 5 6 7 8 9 10
        // 校验码: 1 0 X 9 8 7 6 5 4 3 2
        String[] v = {"1", "0", "x", "9", "8", "7", "6", "5", "4", "3", "2"}; // 校验码
        int y = sum % 11;
        if (!v[y].equalsIgnoreCase(identityCode.substring(17))) {// 第18位校验码错误
            return false;
        }
        return true;
    }


    /**
     * 显示银行卡后四位
     */
    public static String hideCardNo(String cardNo) {
        int length = cardNo.length();
        int afterLength = 4;
        //替换字符串，当前使用“*”
        String replaceSymbol = "*";
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < length; i++) {
            if (i >= (length - afterLength)) {
                sb.append(cardNo.charAt(i));
            } else {
                sb.append(replaceSymbol);
            }
        }
        return sb.toString();
    }

    /**
     * List集合转String
     *
     * @param mList
     * @return
     */
    public static String listToString(List<String> mList,String flg) {
        StringBuffer convertedListStr = new StringBuffer();
        if (null != mList && mList.size() > 0) {
            String[] mListArray = mList.toArray(new String[mList.size()]);
            for (int i = 0; i < mListArray.length; i++) {
                if (i < mListArray.length - 1) {
                    convertedListStr.append(mListArray[i] + flg);
                } else {
                    convertedListStr.append(mListArray[i]);
                }
            }
            return convertedListStr.toString();
        } else return "";
    }


    public static long testConnection(boolean isFirst) {

        LogUtil.e("testConnection  isFirsr：" + isFirst);

        HttpURLConnection httpURLConnection = null;
        try {
            URL url = new URL("http://www.google.com");
            httpURLConnection = (HttpURLConnection) url.openConnection();
            httpURLConnection.setRequestProperty("Connection", "close");
            if (isFirst) {
                httpURLConnection.setConnectTimeout(1000);
                httpURLConnection.setReadTimeout(1000);
            } else {
                httpURLConnection.setConnectTimeout(10000);
                httpURLConnection.setReadTimeout(10000);
            }

            httpURLConnection.setUseCaches(false);

            long requestTimestamp = SystemClock.elapsedRealtime();
            int httpResponseCode = httpURLConnection.getResponseCode();
            long responseTimestamp = SystemClock.elapsedRealtime();
            long time = responseTimestamp - requestTimestamp;
            httpURLConnection.disconnect();
            return time;
        } catch (SocketTimeoutException e) {
            LogUtil.e("testConnection SocketTimeoutException", e.getMessage());
            if (httpURLConnection != null) {
                httpURLConnection.disconnect();
            }
            if (isFirst) {
                return 0;
            } else {
                return 10000;
            }
        } catch (MalformedURLException e) {
            LogUtil.e("testConnection MalformedURLException", e.getMessage());
            if (httpURLConnection != null) {
                httpURLConnection.disconnect();
            }
            e.printStackTrace();
            return 0;
        } catch (IOException e) {
            LogUtil.e("testConnection MalformedURLException", e.getMessage());
            if (httpURLConnection != null) {
                httpURLConnection.disconnect();
            }
            e.printStackTrace();
            return 0;
        }
    }

    public static SpannableString StrEqualSpanColor(Context context, String content, String keyWords, int resColor) {

        SpannableString commentSpan = new SpannableString(content);
        if (!content.equals("")) {
            ForegroundColorSpan mKeyFCS = new ForegroundColorSpan(ContextCompat.getColor(context, resColor));
            int position = content.indexOf(keyWords);
            int lasPosition = position + keyWords.length();
            LogUtil.e("EqualSpanColor-1=" + content);
            LogUtil.e("EqualSpanColor-2=" + keyWords);
            LogUtil.e("EqualSpanColor-3=" + position + "," + lasPosition);
            if (position > 0 || position == 0) {
                commentSpan.setSpan(mKeyFCS,
                        position,
                        lasPosition,
                        Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
            }
        }
        return commentSpan;
    }

    public static void saveVideoToAlbum(Context context, File videoFile) {
        ContentResolver localContentResolver = context.getContentResolver();
        ContentValues localContentValues = getVideoContentValues(context, videoFile, System.currentTimeMillis());
        Uri localUri = localContentResolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, localContentValues);
        context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, localUri));
        MediaScannerConnection
                .scanFile(context, new String[]{videoFile.getAbsolutePath()}, null, null);
    }

    public static ContentValues getVideoContentValues(Context paramContext, File paramFile, long paramLong) {
        ContentValues localContentValues = new ContentValues();
        localContentValues.put("title", paramFile.getName());
        localContentValues.put("_display_name", paramFile.getName());
        localContentValues.put("mime_type", "video/mp4");
        localContentValues.put("datetaken", Long.valueOf(paramLong));
        localContentValues.put("date_modified", Long.valueOf(paramLong));
        localContentValues.put("date_added", Long.valueOf(paramLong));
        localContentValues.put("_data", paramFile.getAbsolutePath());
        localContentValues.put("_size", Long.valueOf(paramFile.length()));
        return localContentValues;
    }

    public static int isPictureVideoType(String extension) {
        int state = 0;
        switch (extension) {
            case "png":
            case "PNG":
            case "jpeg":
            case "JPEG":
            case "webp":
            case "WEBP":
            case "gif":
            case "bmp":
            case "GIF":
                state = 0;
                break;
            case "avi":
            case "mp4":
            case "quicktime":
            case "x-msvideo":
            case "x-matroska":
            case "mpeg":
            case "webm":
            case "mp2ts":
                state = 1;
                break;
            case "WAV":
            case "AIF":
            case "AIFF":
            case "AU":
            case "RA":
            case "RM":
            case "RAM":
            case "MP3":
            case "MP1":
            case "MP2":
            case "MID":
            case "RMI":
            case "mp3":
            case "wav":
            case "rm":
            case "ram":
                state = 2;
                break;
            default:
                state = 3;
                break;
        }
        return state;
    }


    /**
     * 判断手机是否打开了定位功能
     */
    public static boolean isLocServiceEnable(Context context) {
        LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        boolean gps = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        boolean network = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
        return gps || network;
    }
    /**
      * 字符串是否包含中文
      *
      * @param str 待校验字符串
      * @return true 包含中文字符 false 不包含中文字符
      */
    public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4E00-\u9FA5！，。（）《》“”？：；【】]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }

    /**
     * 字符串校验密码
     * @param pwd
     * @return
     */
    public static boolean isVerifyPwd(String pwd) {
        if (pwd == null || pwd.length() == 0) {
            return false;
        }
        boolean b = Pattern.matches(Constants.verifyPwd, pwd);
        if (b) {
            b = !isContainChinese(pwd);
        }
        return b;
    }

    /**
     * 计算昵称长度，包含中英文
     * @param content
     * @return
     */
    public static int calculateContentLength(String content) {
        if (TextUtils.isEmpty(content)) {
            return 0;
        }
        int length = 0;
        for (int i = 0; i < content.length(); i++) {
            char charAt = content.charAt(i);
            length += isChinese(charAt) ? 2 : 1;
        }
        return length;
    }

}
