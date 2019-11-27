import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterKbzPay {
  static const MethodChannel _channel = const MethodChannel('flutter_kbz_pay');
  static const EventChannel _eventChannel =
      const EventChannel('flutter_kbz_pay/pay_status');
  static Stream<dynamic> _streamPayStatus;

  //Test Channel
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //Payment callback
  //Only return status code 1 || 2 || 3
  // String COMPLETED = 1;
  // String FAIL = 2;
  // String CANCEL = 3;
  static Stream<dynamic> onPayStatus() {
    if (_streamPayStatus == null) {
      _streamPayStatus = _eventChannel.receiveBroadcastStream();
    }
    return _streamPayStatus;
  }

  //Order ID,returned by the server
  //Merchant code,Unique ID assigned to the merchant by kbz
  //appId ,Unique ID assigned to the merchant app by kbz
  //signKey,The signature returned by the server
  //urlScheme , UrlScheme of your app, Only ios needs this parameter
  static Future<Map> startPay({
    @required String prepayId,
    @required String merchCode,
    @required String appId,
    @required String signKey,
    String urlScheme,
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
