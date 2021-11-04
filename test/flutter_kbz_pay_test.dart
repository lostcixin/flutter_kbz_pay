import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kbz_pay/flutter_kbz_pay.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_kbz_pay');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterKbzPay.platformVersion, '42');
  });
}
