package com.kbzbank.payment.sdk.callback;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.widget.Toast;

import com.ymkj.flutter_kbz_pay.FlutterKbzPayPlugin;

import com.kbzbank.payment.KBZPay;

public class CallbackResultActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        int result = intent.getIntExtra(KBZPay.EXTRA_RESULT, 0);
        if (result == KBZPay.COMPLETED) {
            Log.d("KBZPay", "pay success!");
            FlutterKbzPayPlugin.sendPayStatus(result);
            Toast.makeText(this, "pay success!", Toast.LENGTH_SHORT).show();
        } else {
            String failMsg = intent.getStringExtra(KBZPay.EXTRA_FAIL_MSG);
            FlutterKbzPayPlugin.sendPayStatus(result);
            Log.d("KBZPay", "pay fail, fail reason = " + failMsg);
            Toast.makeText(this, "pay fail, fail reason = " + failMsg, Toast.LENGTH_SHORT).show();
        }
    }
}
