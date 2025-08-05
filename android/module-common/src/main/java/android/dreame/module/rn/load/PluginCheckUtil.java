package android.dreame.module.rn.load;

import android.dreame.module.util.LogUtil;
import android.dreame.module.util.MD5Util;
import android.text.TextUtils;

import java.io.File;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/06/09
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class PluginCheckUtil {

    public static boolean checkFileMd5(String filePath, String fileMd5) {
        File sdkFile = new File(filePath);
        if (!sdkFile.exists()) {
            LogUtil.e("PluginCheckUtil", "checkFileMd5: !sdkFile.exists(): " + sdkFile.getPath());
            return false;
        }
        String sdkFileMd5 = MD5Util.getFileMD5(sdkFile);
        if (TextUtils.isEmpty(sdkFileMd5)) {
            LogUtil.e("PluginCheckUtil", "checkFileMd5: sdkFileMd5.isEmpty: " + sdkFileMd5);
            return false;
        }

        final boolean b = TextUtils.equals(fileMd5, sdkFileMd5);
        if (!b) {
            LogUtil.e("PluginCheckUtil", "checkFileMd5: fileMd5: " + fileMd5 + " , sdkFileMd5: " + sdkFileMd5
                    + " ,sdkFile: " + sdkFile.getPath());
        }
        return b;
    }
}
