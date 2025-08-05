package com.dreame.tools.module_debug;

import android.app.ActivityManager;
import android.content.Context;
import android.util.Log;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.List;

public class HackHelper {

    public void hackaaa() {
        //
        // ActivityManager am = (ActivityManager) cxt.getSystemService(Context.ACTIVITY_SERVICE);
        // List<ActivityManager.RunningAppProcessInfo> runningApps = am.getRunningAppProcesses();
        // if(runningApps ==null)
        //
        // {
        //     return null;
        // }
        // for(
        //         ActivityManager.RunningAppProcessInfo procInfo :runningApps)
        //
        // {
        //     if (procInfo.pid == pid) {
        //         return procInfo.processName;
        //     }
        // }
    }

    public static void hookTest() {
        try {
            hookAM();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }
    /**
     * ActivityManager 替换为代理
     *
     * @throws ClassNotFoundException
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */
    public static void hookAM() throws ClassNotFoundException, NoSuchFieldException, IllegalAccessException {
        Class<?> amnClass = Class.forName("android.app.ActivityManagerNative");
        //获取单例对象 Singleton<IActivityManager> ，变量名 gDefault 私有
        Field gDefaultField = amnClass.getDeclaredField("gDefault");
        //禁止JAVA 进行语言访问检查，private 等修饰的就可以访问操作了
        gDefaultField.setAccessible(true);
        //If the underlying field is a static field, the obj argument is ignored; it may be null.
        //静态属性，直接传入 Null。获取ActivityManagerNative 中的 gDefault
        Object gDefault = gDefaultField.get(null);

        Class<?> singletonClass = Class.forName("android.util.Singleton");
        Field mInstanceField = singletonClass.getDeclaredField("mInstance");
        mInstanceField.setAccessible(true);

        //调用 Singleton 的 get方法 取出 instance 对象
        //instance 对象即 ActivityManager
        Object instance = mInstanceField.get(gDefault);

        //创建代理 handler
        ActivityManagerHandler handler = new ActivityManagerHandler(instance);
        //反射 IActivityManager接口 Class 文件
        Class<?> amClass = Class.forName("android.app.IActivityManager");
        //创建代理对象
        Object amProxy = Proxy.newProxyInstance(ClassLoader.getSystemClassLoader(), new Class[]{amClass}, handler);

        //将gDefault中的 Instance 置换为代理
        mInstanceField.set(gDefault, amProxy);
    }

    /**
     * 代理对象回调
     */
    private static class ActivityManagerHandler implements InvocationHandler {
        private Object am;

        public ActivityManagerHandler(Object am) {
            this.am = am;
        }

        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            Log.e("APIHook", "正在调用的方法--->" + method.getName());
            return method.invoke(am, args);
        }
    }

}
