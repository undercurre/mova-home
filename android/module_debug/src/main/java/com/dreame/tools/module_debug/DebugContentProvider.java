package com.dreame.tools.module_debug;

import android.app.Application;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bytedance.rheatrace.core.TraceApplicationLike;
import com.didichuxing.doraemonkit.DoKit;

/**
 * only do something
 */
public class DebugContentProvider extends ContentProvider {
    @Override
    public boolean onCreate() {
        Log.d("sunzhibin", "onCreate: DebugContentProvider ");
        TraceApplicationLike.attachBaseContext(getContext());

        Application application = (Application) getContext().getApplicationContext();
        ApplicationDelegate.initDokit(application);
        HackHelper.hookTest();
        return true;
    }

    @Nullable
    @Override
    public Cursor query(@NonNull Uri uri, @Nullable String[] projection, @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder) {
        return null;
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
