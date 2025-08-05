package android.dreame.module.rn.bridge;


import android.dreame.module.rn.bridge.device.BasicDeviceModule;
import android.dreame.module.rn.bridge.device.BluetoothModuleV2;
import android.dreame.module.rn.bridge.device.WifiManagerModule;
import android.dreame.module.rn.bridge.host.AudioModule;
import android.dreame.module.rn.bridge.host.CryptoModule;
import android.dreame.module.rn.bridge.host.FileModule;
import android.dreame.module.rn.bridge.host.LocaleModule;
import android.dreame.module.rn.bridge.host.MediaPlayerModule;
import android.dreame.module.rn.bridge.host.StorageModule;
import android.dreame.module.rn.bridge.host.UIModule;
import android.dreame.module.rn.bridge.service.AccountModule;
import android.dreame.module.rn.bridge.service.SmartHomeModule;
import android.dreame.module.rn.bridge.system.LocationModule;
import android.dreame.module.rn.bridge.system.SecretModule;
import android.dreame.module.rn.bridge.system.SettingModule;
import android.dreame.module.rn.bridge.video.AgoraModule;
import android.dreame.module.rn.bridge.video.AgoraRawDataModule;
import android.dreame.module.rn.bridge.video.AliCheckModule;

import com.dreame.plugin.video.tx.dreame_flutter_plugin_tx_video.rn.TXVideoPlayerManager;
import com.dreame.plugin.video.tx.dreame_flutter_plugin_tx_video.rn.TXVideoPlayerModule;

import androidx.annotation.NonNull;

import com.dreame.sdk.alify.rn.AliVideoPlayerManager;
import com.dreame.sdk.alify.rn.AliVideoPlayerModule;
import com.dreame.sdk.js_executor.JsExecutorModule;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.facebook.v8.reactexecutor.V8ExecutorFactory;
import com.imagepicker.ImagePickerModule;


import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class SDKPackage implements ReactPackage {
    @NonNull
    @Override
    public List<NativeModule> createNativeModules(@NonNull ReactApplicationContext reactContext) {
        List<NativeModule> list = Arrays.asList(
                new SDKModule(reactContext),
                new CryptoModule(reactContext),
                new JsExecutorModule(reactContext, new V8ExecutorFactory()),
                new PackageModule(reactContext),
                new ServiceModule(reactContext),
                new LocaleModule(reactContext),
                new HostModule(reactContext),
                new DeviceModule(reactContext),
                new BasicDeviceModule(reactContext),
                new SmartHomeModule(reactContext),
                new UIModule(reactContext),
                new FileModule(reactContext),
                new AccountModule(reactContext),
                new StorageModule(reactContext),
                new LocationModule(reactContext),
                new RNSmartassetsModule(reactContext),
                new AudioModule(reactContext),
                new AgoraModule(reactContext),
                new SplashScreenModule(reactContext),
                new AgoraRawDataModule(reactContext),
                new AliVideoPlayerModule(reactContext),
                new AliCheckModule(reactContext),
                new TXVideoPlayerModule(reactContext),
                new BluetoothModuleV2(reactContext),
                new WifiManagerModule(reactContext),
                new SecretModule(reactContext),
                new SettingModule(reactContext),
                new MediaPlayerModule(reactContext)
        );
        final ImagePickerModule imagePickerModule = addImagePickerModule(reactContext);
        if (imagePickerModule != null) {
            list = new ArrayList<>(list);
            list.add(imagePickerModule);
        }
        return list;
    }

    /**
     * 解决ImagePickerModule在RN中找不到的问题
     *
     * @param reactContext
     * @return
     */
    private ImagePickerModule addImagePickerModule(@NonNull ReactApplicationContext reactContext) {
        try {
            Class<?> clazz = Class.forName("com.imagepicker.ImagePickerModule");
            Constructor<?> constructor = clazz.getDeclaredConstructor(ReactApplicationContext.class);
            constructor.setAccessible(true);
            return (ImagePickerModule) constructor.newInstance(reactContext);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @NonNull
    @Override
    public List<ViewManager> createViewManagers(@NonNull ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
                new StringPickerManager(reactContext),
                new MHImageViewManager(),
                new AliVideoPlayerManager(),
                new TXVideoPlayerManager(),
                new RockerViewManager(),
                new GifImageViewManager()
        );
    }
}
