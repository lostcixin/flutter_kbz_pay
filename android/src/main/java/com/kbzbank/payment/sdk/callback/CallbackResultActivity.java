package com.kbzbank.payment.sdk.callback;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.kbzbank.payment.KBZPay;
import com.ymkj.flutter_kbz_pay.FlutterKbzPayPlugin;

public class CallbackResultActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        int result = intent.getIntExtra(KBZPay.EXTRA_RESULT, 0);
        if (result == KBZPay.COMPLETED) {
            Log.d("KBZPay", "pay success!");
            Toast.makeText(this, "pay success!", Toast.LENGTH_SHORT).show();
            FlutterKbzPayPlugin.sendPayStatus(result);
        } else {
            String failMsg = intent.getStringExtra(KBZPay.EXTRA_FAIL_MSG);
            Toast.makeText(this, "pay fail, fail reason = " + failMsg, Toast.LENGTH_SHORT).show();
            Log.d("KBZPay", "pay fail, fail reason = " + failMsg);
            FlutterKbzPayPlugin.sendPayStatus(result);
        }
    }
}
