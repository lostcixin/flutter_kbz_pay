package com.ymkj.flutter_kbz_pay;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.kbzbank.payment.KBZPay;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Random;

/**
 * FlutterKbzPayPlugin
 */
public class FlutterKbzPayPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {
    private static EventChannel.EventSink sink;
    /**
     * Plugin registration.
     */

    private Context context;
    private Activity activity;
    private String signType = "SHA256";
    private String mOrderInfo;
    private String mSign;
    private MethodChannel methodChannel;
    private EventChannel eventChannel;

    public static void registerWith(Registrar registrar) {
        final FlutterKbzPayPlugin instance = new FlutterKbzPayPlugin();
        instance.onAttachedToEngine(registrar.context(), registrar.messenger());
    }

    // public static void registerWith(Registrar registrar) {
    //     final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "flutter_kbz_pay");
    //     final EventChannel eventchannel = new EventChannel(registrar.messenger(), "flutter_kbz_pay/pay_status");
    //     this.context = registrar.activeContext();
    //     methodChannel.setMethodCallHandler(this);
    //     eventchannel.setStreamHandler(new EventChannel.StreamHandler() {
    //         @Override
    //         public void onListen(Object o, EventChannel.EventSink eventSink) {
    //             SetSink(eventSink);
    //         }

    //         @Override
    //         public void onCancel(Object o) {

    //         }
    //     });
    // }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        // TODO: your plugin is now attached to an Activity
        this.activity = activityPluginBinding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        this.context = applicationContext;
        final MethodChannel methodChannel = new MethodChannel(messenger, "flutter_kbz_pay");
        final EventChannel eventchannel = new EventChannel(messenger, "flutter_kbz_pay/pay_status");
        methodChannel.setMethodCallHandler(this);
        eventchannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                SetSink(eventSink);
            }

            @Override
            public void onCancel(Object o) {

            }
        });
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        context = null;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "startPay":
                createPay(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    public static void SetSink(EventChannel.EventSink eventSink) {
        sink = eventSink;
    }

    public static void sendPayStatus(int status, String orderId) {
        HashMap<String, Object> map = new HashMap();
        map.put("status", status);
        map.put("orderId", orderId);
        sink.success(map);
    }

    private void createPay(MethodCall call, Result result) {
        HashMap<String, Object> map = call.arguments();
        try {
            JSONObject params = new JSONObject(map);
            Log.v("createPay", params.toString());
            if (params.has("prepay_id") && params.has("merch_code") && params.has("appid") && params.has("sign_key")) {
                String prepayId = null;
                String merch_code = null;
                String appid = null;
                String sign_key = null;
                prepayId = params.getString("prepay_id");
                merch_code = params.getString("merch_code");
                appid = params.getString("appid");
                sign_key = params.getString("sign_key");
                buildOrderInfo(prepayId, merch_code, appid, sign_key);
                KBZPay.startPay(this.activity, mOrderInfo, mSign, signType);
                result.success("payStatus " + 0);
            } else {
                result.error("parameter error", "parameter error", null);
            }
        } catch (JSONException e) {
            e.printStackTrace();
            return;
        }
    }

    private void buildOrderInfo(String prepay_id, String merch_code, String appid, String sign_key) {
        String prepayId = prepay_id;
        String nonceStr = createRandomStr();
        String timestamp = createTimestamp();
        mOrderInfo = "appid=" + appid +
                "&merch_code=" + merch_code +
                "&nonce_str=" + nonceStr +
                "&prepay_id=" + prepayId +
                "&timestamp=" + timestamp;
        mSign = SHA.getSHA256Str(mOrderInfo + "&key=" + sign_key);
    }

    private String createRandomStr() {
        Random random = new Random();
        return Long.toString(Math.abs(random.nextLong()));
    }

    private String createTimestamp() {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        double time = cal.getTimeInMillis() / 1000;
        Double d = Double.valueOf(time);
        return Integer.toString(d.intValue());
    }
}
