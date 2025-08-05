package com.dreame.tools.module_debug;

import android.app.Application;
import android.util.Log;

import com.didichuxing.doraemonkit.DoKit;

public class ApplicationDelegate {
    public static void initDokit(Application application) {
        new DoKit.Builder(application)
                .productId("92fd8fddb20ef895d509925f611d48ff")
                .build();

        if (!DoKit.isInit()) {
            Log.d("sunzhibin", "initDokit: failed");
        }
    }
}
