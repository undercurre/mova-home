package android.dreame.module.rn;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.dreame.module.R;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.constant.CommExtraConstant;
import android.dreame.module.constant.Constants;
import android.dreame.module.feature.connect.bluetooth.BluetoothLeManager;
import android.dreame.module.feature.connect.bluetoothv2.BleManagerImpl;
import android.dreame.module.feature.connect.bluetoothv2.MyBleConnectStateManager;
import android.dreame.module.manager.DeviceManager;
import android.dreame.module.rn.load.ReactAppRuntime;
import android.dreame.module.rn.load.RnLoaderCache;
import android.dreame.module.rn.utils.RNConstants;
import android.dreame.module.util.DarkThemeUtils;
import android.dreame.module.util.GsonUtils;
import android.dreame.module.util.SuperStatusUtil;
import android.dreame.module.view.ReloadJsButton;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactInstanceManagerBuilder;
import com.facebook.react.ReactPackage;
import com.facebook.react.ReactRootView;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.common.LifecycleState;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.modules.core.PermissionAwareActivity;
import com.facebook.react.modules.core.PermissionListener;
import com.facebook.v8.reactexecutor.V8ExecutorFactory;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RNDebugActivity extends AppCompatActivity implements DefaultHardwareBackBtnHandler, PermissionAwareActivity {
    private ReactRootView mReactRootView;
    private ReactInstanceManager mReactInstanceManager;
    private ReloadJsButton mReloadJsButton;
    private FrameLayout.LayoutParams mReloadJsBtnLp;
    private String mProjectPath = "";
    private PermissionListener permissionListener;
    public final static String PROJECTPATH = "PROJECTPATH";
    private DeviceListBean.Device device;
    private boolean isVideo;
    private String warningCode;
    private boolean showWarning;
    private String entranceType;
    private String extraData;
    private String source;
    private RNBleStateEventReceiver mBleStateReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        device = getIntent().getParcelableExtra(Constants.DEVICE);
        isVideo = getIntent().getBooleanExtra(CommExtraConstant.IS_FROM_VIDEO, false);
        if (device == null) {
            finish();
        }

        showWarning = getIntent().getBooleanExtra(CommExtraConstant.EXTRA_DEVICE_WARNING, false);
        warningCode = getIntent().getStringExtra(CommExtraConstant.EXTRA_DEVICE_WARNING_CODE);
        boolean isFromVideo = getIntent().getBooleanExtra(CommExtraConstant.IS_FROM_VIDEO, false);
        entranceType = getIntent().getStringExtra(CommExtraConstant.ENTRANCE_TYPE);
        extraData = getIntent().getStringExtra(CommExtraConstant.EXTRA_EXTRA_DATA);
        source = getIntent().getStringExtra(CommExtraConstant.EXTRA_SOURCE);

        if (showWarning) {
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("goWarning", showWarning);
                jsonObject.put("warnCode", warningCode);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            String jsonStr = jsonObject.toString();
            DeviceManager.getInstance().setDeviceWarning(jsonStr);
        } else {
            DeviceManager.getInstance().setDeviceWarning(null);
        }
        DeviceManager.getInstance().setVideo(isFromVideo);

        mProjectPath = getIntent().getStringExtra(PROJECTPATH);
        mReactRootView = new ReactRootView(this);
        loadJsBundle();
        FrameLayout frameLayout = new FrameLayout(this);
        addReloadJsButton(frameLayout);
        setContentView(frameLayout);
        SuperStatusUtil.hieStatusBarAndNavigationBar(getWindow().getDecorView());
        boolean isDark = DarkThemeUtils.isDarkTheme(this);
        SuperStatusUtil.setStatusBar(this, false, isDark, Color.TRANSPARENT);

        if (isFromVideo) {
            // 全屏
            getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                    | View.SYSTEM_UI_FLAG_FULLSCREEN);
        }
        registerBleStateReceiver();
    }

    private void registerBleStateReceiver() {
        if (mBleStateReceiver == null) {
            mBleStateReceiver = new RNBleStateEventReceiver();
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                registerReceiver(mBleStateReceiver, intentFilter, Context.RECEIVER_EXPORTED);
            } else {
                registerReceiver(mBleStateReceiver, intentFilter);
            }
        }
    }

    private void unregisterBleStateReceiver() {
        if (mBleStateReceiver != null) {
            unregisterReceiver(mBleStateReceiver);
            mBleStateReceiver = null;
        }
    }

    private void addReloadJsButton(FrameLayout frameLayout) {
        mReloadJsButton = new ReloadJsButton(this);
        mReloadJsButton.setBackgroundResource(R.drawable.shape_relaodjs);
        mReloadJsButton.setTextColor(Color.parseColor("#FFFFFF"));
        mReloadJsButton.setText("ReloadJS");
        mReloadJsButton.setGravity(Gravity.CENTER);
        frameLayout.addView(mReactRootView);
        frameLayout.addView(mReloadJsButton);
        mReloadJsBtnLp = (FrameLayout.LayoutParams) mReloadJsButton.getLayoutParams();
        mReloadJsBtnLp.width = 250;
        mReloadJsBtnLp.height = 250;
        mReloadJsBtnLp.gravity = Gravity.BOTTOM | Gravity.RIGHT;
        mReloadJsBtnLp.rightMargin = 20;
        mReloadJsBtnLp.bottomMargin = 100;
        mReloadJsButton.setLayoutParams(mReloadJsBtnLp);
        mReloadJsButton.setOnClickListener(() -> mReactInstanceManager.getDevSupportManager().handleReloadJS());
    }

    private void loadJsBundle() {
        List<ReactPackage> packages = ReactAppRuntime.getInstance().getPackages();
        ReactInstanceManagerBuilder mbuilder = ReactInstanceManager.builder();
        mbuilder = mbuilder
                .setApplication(getApplication())
                .setCurrentActivity(RNDebugActivity.this)
                .setJSMainModulePath(mProjectPath + "/index")
                .addPackages(packages)
                .setInitialLifecycleState(LifecycleState.RESUMED)
                .setDefaultHardwareBackBtnHandler(this)
                .setJavaScriptExecutorFactory(new V8ExecutorFactory())
                .setUseDeveloperSupport(true);
        String bundleAssetName = "index.bundle";
        mbuilder = mbuilder.setBundleAssetName(bundleAssetName);
        mReactInstanceManager = mbuilder.build();

        mReactInstanceManager.addReactInstanceEventListener(new ReactInstanceManager.ReactInstanceEventListener() {
            @Override
            public void onReactContextInitialized(ReactContext context) {
                RnLoaderCache.cacheDevice(context, device);
            }
        });
        mReactInstanceManager.createReactContextInBackground();
        mReactRootView.startReactApplication(mReactInstanceManager, device.getModel(), getLaunchOptions());
    }


    @Override
    public void invokeDefaultOnBackPressed() {
        super.onBackPressed();
    }

    public ReactContext getCurrentReactContext() {
        return mReactInstanceManager.getCurrentReactContext();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostPause(this);
            ReactContext currentReactContext = mReactInstanceManager.getCurrentReactContext();
            if (currentReactContext != null) {
                currentReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("packageWillPause", "");
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostResume(this, this);
            ReactContext currentReactContext = mReactInstanceManager.getCurrentReactContext();
            if (currentReactContext != null) {
                currentReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("packageDidResume", "");
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostDestroy(this);
            mReactInstanceManager.destroy();
            ReactContext currentReactContext = mReactInstanceManager.getCurrentReactContext();
            if (currentReactContext != null) {
                currentReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("packageWillExit", "");
            }
        }

        if (mReactRootView != null) {
            mReactRootView.unmountReactApplication();
        }
        unregisterBleStateReceiver();
//        Process.killProcess(Process.myPid());
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (isFinishing()) {
            /// disconnect bt
            if (device != null) {
                BluetoothLeManager.INSTANCE.disconnectAndCloseAll();
                MyBleConnectStateManager.INSTANCE.disconnectAndCloseAll();
            }
        }
    }

    @Override
    public void onBackPressed() {
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onBackPressed();
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_MENU && mReactInstanceManager != null) {
            mReactInstanceManager.showDevOptionsDialog();
            return true;
        }
        return super.onKeyUp(keyCode, event);
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void requestPermissions(String[] permissions, int requestCode, PermissionListener listener) {
        this.permissionListener = listener;
        requestPermissions(permissions, requestCode);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (this.permissionListener != null) {
            this.permissionListener.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mReactInstanceManager.onActivityResult(this, requestCode, resultCode, data);
    }

    public Bundle getLaunchOptions() {
        Bundle bundle = new Bundle();
        bundle.putString("packageName", getPackageName());
        bundle.putBoolean("isDebug", false);
        bundle.putString("models", "models");
        String versionLasted = "debug";
        bundle.putString("version", versionLasted);
        bundle.putBoolean("isVideo", isVideo);
        if (showWarning) {
            bundle.putBoolean("goWarning", true);
            bundle.putString("warnCode", warningCode);
        }
        if (device.supportLastWill()) {
            bundle.putString("lastWillCode", device.getLastWill());
        }
        WritableMap writableMap = new WritableNativeMap();
        writableMap.putMap("account", (ReadableMap) RNConstants.getAccount().get("account"));
        writableMap.putMap("device",
                (ReadableMap) RNConstants.getLoadDevice(device));
        writableMap.putMap("host", (ReadableMap) RNConstants.getHost().get("host"));
        writableMap.putMap("locale", (ReadableMap) Arguments.makeNativeMap(RNConstants.getLocale()));
        writableMap.putMap("sdkConfig", (ReadableMap) Arguments.makeNativeMap(RNConstants.getSDKConfig()));
        writableMap.putMap("package", (ReadableMap) Arguments.makeNativeMap(getPackage(device)));
        bundle.putString("sdkInfo", GsonUtils.toJson(writableMap.toHashMap()));

        Bundle entrance = new Bundle();
        entrance.putString("type", entranceType);
        if (!TextUtils.isEmpty(source)) {
            entrance.putString("source", source);
        }
        if (!TextUtils.isEmpty(extraData)) {
            entrance.putString("extraData", extraData);
        }
        entrance.putBundle("extra", new Bundle());
        bundle.putBundle("entrance", entrance);
        return bundle;
    }

    public Map<String, Object> getPackage(DeviceListBean.Device device) {
        HashMap<String, Object> constants = new HashMap<>();
        constants.put("packageName", this.getPackageName());
        constants.put("isDebug", false);
        constants.put("models", "models");
        String versionLasted = "debug";
        constants.put("version", versionLasted + "");
        constants.put("isVideo", isVideo);
        if (!TextUtils.isEmpty(DeviceManager.getInstance().getDeviceWarning())) {
            constants.put("entrance", DeviceManager.getInstance().getDeviceWarning());
        }
        return constants;
    }
}
