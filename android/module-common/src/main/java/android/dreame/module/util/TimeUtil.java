package android.dreame.module.util;

import android.text.TextUtils;

import java.io.File;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by licrynoob on 2016/7/18 <br>
 * Copyright (C) 2016 <br>
 * Email:licrynoob@gmail.com <p>
 * 时间工具类
 */
public class TimeUtil {

    /**
     * 时间日期格式化到年月日时分秒.
     */
    public static final String FORMAT_YMD_HMS = "yyyy-MM-dd HH:mm:ss";
    /**
     * 时间日期格式化到年月日
     */
    public static final String FORMAT_YMD = "yyyy-MM-dd";
    /**
     * 时间日期格式化到年月日
     */
    public static final String FORMAT_YMD_DOT = "yyyy.MM.dd";
    /**
     * 时间日期格式化到年月
     */
    public static final String FORMAT_YM = "yyyy-MM";

    /**
     * 时间日期格式化到年
     */
    public static final String FORMAT_Y = "yyyy";
    /**
     * 时间日期格式化到年月日时分
     */
    public static final String FORMAT_YMD_HM = "yyyy-MM-dd HH:mm";

    /**
     * 时间日期格式化到月日
     */
    public static final String FORMAT_MD = "MM/dd";
    /**
     * 时分秒
     */
    public static final String FORMAT_HMS = "HH:mm:ss";
    /**
     * 时分
     */
    public static final String FORMAT_HM = "HH:mm";
    /**
     * 时分
     */
    public static final String FORMAT_MS = "mm:ss";
    /**
     * 上午
     */
    public static final String AM = "AM";
    /**
     * 下午
     */
    public static final String PM = "PM";

    private static final int seconds_of_5minute = 60 * 5;

    private static final int seconds_of_30minutes = 30 * 60;

    private static final int seconds_of_1hour = 60 * 60;

    private static final int seconds_of_1day = 24 * 60 * 60;

    private static final String TAG = TimeUtil.class.getSimpleName();

    /**
     * 设置时间格式
     *
     * @param timeMillis 时间
     * @param format     所需日期时间格式
     * @return TimeStr
     */
    public static String formatTime(long timeMillis, String format) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format, Locale.CHINA);
        return simpleDateFormat.format(new Date(timeMillis));
    }

    /**
     * 设置时间格式
     *
     * @param date
     * @param format
     * @return
     */
    public static String formatTime(Date date, String format) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
        return simpleDateFormat.format(date);
    }

    /**
     * 获取当前日期时间
     *
     * @param format 所需日期时间格式
     * @return TimeStr
     */
    public static String getCurrentTime(String format) {
        return formatTime(System.currentTimeMillis(), format);
    }

    /**
     * 获取文件最后变更时间
     *
     * @param path 文件路径
     * @return 文件最后变更时间
     */
    public static String getModifiedFileTime(String path) {
        File file = new File(path);
        if (file.exists()) {
            long time = file.lastModified();
            return formatTime(time, FORMAT_YMD);
        }
        return "1970-01-01";
    }

    /**
     * 比较时间先后
     *
     * @param data1  data1
     * @param data2  data2
     * @param format format
     * @return 1:data1大于data2 -1:data1小于data2
     */
    public static int compareTime(String data1, String data2, String format) {
        DateFormat df = new SimpleDateFormat(format, Locale.CHINA);
        Date dt1 = null;
        Date dt2 = null;
        try {
            dt1 = df.parse(data1);
            dt2 = df.parse(data2);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        if (dt1 != null && dt2 != null) {
            if (dt1.getTime() > dt2.getTime()) {
                return 1;
            } else if (dt1.getTime() < dt2.getTime()) {
                return -1;
            }
        }
        return 0;
    }

    /**
     * 获取当前年份
     */
    public static int getCurrentYear() {
        Calendar c = Calendar.getInstance();
        int year = c.get(Calendar.YEAR);
        return year;
//        month = c.grt(Calendar.MONTH)
//        day = c.get(Calendar.DAY_OF_MONTH)
//        取得系统时间：hour = c.get(Calendar.HOUR_OF_DAY);
//        minute = c.get(Calendar.MINUTE)
//        Calendar c = Calendar.getInstance();
//        取得系统日期:year = c.get(Calendar.YEAR)
//        month = c.grt(Calendar.MONTH)
//        day = c.get(Calendar.DAY_OF_MONTH)
//        取得系统时间：hour = c.get(Calendar.HOUR_OF_DAY);
//        minute = c.get(Calendar.MINUTE)
    }

    /**
     * 获取当前月份
     */
    public static int getCurrentMonth() {
        Calendar c = Calendar.getInstance();
        int month = c.get(Calendar.MONTH) + 1;
        return month;
//        month = c.grt(Calendar.MONTH)
//        day = c.get(Calendar.DAY_OF_MONTH)
//        取得系统时间：hour = c.get(Calendar.HOUR_OF_DAY);
//        minute = c.get(Calendar.MINUTE)
//        Calendar c = Calendar.getInstance();
//        取得系统日期:year = c.get(Calendar.YEAR)
//        month = c.grt(Calendar.MONTH)
//        day = c.get(Calendar.DAY_OF_MONTH)
//        取得系统时间：hour = c.get(Calendar.HOUR_OF_DAY);
//        minute = c.get(Calendar.MINUTE)
    }

    /**
     * 获取当前日期
     */
    public static int getCurrentDay() {
        Calendar c = Calendar.getInstance();
        int day = c.get(Calendar.DATE);
        return day;
//        month = c.grt(Calendar.MONTH)
//        day = c.get(Calendar.DAY_OF_MONTH)
//        取得系统时间：hour = c.get(Calendar.HOUR_OF_DAY);
//        minute = c.get(Calendar.MINUTE)
//        Calendar c = Calendar.getInstance();
//        取得系统日期:year = c.get(Calendar.YEAR)
//        month = c.grt(Calendar.MONTH)
//        day = c.get(Calendar.DAY_OF_MONTH)
//        取得系统时间：hour = c.get(Calendar.HOUR_OF_DAY);
//        minute = c.get(Calendar.MINUTE)
    }

    /**
     * 获取当前日期对象
     */
    public static Date getCurrentDate(String changeTime) throws ParseException {
        String time = getCurrentTime(FORMAT_YMD);
        if (!TextUtils.isEmpty(changeTime)) {
            time = changeTime;
        }
        Date date = new SimpleDateFormat(FORMAT_YMD).parse(time);
        return date;
    }


    /**
     * 格式化时间
     *
     * @param time
     * @return
     */
    public static String getTimeShow(String time) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        /**获取当前时间*/
        Date curDate = new Date(System.currentTimeMillis());
        String dataStrNew = sdf.format(curDate);
        Date startTime = null;
        try {
            /**将时间转化成Date*/
            curDate = sdf.parse(dataStrNew);
            startTime = sdf.parse(time);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        /**除以1000是为了转换成秒*/
        long between = (curDate.getTime() - startTime.getTime()) / 1000;
        int elapsedTime = (int) (between);

        if (elapsedTime <= 0) {
            return "刚刚";
        }

        if (elapsedTime < seconds_of_5minute) {
            return elapsedTime / 60 + "分钟前";
        }

        if (elapsedTime < seconds_of_30minutes) {
            return elapsedTime / 60 + "分钟前";
        }

        if (elapsedTime < seconds_of_1hour) {
            return elapsedTime / 60 + "分钟前";
        }

        if (elapsedTime < seconds_of_1day) {
            return elapsedTime / seconds_of_1hour + "小时前";
        }

        return time;
    }


    public static long stringToLong(String strTime, String formatType) {
        DateFormat df = new SimpleDateFormat(formatType, Locale.CHINA);
        Date date = null;
        try {
            date = df.parse(strTime);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (date == null) {
            return 0;
        } else {
            long currentTime = dateToLong(date); // date类型转成long类型
            return currentTime;
        }
    }

    public static long dateToLong(Date date) {
        return date.getTime();
    }

    public static String durationToHMS(long second) {
        int seconds = (int) (second % 60);
        int minutes = (int) ((second / 60) % 60);
        int hours = (int) (second / 3600);
        return String.format(Locale.US, "%02d:%02d:%02d", hours, minutes, seconds);
    }

    public static String durationToMS(long second) {
        int seconds = (int) (second % 60);
        int minutes = (int) (second / 60);
        return String.format(Locale.US, "%02d:%02d", minutes, seconds);
    }


    public static String timeStampToDate(long time, String format) {
        if (format == null || format.isEmpty()) {
            format = "yyyy-MM-dd HH:mm:ss";
        }
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(new Date(time));
    }

    /**
     * 指定日期获取当天星期
     * @param day
     * @param format
     * @return
     */
    public static String weekByDate(String day,String format) {
        String str = "";
        SimpleDateFormat fmt = new SimpleDateFormat(format);
        Date d = null;
        try {
            d = fmt.parse(day);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        Calendar cal = Calendar.getInstance();
        cal.setTime(d);
        int weekDay = cal.get(Calendar.DAY_OF_WEEK);
        switch (weekDay) {
            case 1:
                str = "星期天";
                break;
            case 2:
                str = "星期一";
                break;
            case 3:
                str = "星期二";
                break;
            case 4:
                str = "星期三";
                break;
            case 5:
                str = "星期四";
                break;
            case 6:
                str = "星期五";
                break;
            case 7:
                str = "星期六";
                break;
            default:
                break;
        }
        return str;
    }

}

