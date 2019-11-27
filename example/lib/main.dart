import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_kbz_pay/flutter_kbz_pay.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String prepayId = '2',
      merchCode = '100187778',
      appId = 'kp1234567890987654321abcdefghijk',
      signKey = '123456';
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FlutterKbzPay.onPayStatus().listen((Object data) {
      print('onPayStatus $data');
    });
    initPlatformState();
  }

  void success(dynamic data) {
    print(data);
  }

  void error(dynamic data) {
    print(data);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterKbzPay.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void startPay() {
    FlutterKbzPay.startPay(
            prepayId: this.prepayId,
            merchCode: this.merchCode,
            appId: this.appId,
            urlScheme: 'KbzPayExample',
            signKey: this.signKey)
        .then((res) {
      print('startPay' + res.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
            //symmetric代表着对称，其vertical代表上下对称，horizontal代表左右对称
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'prepayId:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7826ea),
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: '2',
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                    ),
                    validator: (String value) => value == null ? '' : null,
                    onSaved: (String value) => prepayId = value,
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'merchCode:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7826ea),
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: '100187778',
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                    ),
                    validator: (String value) => value == null ? '' : null,
                    onSaved: (String value) => merchCode = value,
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'appId:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7826ea),
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: 'kp1234567890987654321abcdefghijk',
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                    ),
                    validator: (String value) => value == null ? '' : null,
                    onSaved: (String value) => appId = value,
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'signKey:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7826ea),
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: '123456',
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                    ),
                    validator: (String value) => value == null ? '' : null,
                    onSaved: (String value) => signKey = value,
                  ),
                  SizedBox(height: 15.0),
                  RaisedButton(
                      child: Text('Pay'),
                      onPressed: () {
                        startPay();
                      }),
                ],
              ),
            )),
      ),
    );
  }
}
