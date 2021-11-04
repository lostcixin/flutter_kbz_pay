import 'package:flutter/material.dart';
import 'package:flutter_kbz_pay/flutter_kbz_pay.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  }

  void success(dynamic data) {
    print(data);
  }

  void error(dynamic data) {
    print(data);
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
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
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
                  ElevatedButton(
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
