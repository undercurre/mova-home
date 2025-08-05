import 'package:easy_localization/easy_localization.dart';

class DateFormatUtils {
  static String formatLocal(String time,
      {format = 'HH:mm', rawformat = 'yyyy-MM-dd HH:mm:ss', utc = true}) {
    if(time.isEmpty){
      return '';
    }
    return DateFormat(format)
        .format(Intl.withLocale('en', () => DateFormat(rawformat).parse(time, utc).toLocal()));
  }

  static String formatWithMillsSecondsTimeStamp(int millisecondsSinceEpoch, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    if(millisecondsSinceEpoch.toString().length != 13 ){
      return '';
    }
    return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch));
  }

  static String commonDateTimeFormat(String? dateTime, {serverDateTimeFormat = 'yyyy-MM-dd HH:mm:ss',bool simple = false}){
    if(dateTime == null || dateTime.isEmpty){
      return '';
    }
    var fromDate = Intl.withLocale('en', () => DateFormat(serverDateTimeFormat).parse(dateTime,true).toLocal());
    var nowDate = DateTime.now();

    if(isSameDay(fromDate,nowDate)){
      return DateFormat('HH:mm').format(fromDate);
    }else{
      if(fromDate.year == nowDate.year){
        var format = simple ? DateFormat('MM/dd') : DateFormat('MM/dd HH:mm');
        return format.format(fromDate);
      }else {
        var format = simple ? DateFormat('yyyy/M/dd') : DateFormat('yyyy/M/dd HH:mm');
        return format.format(fromDate);
      }
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2){
    var dateFormat = DateFormat('yyyy-MM-dd');
    var dateStr1 = dateFormat.format(date1);
    var dateStr2 = dateFormat.format(date2);
    return dateStr1 == dateStr2;
  }
}
