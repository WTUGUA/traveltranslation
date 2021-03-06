package com.tuolu.translation;

import android.app.Activity;
import android.widget.Toast;


import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;


public class MethodChannelPlugin implements MethodChannel.MethodCallHandler {

    private Activity activity;
    private MethodChannel channel;

    public static MethodChannelPlugin registerWith(FlutterView flutterView) {
        MethodChannel channel = new MethodChannel(flutterView, "MethodChannelPlugin");
        MethodChannelPlugin methodChannelPlugin = new MethodChannelPlugin((Activity) flutterView.getContext(), channel);
        channel.setMethodCallHandler(methodChannelPlugin);
        return methodChannelPlugin;
    }

    private MethodChannelPlugin(Activity activity, MethodChannel channel) {
        this.activity = activity;
        this.channel = channel;
    }
    //调用flutter端方法，无返回值
    public void invokeMethod(String method, Object o) {
        channel.invokeMethod(method, o);
    }
    //调用flutter端方法，有返回值
    public void invokeMethod(String method, Object o, MethodChannel.Result result) {
        channel.invokeMethod(method, o, result);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "send"://返回的方法名
                //给flutter端的返回值
                result.success("MethodChannelPlugin收到：" + methodCall.arguments);
                Toast.makeText(activity, methodCall.arguments + "", Toast.LENGTH_SHORT).show();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

}
