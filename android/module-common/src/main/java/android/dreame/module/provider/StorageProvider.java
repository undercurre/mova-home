package android.dreame.module.provider;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.UriMatcher;
import android.database.Cursor;
import android.dreame.module.LocalApplication;
import android.dreame.module.constant.Constants;
import android.dreame.module.data.db.PluginInfoEntity;
import android.dreame.module.manager.AccountManager;
import android.dreame.module.manager.AreaManager;
import android.dreame.module.manager.LanguageManager;
import android.dreame.module.task.RetrofitInitTask;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.SPUtil;
import android.dreame.module.util.download.rn.RnPluginInfoHelper;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/06/07
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class StorageProvider extends ContentProvider {

    private static final String TAG = "StorageProvider";


    public static final String AUTHORITY = "com.dreame.movahome.storage_provider";
    public static final String SCHEME = "content://";

    public static final String PATH_ACCOUNT = "account";
    public static final int ACCOUNT = 1;

    public static final String PATH_PLUGIN = "plugin";
    public static final int PLUGIN = 2;

    public static final String PATH_LANGUAGE = "language";
    public static final int LANGUAGE = 3;

    public static final String PATH_AREA = "area";
    public static final int AREA = 4;

    public static final String PATH_DEBUG = "debug";
    public static final int DEBUG = 5;


    private static final UriMatcher mMatcher;
    private Context context;

    static {
        mMatcher = new UriMatcher(UriMatcher.NO_MATCH);
        mMatcher.addURI(AUTHORITY, PATH_ACCOUNT, ACCOUNT);
        mMatcher.addURI(AUTHORITY, PATH_PLUGIN, PLUGIN);
        mMatcher.addURI(AUTHORITY, PATH_LANGUAGE, LANGUAGE);
        mMatcher.addURI(AUTHORITY, PATH_AREA, AREA);
        mMatcher.addURI(AUTHORITY, PATH_DEBUG, DEBUG);
    }

    @Override
    public boolean onCreate() {
        this.context = getContext();
        return false;
    }

    @Nullable
    @Override
    public Cursor query(@NonNull Uri uri, @Nullable String[] projection, @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder) {
        Log.i(TAG, "query: " + mMatcher.match(uri) + " currentThreadId: " + Thread.currentThread().getId() + " ,currentThreadName: " + Thread.currentThread().getName());
        Bundle data = new Bundle();
        switch (mMatcher.match(uri)) {
            case ACCOUNT:
                data.putSerializable("auth", AccountManager.getInstance().getAccount(context.getApplicationContext()));
                data.putParcelable("userInfo", AccountManager.getInstance().getUserInfo(context.getApplicationContext()));
                break;
            case PLUGIN:
                String sdkVersionLasted = "0";
                final PluginInfoEntity sdkInfo = RnPluginInfoHelper.getRnSDKPluginUseSync();
                int sdkRealVersion = sdkInfo == null ? 0 : sdkInfo.getPluginVersion();
                data.putString("sdkVersion", sdkRealVersion + "");
                data.putString("sdkPath", sdkInfo == null ? "" : sdkInfo.getPluginPath());
                data.putLong("sdkSize", sdkInfo == null ? 0 : sdkInfo.getPluginLength());
                data.putString("sdkMd5", sdkInfo == null ? "" : sdkInfo.getPluginMd5());

                final PluginInfoEntity pluginInfo = RnPluginInfoHelper.getRnPluginUseSync(selection, 0);
                if (pluginInfo != null) {
                    data.putString("pluginVersion", pluginInfo.getPluginVersion() + "");
                    data.putString("pluginPath", pluginInfo.getPluginPath());
                    data.putLong("pluginSize", pluginInfo.getPluginLength());
                    data.putString("pluginMd5", pluginInfo.getPluginMd5());

                    data.putInt("pluginResVersion", pluginInfo.getPluginResVersion());
                    data.putString("pluginResPath", pluginInfo.getPluginResPath());
                    data.putLong("pluginResSize", pluginInfo.getPluginResLength());
                    data.putString("pluginResMd5", pluginInfo.getPluginResMd5());
                    data.putInt("commonPluginVer", pluginInfo.getCommonPluginVer());

                    LogUtil.i(TAG, "sdkVersionLasted: " + sdkVersionLasted + " ,sdkRealVersion: " + sdkRealVersion);
                } else {
                    data.putString("pluginVersion", "0");
                    data.putString("pluginPath", "");
                    data.putLong("pluginSize", 0);
                    data.putString("pluginMd5", null);

                    data.putInt("pluginResVersion", 0);
                    data.putString("pluginResPath", "");
                    data.putLong("pluginResSize", 0);
                    data.putString("pluginResMd5", "");
                    data.putInt("commonPluginVer", 0);
                }
                break;
            case LANGUAGE:
                data.putString("langTag", LanguageManager.getInstance().getLangTag(getContext()));
                data.putString("countryCode", LanguageManager.getInstance().getCountryCode(getContext()));
                data.putParcelable("languageBean", LanguageManager.getInstance().getLanguage(getContext()));
                break;
            case AREA:
                data.putString("countryCode", AreaManager.getCountryCode());
                data.putString("region", AreaManager.getRegion());
                data.putParcelable("currentCountry", AreaManager.INSTANCE.getCurrentCountry());
                data.putString("baseUrl", RetrofitInitTask.getBaseUrl());
                break;
            case DEBUG:
                data.putBoolean("enableDebug", (boolean) SPUtil.get(LocalApplication.getInstance(), Constants.DEBUGEABLE, false));
                break;
            default:
                break;
        }
        return new BundleCursor(data);
    }

    @Nullable
    @Override
    public String getType(@NonNull Uri uri) {
        return null;
    }

    @Nullable
    @Override
    public Uri insert(@NonNull Uri uri, @Nullable ContentValues values) {
        return null;
    }

    @Override
    public int delete(@NonNull Uri uri, @Nullable String selection, @Nullable String[] selectionArgs) {
        return 0;
    }

    @Override
    public int update(@NonNull Uri uri, @Nullable ContentValues values, @Nullable String selection, @Nullable String[] selectionArgs) {
        return 0;
    }
}
