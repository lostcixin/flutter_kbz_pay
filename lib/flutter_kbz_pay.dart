import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef void CallBack(Object o);

class FlutterKbzPay {
  static const MethodChannel _channel = const MethodChannel('flutter_kbz_pay');
  static const EventChannel _eventChannel =
      const EventChannel('flutter_kbz_pay/pay_status');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void onPayStatus(CallBack success, CallBack error) {
    _eventChannel.receiveBroadcastStream().listen(success, onError: error);
  }

  static Future<Map> startPay({
    @required String prepayId,
    @required String merchCode,
    @required String appId,
    @required String signKey,
  }) async {
    if (prepayId == null ||
        merchCode == null ||
        appId == null ||
        signKey == null) {
      throw ("parameter error");
    }
    final Map data = await _channel.invokeMethod('startPay', {
      'prepay_id': prepayId,
      'merch_code': merchCode,
      'appid': appId,
      'sign_key': signKey
    });

    return data;
  }
}
