// Copyright (c) 2019-present, iQIYI, Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

// Created by caikelun on 2019-03-07.
package android.dreame.module.util.log;

import android.annotation.SuppressLint;
import android.dreame.module.LocalApplication;
import android.dreame.module.trace.EventCommonHelper;
import android.dreame.module.trace.ExceptionStatisticsEventCode;
import android.dreame.module.trace.ModuleCode;
import android.dreame.module.util.LogUtil;
import android.os.Process;
import android.util.Log;

import androidx.annotation.NonNull;

import java.lang.Thread.UncaughtExceptionHandler;

@SuppressLint("StaticFieldLeak")
public class JavaCrashHandler implements UncaughtExceptionHandler {
    private static final JavaCrashHandler instance = new JavaCrashHandler();

    private JavaCrashHandler() {
    }

    private UncaughtExceptionHandler defaultHandler;

    public static JavaCrashHandler getInstance() {
        return instance;
    }

    public void initialize() {
        try {
            this.defaultHandler = Thread.getDefaultUncaughtExceptionHandler();
            if (defaultHandler != this) {
                Thread.setDefaultUncaughtExceptionHandler(this);
            }
        } catch (Exception e) {
            Log.e("JavaCrashHandler", "JavaCrashHandler setDefaultUncaughtExceptionHandler failed", e);
        }
    }

    @Override
    public void uncaughtException(Thread thread, @NonNull Throwable throwable) {
        LogUtil.e("JavaCrashHandler", "uncaughtException: " + thread.getName() + " " + Log.getStackTraceString(throwable));
        try {
            LogUtil.close();
        } catch (Exception e) {
            Log.e("JavaCrashHandler", "JavaCrashHandler handleException failed", e);
        }

        // FIXME: 此处可能在子进程操作数据库
        EventCommonHelper.INSTANCE.eventCommonPageInsert(ModuleCode.ExceptionStatistics.getCode(), ExceptionStatisticsEventCode.AppCrash.getCode(), 0, 0, "0", "",
                0, 0, 0, 0, 0, "", "", "", throwable.getMessage());

        // FIXME 2022/3/24 子进程 kill
        if (LocalApplication.getCurrentProcessName().endsWith(":plugin")) {
            Process.killProcess(Process.myPid());
            return;
        }
        try {
            Thread.setDefaultUncaughtExceptionHandler(defaultHandler);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (this.defaultHandler != null) {
            this.defaultHandler.uncaughtException(thread, throwable);
        }
    }
}
