package android.dreame.module.util;

import java.io.File;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.TimeZone;

/**
 * 作者：maqing on 2016/10/21 16:30
 * 邮箱：2856992713@qq.com
 */
public class DateTimeUtil {

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
    public static final String FORMAT_YMD_ = "yyyy/MM/dd";

    public static final String FORMAT_MD_HMS = "MM/dd/HH:mm";

    /**
     * 时间日期格式化到年月
     */
    public static final String FORMAT_YM = "yyyy-MM";
    /**
     * 时间日期格式化到年月日时分
     */
    public static final String FORMAT_YMD_HM = "yyyy-MM-dd HH:mm";

    public static final String FORMAT_YMD_HM2 = "yyyy/MM/dd HH:mm";

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
     * 时分 12小时制
     */
    public static final String FORMAT_HM_12 = "hh:mma";
    /**
     * 上午
     */
    public static final String AM = "AM";
    /**
     * 下午
     */
    public static final String PM = "PM";

    /**
     * 获取当前日期时间
     *
     * @param format 所需日期时间格式
     * @return TimeStr
     */
    public static String getCurrentDate(String format) {
        String curDateTime = null;
        try {
            SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat(format);
            Calendar c = new GregorianCalendar();
            curDateTime = mSimpleDateFormat.format(c.getTime());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return curDateTime;
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
        DateFormat df = new SimpleDateFormat(format);
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


    public static String timeFormat(long timeMillis, String format) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format, Locale.CHINA);
        return simpleDateFormat.format(new Date(timeMillis));
    }

    public static String dateTimeFormat(long timeMillis, String format) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
        simpleDateFormat.setTimeZone(Calendar.getInstance().getTimeZone());
        return simpleDateFormat.format(new Date(timeMillis));
    }

    public static String formatPhotoDate(long time) {
        return timeFormat(time, FORMAT_YMD);
    }

    public static String formatPhotoDate(String filePath) {
        File file = new File(filePath);
        if (file.exists()) {
            long time = file.lastModified();
            return formatPhotoDate(time);
        }
        return "1970-01-01";
    }

    /**
     * 两个时间相差距离多少天多少小时多少分多少秒
     *
     * @param str1 时间参数 1 格式：1990-01-01 12:00:00
     * @param str2 时间参数 2 格式：2009-01-01 12:00:00
     * @return String 返回值为：xx天xx小时xx分xx秒
     */
    public static String[] getDistanceTime(String str1, String str2) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date one;
        Date two;
        long day = 0;
        long hour = 0;
        long min = 0;
        long sec = 0;
        try {
            one = df.parse(str1);
            two = df.parse(str2);
            long time1 = one.getTime();
            long time2 = two.getTime();
            long diff;
            if (time1 < time2) {
                diff = time2 - time1;
            } else {
                diff = time1 - time2;
            }
            day = diff / (24 * 60 * 60 * 1000);
            hour = (diff / (60 * 60 * 1000) - day * 24);
            min = ((diff / (60 * 1000)) - day * 24 * 60 - hour * 60);
            sec = (diff / 1000 - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        String timeIntervals[] = new String[]{day + "", hour + "", min + "", sec + ""};
//        return day + "天" + hour + "小时" + min + "分" + sec + "秒";
        return timeIntervals;
    }

    /**
     * 两个时间相差距离秒
     *
     * @param str1 时间参数 1 格式：1990-01-01 12:00:00
     * @param str2 时间参数 2 格式：2009-01-01 12:00:00
     * @return String 返回值为：秒
     */
    public static long getDistanceTimeSeconds(String str1, String str2) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date one;
        Date two;
        long sec = 0;
        try {
            one = df.parse(str1);
            two = df.parse(str2);
            long time1 = one.getTime();
            long time2 = two.getTime();
            long diff;
            if (time1 < time2) {
                diff = time2 - time1;
            } else {
                diff = time1 - time2;
            }
            sec = diff / (1000);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return sec;
    }

    /**
     * 获取任意时间的上一个月
     * 描述:<描述函数实现的功能>.
     *
     * @param repeatDate
     * @return
     */
    public static String getLastMonth(String repeatDate) {
        String lastMonth = "";
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat dft = new SimpleDateFormat("yyyyMM");
        int year = Integer.parseInt(repeatDate.substring(0, 4));
        String monthsString = repeatDate.substring(4, 6);
        int month;
        if ("0".equals(monthsString.substring(0, 1))) {
            month = Integer.parseInt(monthsString.substring(1, 2));
        } else {
            month = Integer.parseInt(monthsString.substring(0, 2));
        }
        cal.set(year, month - 2, Calendar.DATE);
        lastMonth = dft.format(cal.getTime());
        return lastMonth;
    }


    /**
     * 获取任意时间的下一个月
     * 描述:<描述函数实现的功能>.
     *
     * @param repeatDate
     * @return
     */
    public static String getPreMonth(String repeatDate) {
        String lastMonth = "";
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat dft = new SimpleDateFormat("yyyyMM");
        int year = Integer.parseInt(repeatDate.substring(0, 4));
        String monthsString = repeatDate.substring(4, 6);
        int month;
        if ("0".equals(monthsString.substring(0, 1))) {
            month = Integer.parseInt(monthsString.substring(1, 2));
        } else {
            month = Integer.parseInt(monthsString.substring(0, 2));
        }
        cal.set(year, month, Calendar.DATE);
        lastMonth = dft.format(cal.getTime());
        return lastMonth;
    }

    /**
     * 获得指定日期上一天
     *
     * @param specifiedDay
     * @return
     */
    public static String getSpecifiedDayBefore(String specifiedDay) {
        Calendar c = Calendar.getInstance();
        Date date = null;
        try {
            date = new SimpleDateFormat("yy-MM-dd").parse(specifiedDay);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        c.setTime(date);
        int day = c.get(Calendar.DATE);
        c.set(Calendar.DATE, day - 1);

        String dayBefore = new SimpleDateFormat("yyyy-MM-dd")
                .format(c.getTime());
        return dayBefore;
    }


    /**
     * 获得指定日期下一天
     *
     * @param specifiedDay
     * @return
     */
    public static String getSpecifiedDayAfter(String specifiedDay) {
        Calendar c = Calendar.getInstance();
        Date date = null;
        try {
            date = new SimpleDateFormat("yy-MM-dd").parse(specifiedDay);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        c.setTime(date);
        int day = c.get(Calendar.DATE);
        c.set(Calendar.DATE, day + 1);

        String dayAfter = new SimpleDateFormat("yyyy-MM-dd")
                .format(c.getTime());
        return dayAfter;
    }

    /**
     * @param dateTime
     * @return <p>
     * 1-星期日
     * <p>
     * 2-星期一
     * <p>
     * 3-星期二
     * <p>
     * 4-星期三
     * <p>
     * 5-星期四
     * <p>
     * 6-星期五
     * <p>
     * 7-星期六
     */
    public static int getDayofWeek(String dateTime) {
        Calendar cal = Calendar.getInstance();
        if (dateTime.equals("")) {
            cal.setTime(new Date(System.currentTimeMillis()));
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
            Date date;
            try {
                date = sdf.parse(dateTime);
            } catch (ParseException e) {
                date = null;
                e.printStackTrace();
            }
            if (date != null) {
                cal.setTime(new Date(date.getTime()));
            }
        }
        return cal.get(Calendar.DAY_OF_WEEK);
    }

    /**
     * 判断是否为今天(效率比较高)
     *
     * @param dateStr 传入的 时间  "2016-06-28 10:10:30" "2016-06-28" 都可以
     * @return true今天 false不是
     * @throws ParseException
     */
    public static boolean isToday(String dateStr) throws ParseException {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(FORMAT_YMD);
        String date = timeFormat(simpleDateFormat.parse(dateStr).getTime(),FORMAT_YMD);
        String today = timeFormat(System.currentTimeMillis(), FORMAT_YMD);
        LogUtil.d("isToday",date+","+today);
        return date.equals(today);
    }

    public static Date isoDateString2Date(String isoDateString,String formatStr){
        SimpleDateFormat isoSimpleDateFormat = new SimpleDateFormat(formatStr);
        isoSimpleDateFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
        try {
            Date date = isoSimpleDateFormat.parse(isoDateString);
            return date;
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static String dateConvert(String fromDateStr,String fromFormat,String toFormat){
        return dateConvert(fromDateStr,fromFormat,toFormat,null);
    }

    public static String dateConvert(String fromDateStr,String fromFormat,String toFormat,Locale toLocale){
        String ymdDate = "";
        SimpleDateFormat isoSimpleDateFormat = new SimpleDateFormat(fromFormat);
        isoSimpleDateFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
        try {
            Date date = isoSimpleDateFormat.parse(fromDateStr);
            SimpleDateFormat simpleDateFormat;
            if(toLocale != null){
                simpleDateFormat = new SimpleDateFormat(toFormat,toLocale);
            }else{
                simpleDateFormat = new SimpleDateFormat(toFormat);
            }
            ymdDate = simpleDateFormat.format(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return ymdDate;
    }

    public static boolean isSameDay(final Date date1, final Date date2) {
        if(date1 == null || date2 == null) {
            return false;
        }
        final Calendar cal1 = Calendar.getInstance();
        cal1.setTime(date1);
        final Calendar cal2 = Calendar.getInstance();
        cal2.setTime(date2);
        return isSameDay(cal1, cal2);
    }

    public static boolean isSameDay(final Calendar cal1, final Calendar cal2) {
        if (cal1 == null || cal2 == null) {
            throw new IllegalArgumentException("The date must not be null");
        }
        return (cal1.get(Calendar.ERA) == cal2.get(Calendar.ERA) &&
                cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
                cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR));
    }

    /**
     * 时间格式转世家戳 2021-04-22T10:51:40.601 -> long
     * @param fromDateStr
     * @param fromFormat
     * @return
     */
    public static long dateConvert(String fromDateStr,String fromFormat){
        SimpleDateFormat isoSimpleDateFormat = new SimpleDateFormat(fromFormat);
        isoSimpleDateFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
        try {
            Date date = isoSimpleDateFormat.parse(fromDateStr);
            return date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

