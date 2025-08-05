// IProcessEventManager.aidl
package android.dreame.module;
import android.dreame.module.IFileDownloadCallback;
interface IProcessEventManager {

    void init();

    void release();

    void getCommonPlugin(String appVersion, String pluginType, int minVersion, IFileDownloadCallback fileDownloadCallback);

    void openShopPage(String path, String params);

    void openZendeskChat();
}