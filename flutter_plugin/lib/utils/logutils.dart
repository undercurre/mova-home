import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:logger/logger.dart';

/// 日志打印
class LogUtils {
  static final Logger _logger = Logger();
  static bool isPrintConsole = true;

  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isPrintConsole) _logger.v(message, error, stackTrace);
    LogModule().log(message.toString(),
        level: 'verbose', stackTrace: stackTrace?.toString() ?? '');
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isPrintConsole) _logger.d(message, error, stackTrace);
    LogModule().log(message.toString(),
        level: 'debug', stackTrace: stackTrace?.toString() ?? '');
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isPrintConsole) _logger.i(message, error, stackTrace);
    LogModule().log(message.toString(),
        level: 'info', stackTrace: stackTrace?.toString() ?? '');
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isPrintConsole) _logger.w(message, error, stackTrace);
    LogModule().log(message.toString(),
        level: 'warn', stackTrace: stackTrace?.toString() ?? '');
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isPrintConsole) _logger.e(message, error, stackTrace);
    LogModule().log(message.toString(),
        level: 'error', stackTrace: stackTrace?.toString() ?? '');
  }

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (isPrintConsole) _logger.wtf(message, error, stackTrace);
    LogModule().log(message.toString(),
        level: 'wtf', stackTrace: stackTrace?.toString() ?? '');
  }
}
