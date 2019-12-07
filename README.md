# Flutter KBZPay 

A Flutter KBZPay Plugin.

## Installation
```yaml
// github
flutter_kbz_pay:
    git:
      url: git://github.com/lostcixin/flutter_kbz_pay.git
      ref: master
```
## Usage
### Android
android/app/src/main/manifest.xml
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
....
	<activity android:name="com.kbzbank.payment.sdk.callback.CallbackResultActivity" android:theme="@android:style/Theme.NoDisplay" android:exported="true"
....
```
### IOS
App project configuration in the Info. Add kbzpay pist white list
ios/Runner/Info.plist
```plist
<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>kbzpay</string>
	</array>
```

### Payment callback
Payment callback, payment completion or payment cancellation, currently there are only two states. The callback parameter is returned as an OpenUrl, as shown below

1：Pay for success，
3：Payment failed, the remaining fields are reserved for later addition。

## Example
```dart
import 'package:flutter_kbz_pay/flutter_kbz_pay.dart';

FlutterKbzPay.startPay(
            prepayId: this.prepayId,
            merchCode: this.merchCode,
            appId: this.appId,
            urlScheme: 'KbzPayExample', //Only Ios
            signKey: this.signKey)
        .then((res) {
      print('startPay' + res.toString());
});
    
FlutterKbzPay.onPayStatus().listen((String data) {
      print('onPayStatus $data');
});
```

## Getting Started
For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
