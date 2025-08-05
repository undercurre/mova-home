package android.dreame.module.rn.load;

import android.app.Application;

import com.facebook.react.ReactPackage;
import com.facebook.soloader.SoLoader;

import java.util.List;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/04/26
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class ReactAppRuntime {

    private Application mApplication;
    private List<ReactPackage> mPackages;
    private String bundleAssetName;

    private static class SingletonHolder {
        private static final ReactAppRuntime INSTANCE = new ReactAppRuntime();
    }

    private ReactAppRuntime() {
    }

    public List<ReactPackage> getPackages() {
        return mPackages;
    }

    public ReactAppRuntime setPackages(List<ReactPackage> mPackages) {
        this.mPackages = mPackages;
        return this;
    }

    public void init(Application application) {
        SingletonHolder.INSTANCE.mApplication = application;
        SoLoader.init(application,false);
    }

    public static ReactAppRuntime getInstance() {
        return SingletonHolder.INSTANCE;
    }

    public Application getApplication() {
        return getInstance().mApplication;
    }
}
