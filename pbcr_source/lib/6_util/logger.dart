import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:icreat_dct/6_util/device_info.dart';

class Logger {
  static final _functionRegExp = RegExp(r'[A-Za-z0-9]');

  static bool? _isNotReleaseCache;
  static bool get _isNotRelease {
    _isNotReleaseCache ??= !kReleaseMode;
    return _isNotReleaseCache!;
  }

  static void setForceLog() => _isNotReleaseCache = true;

  static void Function(
    String? msg,
    String errorType,
    dynamic exception,
    dynamic stacktrace,
  )? sendExceptionToSentry;

  static void api(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = true,
  }) async =>
      _showLog(
        LoggerType.api,
        msg,
        tag,
        upperStackCnt,
        skipFunctionName,
      );

  static void debug(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = false,
  }) async =>
      _showLog(
        LoggerType.debug,
        msg,
        tag,
        upperStackCnt,
        skipFunctionName,
      );

  static void info(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = false,
    Object? e,
    StackTrace? s,
  }) async =>
      _showLog(
        LoggerType.info,
        msg,
        tag,
        upperStackCnt,
        skipFunctionName,
        e: e,
        s: s,
      );

  static void warn(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = false,
    Object? e,
    StackTrace? s,
  }) async =>
      _showLog(
        LoggerType.warn,
        msg,
        tag,
        upperStackCnt,
        skipFunctionName,
        e: e,
        s: s,
      );

  static void error(
    String msg, {
    String? tag,
    int upperStackCnt = 0,
    bool skipFunctionName = false,
    Object? e,
    StackTrace? s,
    String errorType = 'logger',
  }) async {
    _showLog(
      LoggerType.error,
      msg,
      tag,
      upperStackCnt,
      skipFunctionName,
      e: e,
      s: s,
    );
    sendExceptionToSentry?.call(msg, errorType, e, s);
  }

  static void _showLog(
    LoggerType type,
    String msg,
    String? tag,
    int upperStackCnt,
    bool skipFunctionName, {
    Object? e,
    StackTrace? s,
  }) {
    if (_isNotRelease) {
      var rawMsg = msg + (e == null ? '' : '\n$e') + (s == null ? '' : '\n$s');
      final tagStr = tag != null ? ' [$tag]' : '';
      final functionName = skipFunctionName
          ? ''
          : _getFuctionNameFromFrame(upperStackCnt: upperStackCnt);

      final formattedMsg = _makeFormattedMsg(
        type: type,
        functionName: functionName,
        msg: rawMsg,
        tagStr: tagStr,
      );
      final msgList = _splitMsg(formattedMsg);

      if (DeviceInfo.isAndroid) {
        _print(msgList: msgList, type: type);
      } else {
        _log(msg: formattedMsg, type: type);
        _nsLog(msgList: msgList);
      }
    }
  }

  static List<String> _splitMsg(String log) {
    List<String> logList = log.split('\n');
    List<String> result = [];
    for (String logMsg in logList) {
      result.addAll(_split(logMsg));
    }
    return result;
  }

  static List<String> _split(String log) {
    List<String> lineList = [];
    StringBuffer strBuf = StringBuffer();
    int bytesLength = 0;
    for (int i = 0; i < log.length; i++) {
      final char = log[i];
      final encodeCharLen = utf8.encode(char).length;

      if (bytesLength + encodeCharLen > 1000) {
        lineList.add(strBuf.toString());
        strBuf.clear();
        bytesLength = 0;
      }

      bytesLength += encodeCharLen;
      strBuf.write(char);
    }

    if (strBuf.length > 0) {
      lineList.add(strBuf.toString());
    }

    return lineList;
  }

  static String _getFuctionNameFromFrame({required int upperStackCnt}) {
    final currentTrace =
        StackTrace.current.toString().split('\n')[3 + upperStackCnt];
    var indexOfWhiteSpace = currentTrace.indexOf(' ');
    var subStr = currentTrace.substring(indexOfWhiteSpace);
    final indexOfFunction = subStr.indexOf(_functionRegExp);
    subStr = subStr.substring(indexOfFunction);
    indexOfWhiteSpace = subStr.indexOf(' ');
    subStr = subStr.substring(0, indexOfWhiteSpace);

    return '[$subStr()]';
  }

  static String _makeFormattedMsg({
    required LoggerType type,
    required String functionName,
    required String msg,
    required String tagStr,
  }) {
    return '${type.prefix}$tagStr [${DateTime.now()}] $functionName $msg';
  }

  static void _print(
      {required List<String> msgList, required LoggerType type}) {
    for (var i = 0; i < msgList.length; i++) {
      debugPrint(
        '${type.colorAnsi}${i == 0 ? '' : '\t'}${msgList[i]}${LoggerTypeExt.resetColorAnsi}',
      );
    }
  }

  static void _log({required String msg, required LoggerType type}) {
    final printList = msg.split('\n');
    for (var i = 0; i < printList.length; i++) {
      log(
        '${type.colorAnsi}${i == 0 ? '' : '\t'}${printList[i]}${LoggerTypeExt.resetColorAnsi}',
        name: 'logger',
      );
    }
  }

  static void _nsLog({required List<String> msgList}) {
    if (DeviceInfo.isIOS) {
      List<String> logList = [];
      for (var i = 0; i < msgList.length; i++) {
        logList.add('${i == 0 ? '' : '\t'}${msgList[i]}');
      }
    }
  }
}

enum LoggerType { debug, info, warn, error, api }

extension LoggerTypeExt on LoggerType {
  String get prefix {
    switch (this) {
      case LoggerType.debug:
        return '[\u{2b1c} DEBUG]';
      case LoggerType.info:
        return '[\u{1f7e9} INFO]';
      case LoggerType.warn:
        return '[\u{1f7e7} WARN]';
      case LoggerType.error:
        return '[\u{1f7e5} ERROR]';
      case LoggerType.api:
        return '[\u{1f7e6} API]';
    }
  }

  static const resetColorAnsi = '\x1B[0m';

  String get colorAnsi {
    switch (this) {
      case LoggerType.debug:
        return '\x1B[37m';
      case LoggerType.info:
        return '\x1B[32m';
      case LoggerType.warn:
        return '\x1B[33m';
      case LoggerType.error:
        return '\x1B[31m';
      case LoggerType.api:
        return '\x1B[34m';
    }
  }

  /*
    Black:   \x1B[30m
    Red:     \x1B[31m
    Green:   \x1B[32m
    Yellow:  \x1B[33m
    Blue:    \x1B[34m
    Magenta: \x1B[35m
    Cyan:    \x1B[36m
    White:   \x1B[37m
    Reset:   \x1B[0m
  */

}
