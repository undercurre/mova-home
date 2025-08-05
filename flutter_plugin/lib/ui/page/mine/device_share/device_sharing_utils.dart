import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';

class DeviceShareUtils {
  DeviceShareUtils._internal();

  factory DeviceShareUtils() => _instance;
  static final DeviceShareUtils _instance = DeviceShareUtils._internal();

  // 合并解析和格式化日期的函数
  static String formatDateTimeString(String dateString, {String? inputFormat}) {
    const String defaultInputFormat = 'yyyy-MM-dd HH:mm:ss';
    const String outputFormat = 'yyyy/M/d HH:mm';

    // 解析日期字符串
    DateTime? dateTime =
        _parseDate(dateString, inputFormat ?? defaultInputFormat);

    // 格式化日期
    if (dateTime != null) {
      DateTime localDateTime = dateTime.toLocal(); // 转换为本地时间
      return _formatDate(localDateTime, outputFormat);
    } else {
      return 'Invalid date';
    }
  }

  // 解析日期字符串为DateTime对象
  static DateTime? _parseDate(String dateString, String format) {
    try {
      return DateFormat(format, 'en_US_POSIX')
          .parse(dateString, true); // 解析为 UTC
    } on FormatException {
      return null;
    }
  }

  // 根据当前日期和DateTime对象格式化输出
  static String _formatDate(DateTime dateTime, String format) {
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat('HH:mm', 'en_US_POSIX').format(dateTime);
    } else if (dateTime.year == now.year) {
      return DateFormat('MM/dd HH:mm', 'en_US_POSIX').format(dateTime);
    } else {
      return DateFormat(format, 'en_US_POSIX').format(dateTime);
    }
  }
}
