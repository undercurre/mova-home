package com.dreame.smartlife.shadow;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Handler;


public class ShadowBroadcastRegister {
    public static Intent registerReceiver(final Context context, final BroadcastReceiver receiver, final IntentFilter intentFilter) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return context.registerReceiver(receiver,intentFilter,Context.RECEIVER_NOT_EXPORTED);
        }else {
            return context.registerReceiver(receiver,intentFilter);
        }
    }

    public static Intent registerReceiver(final Context context, final BroadcastReceiver receiver,
                                          final IntentFilter intentFilter,String broadcastPermission, Handler scheduler) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return context.registerReceiver(receiver,intentFilter,broadcastPermission,scheduler,Context.RECEIVER_NOT_EXPORTED);
        }else {
            return context.registerReceiver(receiver,intentFilter,broadcastPermission,scheduler);
        }
    }
}
