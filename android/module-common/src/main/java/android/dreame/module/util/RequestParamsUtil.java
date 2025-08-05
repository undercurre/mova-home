package android.dreame.module.util;

import static android.dreame.module.data.network.SignSignAgainKt.signSignAgain;

import android.dreame.module.LocalApplication;
import android.util.Log;

import com.dreame.hacklibrary.HackJniHelper;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;

import java.util.Comparator;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

public class RequestParamsUtil {

    private static final String TAG = "RequestParamsUtil";

    private static Comparator<String> getComparator() {
        Comparator<String> c = new Comparator<String>() {
            public int compare(String o1, String o2) {
                return o1.compareTo(o2);
            }
        };
        return c;
    }

    private static void sortJSONByKey(JsonElement e) {

        if (e.isJsonNull()) {
            return;
        }

        if (e.isJsonPrimitive()) {
            return;
        }

        if (e.isJsonArray()) {
            JsonArray a = e.getAsJsonArray();
            for (Iterator<JsonElement> it = a.iterator(); it.hasNext(); ) {
                sortJSONByKey(it.next());
            }
            return;
        }

        if (e.isJsonObject()) {
            Map<String, JsonElement> tm = new TreeMap<String, JsonElement>(getComparator());
            for (Map.Entry<String, JsonElement> en : e.getAsJsonObject().entrySet()) {
                tm.put(en.getKey(), en.getValue());
            }

            for (Map.Entry<String, JsonElement> en : tm.entrySet()) {
                e.getAsJsonObject().remove(en.getKey());
                e.getAsJsonObject().add(en.getKey(), en.getValue());
                sortJSONByKey(en.getValue());
            }
            return;
        }
    }

    private static String subSplicingParams(JsonElement e) {
        StringBuilder strBuilder = new StringBuilder("[");
        Set<Map.Entry<String, JsonElement>> entries = e.getAsJsonObject().entrySet();
        for (Map.Entry<String, JsonElement> entry : entries) {
            if (!entry.getValue().isJsonArray()
                    && !entry.getValue().isJsonObject()
            ) {
                strBuilder.append(entry.getKey())
                        .append("=")
                        .append(entry.getValue())
                        .append("&");
            } else if (entry.getValue().isJsonObject()) {
                strBuilder.append(entry.getKey())
                        .append("=")
                        .append(subSplicingParams(entry.getValue()))
                        .append("&");
            }
        }
        return strBuilder.substring(0, strBuilder.length() - 1) + "]";
    }

    private static String splicingParams(JsonElement e) {
        StringBuilder strBuilder = new StringBuilder();
        Set<Map.Entry<String, JsonElement>> entries = e.getAsJsonObject().entrySet();
        for (Map.Entry<String, JsonElement> entry : entries) {
            if (!entry.getValue().isJsonArray()
                    && !entry.getValue().isJsonObject()
            ) {
                strBuilder.append(entry.getKey())
                        .append("=")
                        .append(getJsonValue(entry.getValue()))
                        .append("&");
            } else if (entry.getValue().isJsonObject()) {
                strBuilder.append(entry.getKey())
                        .append("=")
                        .append(subSplicingParams(entry.getValue()))
                        .append("&");
            } else if (entry.getValue().isJsonArray()) {
                strBuilder.append(entry.getKey())
                        .append("=")
                        .append(getJsonValue(entry.getValue()))
                        .append("&");
            }
        }
        return strBuilder.substring(0, strBuilder.length() - 1);
    }

    private static Object getJsonValue(JsonElement element) {
        JsonPrimitive e;
        if (element.isJsonPrimitive()) {
            e = (JsonPrimitive) element;
        } else {
            return element;
        }

        if (e.isBoolean()) {
            return element.getAsBoolean();
        }
        if (e.isNumber()) {
            return element.getAsNumber();
        }
        if (e.isString()) {
            return element.getAsString();
        }
        return null;
    }

    /**
     * 加签
     *
     * @param jsonParams
     * @return
     */
    public static String signParams(String jsonParams) {
        return signParams(jsonParams, false);
    }

    public static String signParams(String jsonParams, boolean signAgain) {
        JsonElement e = new JsonParser().parse(jsonParams);
        sortJSONByKey(e);
        StringBuilder splicingParamsBuilder = new StringBuilder(splicingParams(e));
        long timestamp = System.currentTimeMillis();
        splicingParamsBuilder.append(timestamp);
        String resultParams = splicingParamsBuilder.toString();
        LogUtil.d(TAG, "signParams: " + resultParams);
        String sign = HackJniHelper.signParams(splicingParamsBuilder.toString(), signAgain ? 1 : 0);
        LogUtil.d(TAG, "signParams: " + sign);
        JsonObject asJsonObject = e.getAsJsonObject();
        asJsonObject.addProperty("sign", sign);
        asJsonObject.addProperty("timestamp", timestamp);
        return asJsonObject.toString();
    }


}
