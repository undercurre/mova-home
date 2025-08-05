package android.dreame.module.util;

import android.dreame.module.BuildConfig;
import android.dreame.module.task.LogModuleInitTask;
import android.util.Log;

/**
 * Created by Administrator on 2017/6/14.
 * Email:2856992713@qq.com
 * Log日志
 */
public final class LogUtil {

    /**
     * Don't let anyone instantiate this class.
     */
    private LogUtil() {
        throw new Error("Do not need instantiate!");
    }

    /**
     * Master switch.To catch error info you need set this value below Log.WARN
     */
    public static int DEBUG_LEVEL = BuildConfig.DEBUG ? 0 : Log.INFO;

    /**
     * 'System.out' switch.When it is true, you can see the 'System.out' log.
     * Otherwise, you cannot.
     */
    public static final boolean DEBUG_SYSOUT = false;

    public static void flush() {
        String tag = getClassName();
        flush(tag);
    }

    public static void flush(String tag) {
        e(tag, "flush log to file");
        logFlush();
    }

    public static void close() {
        e("close", "close log to file");
        logClose();
    }

    /**
     * Send a {@link Log#VERBOSE} log message.
     *
     * @param obj
     */
    public static void v(Object obj) {
        if (Log.VERBOSE >= DEBUG_LEVEL) {
            String tag = getClassName();
            String msg = obj != null ? obj.toString() : "obj == null";
            v(tag, msg);
        }
    }

    /**
     * Send a {@link #DEBUG_LEVEL} log message.
     *
     * @param obj
     */
    public static void d(Object obj) {
        if (Log.DEBUG >= DEBUG_LEVEL) {
            String tag = getClassName();
            String msg = obj != null ? obj.toString() : "obj == null";
            d(tag, msg);
        }
    }

    /**
     * Send an {@link Log#INFO} log message.
     *
     * @param obj
     */
    public static void i(Object obj) {
        if (Log.INFO >= DEBUG_LEVEL) {
            String tag = getClassName();
            String msg = obj != null ? obj.toString() : "obj == null";
            i(tag, msg);
        }
    }

    /**
     * Send a {@link Log#WARN} log message.
     *
     * @param obj
     */
    public static void w(Object obj) {
        if (Log.WARN >= DEBUG_LEVEL) {
            String tag = getClassName();
            String msg = obj != null ? obj.toString() : "obj == null";
            w(tag, msg);
        }
    }

    /**
     * Send an {@link Log#ERROR} log message.
     *
     * @param obj
     */
    public static void e(Object obj) {
        if (Log.ERROR >= DEBUG_LEVEL) {
            String tag = getClassName();
            String msg = obj != null ? obj.toString() : "obj == null";
            e(tag, msg);
        }
    }

    /**
     * What a Terrible Failure: Report a condition that should never happen. The
     * error will always be logged at level ASSERT with the call stack.
     * Depending on system configuration, a report may be added to the
     * {@link android.os.DropBoxManager} and/or the process may be terminated
     * immediately with an error dialog.
     *
     * @param obj
     */
    public static void wtf(Object obj) {
        if (Log.ASSERT >= DEBUG_LEVEL) {
            String tag = getClassName();
            String msg = obj != null ? obj.toString() : "obj == null";
            wtf(tag, msg);
        }
    }

    /**
     * Send a {@link Log#VERBOSE} log message.
     *
     * @param tag Used to identify the source of a log message. It usually
     *            identifies the class or activity where the log call occurs.
     * @param msg The message you would like logged.
     */
    public static void v(String tag, String msg) {
        if (Log.VERBOSE >= DEBUG_LEVEL) {
            Log.v(tag, msg);
        }
    }

    /**
     * Send a {@link #DEBUG_LEVEL} log message.
     *
     * @param tag Used to identify the source of a log message. It usually
     *            identifies the class or activity where the log call occurs.
     * @param msg The message you would like logged.
     */
    public static void d(String tag, String msg) {
        if (Log.DEBUG >= DEBUG_LEVEL) {
            logWriter(tag, msg, Log.DEBUG);
        }
    }

    /**
     * Send an {@link Log#INFO} log message.
     *
     * @param tag Used to identify the source of a log message. It usually
     *            identifies the class or activity where the log call occurs.
     * @param msg The message you would like logged.
     */
    public static void i(String tag, String msg) {
        if (Log.INFO >= DEBUG_LEVEL) {
            logWriter(tag, msg, Log.INFO);
        }
    }

    /**
     * Send a {@link Log#WARN} log message.
     *
     * @param tag Used to identify the source of a log message. It usually
     *            identifies the class or activity where the log call occurs.
     * @param msg The message you would like logged.
     */
    public static void w(String tag, String msg) {
        if (Log.WARN >= DEBUG_LEVEL) {
            logWriter(tag, msg, Log.WARN);
        }
    }

    /**
     * Send an {@link Log#ERROR} log message.
     *
     * @param tag Used to identify the source of a log message. It usually
     *            identifies the class or activity where the log call occurs.
     * @param msg The message you would like logged.
     */
    public static void e(String tag, String msg) {
        if (Log.ERROR >= DEBUG_LEVEL) {
            logWriter(tag, msg, Log.ERROR);
        }
    }

    /**
     * What a Terrible Failure: Report a condition that should never happen. The
     * error will always be logged at level ASSERT with the call stack.
     * Depending on system configuration, a report may be added to the
     * {@link android.os.DropBoxManager} and/or the process may be terminated
     * immediately with an error dialog.
     *
     * @param tag Used to identify the source of a log message.
     * @param msg The message you would like logged.
     */
    public static void wtf(String tag, String msg) {
        if (Log.ASSERT >= DEBUG_LEVEL) {
            Log.wtf(tag, msg);
        }
    }

    /**
     * Send a {@link Log#VERBOSE} log message. And just print method name and
     * position in black.
     */
    public static void print() {
        if (Log.VERBOSE >= DEBUG_LEVEL) {
            String tag = getClassName();
            String method = callMethodAndLine();
            v(tag, method);
            if (DEBUG_SYSOUT) {
                System.out.println(tag + "  " + method);
            }
        }
    }

    /**
     * Send a {@link #DEBUG_LEVEL} log message.
     *
     * @param object The object to print.
     */
    public static void print(Object object) {
        if (Log.DEBUG >= DEBUG_LEVEL) {
            String tag = getClassName();
            String method = callMethodAndLine();
            String content = "";
            if (object != null) {
                content = object.toString() + "                    ----    "
                        + method;
            } else {
                content = " ## " + "                ----    " + method;
            }
            d(tag, content);
            if (DEBUG_SYSOUT) {
                System.out.println(tag + "  " + content + "  " + method);
            }
        }
    }

    /**
     * Send an {@link Log#ERROR} log message.
     *
     * @param object The object to print.
     */
    public static void printError(Object object) {
        if (Log.ERROR >= DEBUG_LEVEL) {
            String tag = getClassName();
            String method = callMethodAndLine();
            String content = "";
            if (object != null) {
                content = object.toString() + "                    ----    "
                        + method;
            } else {
                content = " ## " + "                    ----    " + method;
            }
            e(tag, content);
            if (DEBUG_SYSOUT) {
                System.err.println(tag + "  " + method + "  " + content);
            }
        }
    }

    /**
     * Print the array of stack trace elements of this method in black.
     *
     * @return
     */
    public static void printCallHierarchy() {
        if (Log.VERBOSE >= DEBUG_LEVEL) {
            String tag = getClassName();
            String method = callMethodAndLine();
            String hierarchy = getCallHierarchy();
            v(tag, method + hierarchy);
            if (DEBUG_SYSOUT) {
                System.out.println(tag + "  " + method + hierarchy);
            }
        }
    }

    /**
     * Print debug log in blue.
     *
     * @param object The object to print.
     */
    public static void printMyLog(Object object) {
        if (Log.DEBUG >= DEBUG_LEVEL) {
            String tag = "MYLOG";
            String method = callMethodAndLine();
            String content = "";
            if (object != null) {
                content = object.toString() + "                    ----    "
                        + method;
            } else {
                content = " ## " + "                ----    " + method;
            }
            d(tag, content);
            if (DEBUG_SYSOUT) {
                System.out.println(tag + "  " + content + "  " + method);
            }
        }
    }

    private static String getCallHierarchy() {
        String result = "";
        StackTraceElement[] trace = (new Exception()).getStackTrace();
        for (int i = 2; i < trace.length; i++) {
            result += "\r\t" + trace[i].getClassName() + ""
                    + trace[i].getMethodName() + "():"
                    + trace[i].getLineNumber();
        }
        return result;
    }

    private static String getClassName() {
        String result = "";
        StackTraceElement thisMethodStack = (new Exception()).getStackTrace()[2];
        result = thisMethodStack.getClassName();
        return result;
    }

    /**
     * Realization of double click jump events.
     *
     * @return
     */
    private static String callMethodAndLine() {
        String result = "at ";
        StackTraceElement thisMethodStack = (new Exception()).getStackTrace()[2];
        result += thisMethodStack.getClassName() + "";
        result += thisMethodStack.getMethodName();
        result += "(" + thisMethodStack.getFileName();
        result += ":" + thisMethodStack.getLineNumber() + ")  ";
        return result;
    }

    private static void logFlush() {
        try {
            LogModuleInitTask.Companion.logFlush();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("ERROR", "FLUSH logan need init first");
        }
    }

    private static void logClose() {
        LogModuleInitTask.Companion.logClose();

    }

    private static void logWriter(String tag, String msg, int info) {
        try {
            // fix：某些情况，xlog未初始化的情况
            if (LogModuleInitTask.getLOG_INIT()) {
                xlogWrite(tag, msg, info);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("ERROR", "WRITE logan need init first");
        }
    }

    private static void xlogWrite(String tag, String msg, int info) {
        switch (info) {
            case Log.VERBOSE:
                com.tencent.mars.xlog.Log.v(tag, msg);
                break;
            case Log.DEBUG:
                com.tencent.mars.xlog.Log.d(tag, msg);

                break;
            case Log.INFO:
                com.tencent.mars.xlog.Log.i(tag, msg);
                break;
            case Log.ASSERT:
            case Log.ERROR:
                com.tencent.mars.xlog.Log.e(tag, msg);
                break;
            case Log.WARN:
                com.tencent.mars.xlog.Log.w(tag, msg);
                break;
            default:
                break;
        }
    }

    private static boolean loganIsInit() {
        // try {
        //     Field field = Logan.class.getDeclaredField("sLoganControlCenter");
        //     field.setAccessible(true);
        //     Object o = field.get(Logan.class);
        //     return o != null;
        // } catch (Exception ex) {
        //     ex.printStackTrace();
        // }
        return false;
    }

}

