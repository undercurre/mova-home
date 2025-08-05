package android.dreame.module.rn.bridge.host;

import android.Manifest;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.dreame.module.LocalApplication;
import android.dreame.module.R;
import android.dreame.module.RoutPath;
import android.dreame.module.RouteServiceProvider;
import android.dreame.module.bean.DeviceListBean;
import android.dreame.module.constant.CommExtraConstant;
import android.dreame.module.constant.Constants;
import android.dreame.module.dto.RenameDTO;
import android.dreame.module.ext.StringExtKt;
import android.dreame.module.rn.load.BasicRNHost;
import android.dreame.module.rn.load.RnLoaderCache;
import android.dreame.module.rn.net.RNNetRequest;
import android.dreame.module.rn.net.RNNetRequestCallBack;
import android.dreame.module.util.DesktopUtil;
import android.dreame.module.util.EscapeUtil;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.privacy.PrivacyPolicyConstants;
import android.dreame.module.util.toast.ToastUtils;
import android.dreame.module.view.dialog.NewInputDialog;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.drawable.Drawable;
import android.mova.module.rn.load.RnShortcutActivity;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDelegate;

import com.alibaba.sdk.android.openaccount.util.JSONUtils;
import com.blankj.utilcode.util.EncodeUtils;
import com.blankj.utilcode.util.GsonUtils;
import com.blankj.utilcode.util.JsonUtils;
import com.blankj.utilcode.util.StringUtils;
import com.blankj.utilcode.util.Utils;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.transition.Transition;
import com.dreame.module.res.BottomConfirmDialog;
import com.dreame.module.res.ThemeUtils;
import com.dreame.module.service.app.flutter.IFlutterBridgeService;
import com.dreame.sdk.share.ShareMedia;
import com.dreame.sdk.share.ShareSdk;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.therouter.TheRouter;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;

public class UIModule extends ReactContextBaseJavaModule implements ActivityEventListener {
    private static final String TAG = UIModule.class.getSimpleName();
    private static final String RENAME = "/dreame-user-iot/iotuserbind/device/rename";
    private static final String DELETE_DEVICE = "/dreame-user-iot/iotuserbind/device/del";
    private static final String GET_DEV_OTC_INFO = "/dreame-user-iot/iotstatus/devOTCInfo";
    public static final String[] PERMISSIONS_SHORTCUT = {Manifest.permission.INSTALL_SHORTCUT, Manifest.permission.UNINSTALL_SHORTCUT};
    private static final int CODE_ADD_WIFI = 0x25;

    private Handler mUiHandler = new Handler(Looper.getMainLooper());

    public UIModule(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(this);
    }

    @NonNull
    @Override
    public String getName() {
        return "UI";
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        ShareSdk.INSTANCE.onActivityResult(activity, requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == CODE_ADD_WIFI) {
                String wifiInfo = data.getStringExtra(CommExtraConstant.WIFI_INFO);
                getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("wifiNeedToAdd", wifiInfo);
            }
        }
    }

    @Override
    public void onNewIntent(Intent intent) {

    }

    @Override
    public void onCatalystInstanceDestroy() {
        if (getCurrentActivity() != null) {
            ShareSdk.INSTANCE.onDestroy(getCurrentActivity());
        }
        super.onCatalystInstanceDestroy();
    }

    @ReactMethod
    public void openChangeDeviceName() {
        mUiHandler.post(new Runnable() {
            @Override
            public void run() {
                if (getCurrentActivity() != null) {
                    DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
                    String defaultContent = "";
                    if (device != null) {
                        if (!TextUtils.isEmpty(device.getCustomName())) {
                            defaultContent = device.getCustomName();
                        } else if (device.getDeviceInfo() != null && !TextUtils.isEmpty(device.getDeviceInfo().getDisplayName())) {
                            defaultContent = device.getDeviceInfo().getDisplayName();
                        } else {
                            device.getModel();
                        }
                    }
                    NewInputDialog inputDialog = new NewInputDialog(getCurrentActivity())
                            .setTitle(getCurrentActivity().getResources().getString(R.string.rename))
                            .setDefaultContent(defaultContent)
                            .setNegative(getCurrentActivity().getString(R.string.cancel))
                            .setPositive(getCurrentActivity().getString(R.string.confirm))
                            .setInputHint(getCurrentActivity().getString(R.string.input_device_name))
                            .setMaxLength(40)
                            .setOnDialogClick(new NewInputDialog.OnDialogCallback() {
                                @Override
                                public void onOKClick(Dialog dialog, String inputText, View v) {
                                    if (TextUtils.isEmpty(inputText)) {
                                        showToast(R.string.rename_device_name_empty);
                                        return;
                                    }
                                    RNNetRequest.request(RENAME, RNNetRequest.TYPE.POST, new RenameDTO(inputText, RnLoaderCache.getCurrentDevice(getReactApplicationContext()).getDid()).getBody(), new RNNetRequestCallBack() {
                                        @Override
                                        public void onSuccess(String response) {
                                            if (!TextUtils.isEmpty(response)) {
                                                try {
                                                    JSONObject jsonObject = new JSONObject(response);
                                                    int code = jsonObject.optInt("code", 0);
                                                    if (code == 0) {
                                                        showToast(R.string.operate_success);
                                                        device.setCustomName(inputText);
                                                        TheRouter.get(IFlutterBridgeService.class)
                                                                .updateDeviceName(device.getDid(), inputText);
                                                        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("deviceNameChanged", inputText);
                                                    } else if (code == 10007) {
                                                        showToast(R.string.rename_device_name_empty);
                                                    } else if (code == 30000) {
                                                        showToast(R.string.input_has_sensitive_words);
                                                    } else {
                                                        showToast(R.string.operate_failed);
                                                    }
                                                } catch (JSONException e) {
                                                    e.printStackTrace();
                                                } finally {
                                                    if (dialog != null) {
                                                        dialog.dismiss();
                                                    }
                                                }
                                            }
                                        }

                                        @Override
                                        public void onError(int code, String error) {
                                            showToast(R.string.operate_failed);
                                            if (dialog != null) {
                                                dialog.dismiss();
                                            }
                                        }
                                    });
                                }

                                @Override
                                public void onCancelClick(Dialog dialog, View v) {
                                    if (dialog != null) {
                                        dialog.dismiss();
                                    }
                                }

                                @Override
                                public void onMaxLengthCallback() {
                                    showToast(R.string.rename_device_name_too_long);
                                }
                            });
                    inputDialog.show();
                }
            }
        });
    }

    @ReactMethod
    public void openAddToDesktopPage() {
        // 判断是否有权限
        // if (isHasPermissions(PERMISSIONS_SHORTCUT)) {
        // } else {
        // show 权限弹框
        // showSettingDialog(getCurrentActivity(), PERMISSIONS_SHORTCUT);
        // }
        mUiHandler.post(this::addShortcut);
    }

    private void showToast(int resId) {
        if (getCurrentActivity() != null) {
            ToastUtils.show(getCurrentActivity().getString(resId));
        }
    }

    /**
     * 添加桌面快捷方式
     */
    private void addShortcut() {
        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (device != null && device.getDeviceInfo() != null) {
            String image = device.getDeviceInfo().getMainImage().getImageUrl();
            Glide.with(getReactApplicationContext()).asBitmap().load(image).into(new CustomTarget<Bitmap>() {
                @Override
                public void onResourceReady(@NonNull Bitmap resource, @Nullable Transition<? super Bitmap> transition) {
                    Log.d("UIModule", "onResourceReady: " + Thread.currentThread().getName());
                    String name = device.getModel();
                    if (TextUtils.isEmpty(device.getCustomName())) {
                        if (!TextUtils.isEmpty(device.getDeviceInfo().getDisplayName())) {
                            name = device.getDeviceInfo().getDisplayName();
                        }
                    } else {
                        name = device.getCustomName();
                    }

                    // 缩放 裁剪 bitmap
                    resource = cropBitmap(resource);
                    try {
                        Intent intent = new Intent();
                        intent.setClass(getCurrentActivity(), RnShortcutActivity.class);
                        intent.setAction(Intent.ACTION_VIEW);
                        intent.setPackage(getCurrentActivity().getPackageName());
                        JSONObject extJson = new JSONObject();
                        extJson.put("did", device.getDid());
                        extJson.put("model", device.getModel());

                        JSONObject extraJson = new JSONObject();
                        extraJson.put("type", "plugin");
                        extJson.put("extra", extraJson);
                        String extJsonEscape = EscapeUtil.escape(EncodeUtils.base64Encode2String(extJson.toString().getBytes()));
                        String uri = "dreame://smartlife/DEVICE?ext=" + extJsonEscape;

                        Log.i(TAG, "onResourceReady: " + uri);
                        intent.putExtra("schemeUri", uri);


                        LogUtil.i("---------添加快捷方式开始-------");
                        DesktopUtil.addShortcut2(getCurrentActivity(), name, device.getDid(), resource, intent);
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        resource.recycle();
                    }
                }

                @Override
                public void onLoadCleared(@Nullable Drawable placeholder) {

                }

                @Override
                public void onLoadFailed(@Nullable Drawable errorDrawable) {
                    Log.d("UIModule", "onLoadFailed: " + Thread.currentThread().getName());
                    super.onLoadFailed(errorDrawable);
                    if (getCurrentActivity() != null) {
                        showToast(R.string.operate_failed);
                    }
                }
            });
        }
    }

    @ReactMethod
    public void openDeleteDevice(String title) {
        mUiHandler.post(() -> {
            final Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                BottomConfirmDialog confirmDialog = new BottomConfirmDialog(currentActivity);
                confirmDialog.show(currentActivity.getString(R.string.delete_device_confirm), currentActivity.getString(R.string.confirm), currentActivity.getString(R.string.cancel), dialog -> {
                    Map<String, String> map = new HashMap<>();
                    String did = RnLoaderCache.getCurrentDevice(getReactApplicationContext()).getDid();
                    map.put("did", did);
                    String json = new Gson().toJson(map);
                    RNNetRequest.request(DELETE_DEVICE, RNNetRequest.TYPE.POST, json, new RNNetRequestCallBack() {
                        @Override
                        public void onSuccess(String response) {
                            dialog.dismiss();
                            ToastUtils.show(currentActivity.getString(R.string.delete_success));
                            TheRouter.get(IFlutterBridgeService.class).deleteDevice(did);
                            currentActivity.finish();
                            BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(did);
                            if (basicRNHost != null) {
                                basicRNHost.setClearCache(true);
                            }
                        }

                        @Override
                        public void onError(int code, String error) {
                            dialog.dismiss();
                            try {
                                ToastUtils.show(currentActivity.getString(R.string.operate_failed));
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });
                    return null;
                }, dialog -> {
                    dialog.dismiss();
                    return null;
                });
            }
        });
    }
    @ReactMethod(isBlockingSynchronousMethod = true)
    public String getAppTheme() {
        return ThemeUtils.getThemeSettingString(getCurrentActivity());
    }

    @ReactMethod
    public void openDeleteDeviceV2(String title, String content,
                                   Promise promise) {
        mUiHandler.post(() -> {
            final Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                BottomConfirmDialog confirmDialog = new BottomConfirmDialog(currentActivity);
                confirmDialog.show(content, currentActivity.getString(R.string.confirm), currentActivity.getString(R.string.cancel), dialog -> {
                    Map<String, String> map = new HashMap<>();
                    String did = RnLoaderCache.getCurrentDevice(getReactApplicationContext()).getDid();
                    map.put("did", did);
                    String json = new Gson().toJson(map);
                    RNNetRequest.request(DELETE_DEVICE, RNNetRequest.TYPE.POST, json, new RNNetRequestCallBack() {
                        @Override
                        public void onSuccess(String response) {
                            dialog.dismiss();
                            ToastUtils.show(currentActivity.getString(R.string.delete_success));
                            TheRouter.get(IFlutterBridgeService.class).deleteDevice(did);
                            BasicRNHost basicRNHost = RnLoaderCache.getReactNativeHost(did);
                            if (basicRNHost != null) {
                                basicRNHost.setClearCache(true);
                            }
                            promise.resolve(true);
                        }

                        @Override
                        public void onError(int code, String error) {
                            dialog.dismiss();
                            promise.reject(code + "", error);
                            try {
                                ToastUtils.show(currentActivity.getString(R.string.operate_failed));
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });
                    return null;
                }, dialog -> {
                    dialog.dismiss();
                    promise.reject("-1", "cancel by user");
                    return null;
                });
            } else {
                promise.reject("-1", "activity is null");
            }
        });
    }

    @ReactMethod
    public void openFeedbackInput() {
        mUiHandler.post(() -> {
            DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
            if (device != null) {
                IFlutterBridgeService flutterBridgeService = TheRouter.get(IFlutterBridgeService.class);
                // Map<String, Object> args = new HashMap<>();
                // args.put("model", device.getModel());
                // args.put("did", device.getDid());
                // if (device.getDeviceInfo() != null && device.getDeviceInfo().getMainImage() != null) {
                //     Map<String, Object> mainImageMap = new HashMap<>();
                //     mainImageMap.put("imageUrl", device.getDeviceInfo().getMainImage().getImageUrl());
                //     mainImageMap.put("height", device.getDeviceInfo().getMainImage().getHeight());
                //     mainImageMap.put("width", device.getDeviceInfo().getMainImage().getWidth());
                //     args.put("mainImage", mainImageMap);
                //     // args.put("imageUrl", device.getDeviceInfo().getMainImage().getImageUrl());
                //     args.put("productId", device.getDeviceInfo().getProductId());
                //     args.put("displayName", device.getDeviceInfo().getDisplayName());
                // }
                Map<String, Object> arguments = new HashMap<>();
                arguments.put("initialExtra", device.getDid());
                Intent intent = flutterBridgeService.openSubFlutter(getReactApplicationContext(), "/product_suggest_page", arguments);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                LocalApplication.getInstance().startActivity(intent);

            }
        });

    }

    @ReactMethod
    public void openHelpPage() {
        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (device != null) {
            IFlutterBridgeService flutterBridgeService = TheRouter.get(IFlutterBridgeService.class);
            Map<String, Object> args = new HashMap<>();
            args.put("model", device.getModel());
            if (device.getDeviceInfo() != null && device.getDeviceInfo().getMainImage() != null) {
                Map<String, Object> mainImageMap = new HashMap<>();
                mainImageMap.put("imageUrl", device.getDeviceInfo().getMainImage().getImageUrl());
                mainImageMap.put("height", device.getDeviceInfo().getMainImage().getHeight());
                mainImageMap.put("width", device.getDeviceInfo().getMainImage().getWidth());
                args.put("mainImage", mainImageMap);
                // args.put("imageUrl", device.getDeviceInfo().getMainImage().getImageUrl());
                args.put("productId", device.getDeviceInfo().getProductId());
                args.put("displayName", device.getDeviceInfo().getDisplayName());
            }
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("initialExtra", args);
            Intent intent = flutterBridgeService.openSubFlutter(getReactApplicationContext(), "/product_manual_page", arguments);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            LocalApplication.getInstance().startActivity(intent);
        }
    }

    @ReactMethod
    public void openFeedbackInputV2() {
        IFlutterBridgeService flutterBridgeService = TheRouter.get(IFlutterBridgeService.class);
        Map<String, Object> args = new HashMap<>();
        Intent intent = flutterBridgeService.openSubFlutter(getReactApplicationContext(), "/help_center", args);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        LocalApplication.getInstance().startActivity(intent);
    }

    @ReactMethod
    public void openAboutPage() {
        // FIXME: 2023/9/8 关于页面已转Flutter
    }

    @ReactMethod
    public void openShareDevicePage() {
        DeviceListBean.Device device = RnLoaderCache.getCurrentDevice(getReactApplicationContext());
        if (device != null) {
            IFlutterBridgeService flutterBridgeService = TheRouter.get(IFlutterBridgeService.class);
            Map<String, Object> args = new HashMap<>();
            args.put("model", device.getModel());
            if (device.getDeviceInfo() != null && device.getDeviceInfo().getMainImage() != null) {
                args.put("did", device.getDid());
                args.put("productId", device.getDeviceInfo().getProductId());
                args.put("permit", device.getDeviceInfo().getPermit());

                String name = device.getModel();
                if (TextUtils.isEmpty(device.getCustomName())) {
                    if (!TextUtils.isEmpty(device.getDeviceInfo().getDisplayName())) {
                        name = device.getDeviceInfo().getDisplayName();
                    }
                } else {
                    name = device.getCustomName();
                }
                args.put("displayName", name);
            }
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("initialExtra", args);
            Intent intent = flutterBridgeService.openSubFlutter(getReactApplicationContext(), "/device_share/add_contacts", arguments);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            LocalApplication.getInstance().startActivity(intent);

        }

    }

    @ReactMethod
    public void openVideoPolicyPage() {
        TheRouter.build(RoutPath.WEBVIEW_POLICY)
                .withInt(Constants.KEY_TYPE, PrivacyPolicyConstants.TYPE_VIDEO_POLICY)
                .navigation();
    }

    @ReactMethod
    public void keepScreenNotLock(boolean light) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            mUiHandler.post(() -> {
                try {
                    if (light) {
                        currentActivity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                    } else {
                        currentActivity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                    }
                } catch (Exception e) {
                    Log.e("UIModule", "keepScreenNotLock: " + e);
                }
            });
        }
    }

    @ReactMethod
    public void openWifiSetting(String args) {
        mUiHandler.post(() -> {
            if (getCurrentActivity() != null) {
                Intent intent = new Intent("com.dreame.smartlife.PluginAddWifiActivity");
                intent.setPackage(getCurrentActivity().getPackageName());
                intent.putExtra(CommExtraConstant.WIFI_INFO_LIST, args);
                getCurrentActivity().startActivityForResult(intent, CODE_ADD_WIFI);
            }
        });
    }

    /**
     * 打开分享列表页面
     *
     * @param {string} title 标题
     * @param {string} description 描述
     * @param {string} imagePath 和Image source 一样的格式
     * @param {string} url 分享链接
     */
    @ReactMethod
    public void openShareListBar(String title, String description, ReadableMap imagePath, String url) {
        Disposable disposable = Observable.just(0)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(integer -> {
                    String shareImagePath = imagePath.getString("uri");
                    if (shareImagePath != null && !TextUtils.isEmpty(shareImagePath)) {
                        if (shareImagePath.startsWith("http")) {
                            ShareSdk.INSTANCE.shareImage(getCurrentActivity(), shareImagePath, title, () -> {
                                // success
                                Log.d(TAG, "openShareListBar: success");
                                return null;
                            }, (shareMedia, cancel, uninstalled, error) -> {
                                // fail
                                if (uninstalled) {
                                    showShareAppUninstall(shareMedia);
                                }
                                Log.d(TAG, "openShareListBar: " + error);
                                return null;
                            });
                        } else {
                            ShareSdk.INSTANCE.shareImage(getCurrentActivity(), new File(shareImagePath), title, () -> {
                                // success
                                Log.d(TAG, "openShareListBar: success");
                                return null;
                            }, (shareMedia, cancel, uninstalled, error) -> {
                                // fail
                                if (uninstalled) {
                                    showShareAppUninstall(shareMedia);
                                }
                                Log.d(TAG, "openShareListBar: " + error);
                                return null;
                            });
                        }
                    }
                }, throwable -> {
                    Log.d(TAG, "openShareListBar: ");
                });
    }

    public void showShareAppUninstall(ShareMedia shareMedia) {
        if (getCurrentActivity() != null) {
            String app = "";
            if (shareMedia == ShareMedia.QQ) {
                app = "QQ";
            } else if (shareMedia == ShareMedia.SINA) {
                app = getCurrentActivity().getString(R.string.share_weibo);
            } else if (shareMedia == ShareMedia.WEIXIN
                    || shareMedia == ShareMedia.WEIXIN_CIRCLE
                    || shareMedia == ShareMedia.WEIXIN_FAVORITE) {
                app = getCurrentActivity().getString(R.string.share_weixin);
            }
            ToastUtils.show(String.format(getCurrentActivity().getString(R.string.text_share_platform_uninstall), app));
        }
    }

    // @ReactMethod
    // public void openShopPage(String gid) {
    //     ProcessEventManager.INSTANCE.openShopPage("/pages/goodsDetail/goodsDetail?gid=" + gid, null);
    // }

    @ReactMethod
    public void openShop(String path, String params) {
        // IMallService mallService = (IMallService) TheRouter.build(RoutPath.MALL_SERVICE).navigation();
        // mallService.openShopPage(path, params, null, false);
        new Handler(Looper.getMainLooper()).post(() -> {
            IFlutterBridgeService flutterBridgeService = TheRouter.get(IFlutterBridgeService.class);
            Map<String, Object> args = new HashMap<>();
            args.put("initialExtra", path);
            Intent intent = flutterBridgeService.openSubFlutter(getReactApplicationContext(), "/mall_page", args);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            LocalApplication.getInstance().startActivity(intent);
        });
    }

    @ReactMethod
    public void openWebPage(String url) {
        IFlutterBridgeService flutterBridgeService = TheRouter.get(IFlutterBridgeService.class);
        Map<String, Object> args = new HashMap<>();
        args.put("initialExtra", url);
        Intent intent = flutterBridgeService.openSubFlutter(getReactApplicationContext(), "/mall_page", args);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        LocalApplication.getInstance().startActivity(intent);

    }

    private Bitmap cropBitmap(Bitmap decodeSampledBitmap) {
        try {
            int height = decodeSampledBitmap.getHeight();
            int width = decodeSampledBitmap.getWidth();
            int max = Math.max(height, width);

            int pading = 100;
            Bitmap bitmap = Bitmap.createBitmap(max + pading, max + pading, decodeSampledBitmap.getConfig());
            bitmap.eraseColor(Color.WHITE);
            Canvas canvas = new Canvas(bitmap);
            float left = pading / 2;
            float top = pading / 2;
            if (width >= height) {
                int nLen = width - height + pading;
                top = (float) (nLen / 2);
            } else {
                int nLen = height - width + pading;
                left = (float) (nLen / 2);
            }
            canvas.drawBitmap(decodeSampledBitmap, left, top, null);

            float scaleW = 200f / bitmap.getWidth();
            float scaleH = 200f / bitmap.getHeight();
            Matrix matrix = new Matrix();
            matrix.postScale(scaleW, scaleH);
            Bitmap scaleBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
            bitmap.recycle();
            return scaleBitmap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return decodeSampledBitmap;
    }

    /**
     * 设置软键盘模式 @see WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE
     *
     * @param mode
     */
    @ReactMethod
    public void setSoftInputMode(int mode) {
        Activity activity = getCurrentActivity();
        if (activity != null) {
            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    activity.getWindow().setSoftInputMode(mode);
                }
            });
        }
    }

    /**
     * 插件重新配网
     *
     */
    @ReactMethod
    public void repairDevice() {
        Activity activity = getCurrentActivity();
        if (activity != null) {
            activity.runOnUiThread(() -> {
                IFlutterBridgeService flutterBridgeService = RouteServiceProvider.getService(IFlutterBridgeService.class);
                if (flutterBridgeService != null) {
                    String routePath = "/qr_scan";
                    Map<String, Object> arguments = new HashMap<>();
                    arguments.put("initialExtra", routePath);
                    Intent intent = flutterBridgeService.openSubFlutter(activity, routePath, arguments);
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    activity.startActivity(intent);
                    activity.finish();
                }
            });
        }
    }


    @ReactMethod
    public void openPage(String params, Promise promise) {
        UIModuleHelper.INSTANCE.openPage(params, promise);
    }
}
