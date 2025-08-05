package android.dreame.module.util;

import android.content.Context;
import android.content.res.AssetManager;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

public class AssetsUtil {

    /**
     * 从assets获取字符串
     * @param context
     * @param fileName
     * @return
     */
    public static String getStrFromAssets(Context context, String fileName){
        try {
            AssetManager assetManager = context.getAssets(); // 获得assets资源管理器（assets中的文件无法直接访问，可以使用AssetManager访问）
            InputStreamReader inputStreamReader = new InputStreamReader(assetManager.open(fileName), StandardCharsets.UTF_8); // 使用IO流读取json文件内容
            BufferedReader br = new BufferedReader(inputStreamReader);
            String line;
            StringBuilder builder = new StringBuilder();
            while ((line = br.readLine())!=null){
                builder.append(line);
            }
            br.close();
            inputStreamReader.close();
            return builder.toString();
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
    }
}
