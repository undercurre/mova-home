package android.dreame.module.rn.bridge;

import android.dreame.module.rn.load.BasicRNHost;
import android.dreame.module.rn.load.RnLoaderCache;
import android.dreame.module.util.LogUtil;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;

import java.io.File;
import java.io.FileFilter;
import java.util.HashMap;
import java.util.Map;

public class RNSmartassetsModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNSmartassetsModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        HashMap<String, Object> constants = new HashMap<>();
        BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(RnLoaderCache.getCurrentDevice(getReactApplicationContext()).getDid());
        if(basicRNHost != null){
            final String inUsePluginPath = basicRNHost.getInUsePluginPath();
            final String inUseSdkPath = basicRNHost.getInUseSdkPath();
            LogUtil.i("sunzhibin", "getConstants: inUsePluginPathL " + inUsePluginPath + " ,inUseSdkPath: " + inUseSdkPath);
            constants.put("sdkPath", inUseSdkPath);
            constants.put("pluginPath", inUsePluginPath);
            constants.put("resPath", "");
        }
        return constants;
    }

    @Override
    public String getName() {
        return "Smartassets";
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    public boolean isFileExist(String filePath) {
        if (filePath == null) {
            return false;
        }
        File imageFile = new File(filePath.replace("file://", ""));
        return (imageFile.exists());
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    public String relateMainBundleAssetsPath() {
        BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(RnLoaderCache.getCurrentDevice(getReactApplicationContext()).getDid());
        if(basicRNHost != null){
            final String inUsePluginPath = basicRNHost.getInUsePluginPath();
            final String inUseSdkPath = basicRNHost.getInUseSdkPath();
            return inUseSdkPath;
        }else{
            return  "";
        }
    }

    @ReactMethod(isBlockingSynchronousMethod = true)
    public String projectBundleAssetsPath() {
        BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(RnLoaderCache.getCurrentDevice(getReactApplicationContext()).getDid());
        if(basicRNHost != null){
            final String inUsePluginPath = basicRNHost.getInUsePluginPath();
            final String inUseSdkPath = basicRNHost.getInUseSdkPath();
            return inUsePluginPath;
        }else{
            return "";
        }
    }

    @ReactMethod
    public void travelDrawable(String bundlePath, Callback callback) {
        WritableArray fileMaps = Arguments.createArray();
        File bundleFile = new File(bundlePath);
        File bundleDir = bundleFile.getParentFile();
        if (bundleDir.isDirectory()) {
            FileFilter filter = new FileFilter() {
                @Override
                public boolean accept(File file) {
                    return file != null && file.getName().startsWith("drawable") && file.isDirectory();
                }
            };
            File[] drawableDirs = bundleDir.listFiles(filter);
            if (drawableDirs != null) {
                for (File dir : drawableDirs) {
                    String parentPath = dir.getAbsolutePath();
                    String[] files = dir.list();
                    for (String file : files) {
                        fileMaps.pushString("file://" + parentPath + File.separator + file);
                    }
                }
                callback.invoke(fileMaps);
            }
        }
    }
}
