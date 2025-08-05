package android.dreame.module.util;

import android.text.TextUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class GsonUtils {
    private static Gson gson;

    static {
        gson = new Gson();
    }

    private GsonUtils() {

    }

    public static Gson getGson() {
        return gson;
    }

    public static String toJson(Object obj) {
        return gson.toJson(obj);
    }

    /**
     * 将json转化为对应的实体对象
     * new TypeToken<HashMap<String, Object>>(){}.getType()
     */
    public static <T> T fromJson(String json, Type type) {
        return gson.fromJson(json, type);
    }

    /**
     * <p>
     * Json格式转换, 由JSON字符串转化到制定类型T
     *
     * @param json
     * @param cls
     * @return T
     * <p>
     * </p>
     */
    public static <T> T parseObject(String json, Class<T> cls) {
        try {
            if (TextUtils.isEmpty(json)) {
                return null;
            }
            if (gson == null) {
                gson = new GsonBuilder().disableHtmlEscaping().create();

            }
            return gson.fromJson(json, cls);
        } catch (Exception e) {
            e.printStackTrace();
            LogUtil.e(e.getMessage());

        }
        return null;
    }

    /**
     * 转成map的
     *
     * @param gsonString
     * @return
     */
    public static <T> Map<String, T> parseMaps(String gsonString) {
        Map<String, T> map = null;
        if (gson != null) {
            map = gson.fromJson(gsonString, new TypeToken<Map<String, T>>() {
            }.getType());
        }
        return map;
    }

    public static <T> Map<String, T> parseMap2(String gsonString, Class<T> cls) {
        Map<String, T> resultMap = new HashMap<>();
        try{
            JsonObject jsonObject = JsonParser.parseString(gsonString).getAsJsonObject();
            final Set<String> keys = jsonObject.keySet();
            for (String key : keys) {
                final JsonElement element = jsonObject.get(key);
                T o = gson.fromJson(element, cls);
                resultMap.put(key, o);
            }
        }catch (Exception exception){
            exception.printStackTrace();
        }
        return resultMap;

    }

    /**
     * json字符串转成list
     *
     * @param json
     * @param cls
     * @return
     */
    public static <T> List<T> parseLists(String json, Class<T> cls) {
        List<T> list = new ArrayList<T>();
        JsonArray array = new JsonParser().parse(json).getAsJsonArray();
        for (final JsonElement elem : array) {
            list.add(gson.fromJson(elem, cls));
        }
        return list;
    }

}
