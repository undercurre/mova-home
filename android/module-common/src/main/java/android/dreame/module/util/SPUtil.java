package android.dreame.module.util;

import android.content.Context;
import android.content.SharedPreferences;
import android.dreame.module.LocalApplication;

import com.dreame.hacklibrary.HackJniHelper;
import com.tencent.mmkv.MMKV;

public class SPUtil {
    /**
     * 保存在手机里面的文件名
     */
    public static final String FILE_NAME = "android.dreame.module_preferences";

    /**
     * MMKV创建方法,会自动迁移旧数据
     *
     * @param context    Context上下文
     * @param spFileName sp文件名
     * @return SharedPreferences
     */
    public static MMKV createPreference(Context context, String spFileName) {
        return MMKV.mmkvWithID(spFileName, MMKV.MULTI_PROCESS_MODE, HackJniHelper.getCryptKey());
    }

    public static void defaultPut(Context context, String spFileName, String key, Object object) {
        SharedPreferences sp = context.getSharedPreferences(spFileName, Context.MODE_MULTI_PROCESS);
        SharedPreferences.Editor editor = sp.edit();
        if (object instanceof String) {
            editor.putString(key, (String) object);
        } else if (object instanceof Integer) {
            editor.putInt(key, (Integer) object);
        } else if (object instanceof Boolean) {
            editor.putBoolean(key, (Boolean) object);
        } else if (object instanceof Float) {
            editor.putFloat(key, (Float) object);
        } else if (object instanceof Long) {
            editor.putLong(key, (Long) object);
        } else {
            editor.putString(key, object.toString());
        }
        editor.commit();
    }


    public static void put(Context context, String spFileName, String key, Object object) {
        SharedPreferences sp = createPreference(context, spFileName);
        SharedPreferences.Editor editor = sp.edit();

        if (object instanceof String) {
            editor.putString(key, (String) object);
        } else if (object instanceof Integer) {
            editor.putInt(key, (Integer) object);
        } else if (object instanceof Boolean) {
            editor.putBoolean(key, (Boolean) object);
        } else if (object instanceof Float) {
            editor.putFloat(key, (Float) object);
        } else if (object instanceof Long) {
            editor.putLong(key, (Long) object);
        } else {
            editor.putString(key, object.toString());
        }
    }

    public static Object defaultGet(Context context, String spFileName, String key, Object defaultObject) {
        SharedPreferences sp = context.getSharedPreferences(spFileName, Context.MODE_MULTI_PROCESS);
        if (defaultObject instanceof String) {
            return sp.getString(key, (String) defaultObject);
        } else if (defaultObject instanceof Integer) {
            return sp.getInt(key, (Integer) defaultObject);
        } else if (defaultObject instanceof Boolean) {
            return sp.getBoolean(key, (Boolean) defaultObject);
        } else if (defaultObject instanceof Float) {
            return sp.getFloat(key, (Float) defaultObject);
        } else if (defaultObject instanceof Long) {
            return sp.getLong(key, (Long) defaultObject);
        }

        return null;
    }

    public static void putString(Context context, String spFileName, String key, String stringData) {
        SharedPreferences sp = createPreference(context, spFileName);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString(key, stringData);
    }

    public static Object get(Context context, String key, Object defaultObject) {
        return get(context, FILE_NAME, key, defaultObject);
    }

    public static void put(Context context, String key, Object object) {
        put(context, FILE_NAME, key, object);
    }

    public static Object get(Context context, String spFileName, String key, Object defaultObject) {
        SharedPreferences sp = createPreference(context, spFileName);

        if (defaultObject instanceof String) {
            return sp.getString(key, (String) defaultObject);
        } else if (defaultObject instanceof Integer) {
            return sp.getInt(key, (Integer) defaultObject);
        } else if (defaultObject instanceof Boolean) {
            return sp.getBoolean(key, (Boolean) defaultObject);
        } else if (defaultObject instanceof Float) {
            return sp.getFloat(key, (Float) defaultObject);
        } else if (defaultObject instanceof Long) {
            return sp.getLong(key, (Long) defaultObject);
        }

        return null;
    }

    public static String getString(Context context, String key, String dataDefault) {
        return getString(context, FILE_NAME, key, dataDefault);
    }

    public static String getString(Context context, String spFileName, String key, String dataDefault) {
        SharedPreferences sp = createPreference(context, spFileName);
        return sp.getString(key, dataDefault);
    }

    public static boolean getBoolean(Context context, String key, boolean dataDefault) {
        return getBoolean(context, FILE_NAME, key, dataDefault);
    }

    public static boolean getBoolean(Context context, String spFileName, String key, boolean dataDefault) {
        SharedPreferences sp = createPreference(context, spFileName);
        return sp.getBoolean(key, dataDefault);
    }

    public static long getLong(Context context, String key, long dataDefault) {
        return getLong(context, FILE_NAME, key, dataDefault);
    }

    public static long getLong(Context context, String spFileName, String key, long dataDefault) {
        SharedPreferences sp = createPreference(context, spFileName);
        return sp.getLong(key, dataDefault);
    }

    /**
     * 移除某个key值已经对应的值
     */
    public static void remove(Context context, String spFileName, String key) {
        SharedPreferences sp = createPreference(context, spFileName);
        SharedPreferences.Editor editor = sp.edit();
        editor.remove(key);
    }

    /**
     * 清除所有数据
     */
    public static void clear(Context context, String spFileName) {
        SharedPreferences sp = createPreference(context, spFileName);
        SharedPreferences.Editor editor = sp.edit();
        editor.clear();
    }

    /**
     * 查询某个key是否已经存在
     */
    public static boolean contains(Context context, String spFileName, String key) {
        SharedPreferences sp = createPreference(context, spFileName);
        return sp.contains(key);
    }

    /**
     * 返回所有的键
     */
    public static String[] getAll(Context context, String spFileName) {
        MMKV mmkv = createPreference(context, spFileName);
        return mmkv.allKeys();
    }

    public static SharedPreferences createAndroidSp(Context context, String spFileName){
        SharedPreferences sharedPreferences = context.getSharedPreferences(spFileName,Context.MODE_PRIVATE);
        return sharedPreferences;
    }

    /**
     * 移除某个key值已经对应的值
     */
    public static void removeDefault(Context context, String spFileName, String key) {
        SharedPreferences sp = createAndroidSp(context, spFileName);
        SharedPreferences.Editor editor = sp.edit();
        editor.remove(key)
        .commit();
    }

    /**
     * 移除某个key值已经对应的值
     */
    public static void clearDefault(Context context, String spFileName) {
        SharedPreferences sp = createAndroidSp(context, spFileName);
        SharedPreferences.Editor editor = sp.edit();
        editor.clear()
                .commit();
    }
}
