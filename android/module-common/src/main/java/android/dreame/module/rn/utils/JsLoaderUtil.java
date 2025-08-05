/*
 * Copyright 2019 yxyhail
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.dreame.module.rn.utils;

import android.app.Application;
import android.dreame.module.util.LogUtil;
import android.os.SystemClock;
import android.text.TextUtils;
import android.util.Log;
import android.util.SparseArray;

import androidx.annotation.Nullable;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.bridge.CatalystInstance;
import com.facebook.react.bridge.ReactContext;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class JsLoaderUtil {
    private static final String TAG = "JsLoaderUtil";
    public static final JsState jsState = new JsState();

    private static long time = SystemClock.elapsedRealtime();

    public static void load(Application application) {
        load(application, null);
    }

    public static void load(Application application, ReactContextCallBack callBack) {
        if (jsState.isDev) {
            if (callBack != null) callBack.onInitialized();
            return;
        }
        long startTime = SystemClock.elapsedRealtime();
        LogUtil.d(TAG, "load: ---start---");
        createReactContext(application, () -> {
            time = SystemClock.elapsedRealtime();
            loadBundle(application);
            LogUtil.d(TAG, "createReactContext: loadBundle： " + (SystemClock.elapsedRealtime() - time));
            time = SystemClock.elapsedRealtime();
            if (callBack != null) callBack.onInitialized();
            LogUtil.d(TAG, "load: ---onInitialized--- " + (SystemClock.elapsedRealtime() - time));
            LogUtil.d(TAG, "load: ---end--- " + (SystemClock.elapsedRealtime() - startTime));
            LogUtil.d(TAG, "---------------------------------------------------------------end--- ---------------------------------------------------------------");
        });
    }

    public interface ReactContextCallBack {
        void onInitialized();
    }

    public static void createReactContext(Application application, ReactContextCallBack callBack) {
        if (jsState.isDev) {
            if (callBack != null) callBack.onInitialized();
            return;
        }
        time = SystemClock.elapsedRealtime();
        final ReactInstanceManager manager = getReactIM(application);
        LogUtil.d(TAG, "createReactContext: getReactIM： " + (SystemClock.elapsedRealtime() - time) + "-----" +manager.hasStartedCreatingInitialContext());
        time = SystemClock.elapsedRealtime();
        if (!manager.hasStartedCreatingInitialContext()) {
            manager.addReactInstanceEventListener(new ReactInstanceManager.ReactInstanceEventListener() {
                @Override
                public void onReactContextInitialized(ReactContext context) {
                    LogUtil.d(TAG, "createReactContext: createReactContextInBackground： " + (SystemClock.elapsedRealtime() - time));
                    if (callBack != null) callBack.onInitialized();
                    manager.removeReactInstanceEventListener(this);
                }
            });
            manager.createReactContextInBackground();
        } else {
            if (callBack != null) callBack.onInitialized();
        }
    }

    public static ReactInstanceManager getReactIM(Application application) {
        return ((ReactApplication) application).getReactNativeHost().getReactInstanceManager();
    }

    public static ReactNativeHost getNativeHost(Application application) {
        return ((ReactApplication) application).getReactNativeHost();
    }

    @Nullable
    public static CatalystInstance getCatalyst(Application application) {
        ReactInstanceManager manager = getReactIM(application);
        if (manager == null) {
            return null;
        }
        ReactContext context = manager.getCurrentReactContext();
        if (context == null) {
            return null;
        }
        return context.getCatalystInstance();
    }

    public static void loadBundle(Application application) {
        if (jsState.neededBundle.size() > 0) {
            for (int i = 0; i < jsState.neededBundle.size(); i++) {
                String name = jsState.neededBundle.get(i) + jsState.bundleSuffix;
                File file = new File(jsState.filePath + name);
                if (file.exists() && jsState.isFilePrior) {
                    fromFile(application, name, file.getAbsolutePath());
                } else {
                    fromAssets(application, name);
                }
            }
        } else {
            String name = jsState.bundleName + jsState.bundleSuffix;
            File file = new File(jsState.filePath + File.separator + name);
            if (file.exists() && jsState.isFilePrior) {
                fromFile(application, name, file.getAbsolutePath());
            } else {
                fromAssets(application, name);
            }
        }

    }


    public static void fromAssets(Application application, String bundleName) {
        fromAssets(application, bundleName, jsState.isSync);
    }

    public static void fromAssets(Application application, String bundleName, boolean isSync) {
        if (hasBundle(bundleName) || JsLoaderUtil.jsState.isDev) {
            return;
        }
        String source = bundleName;
        if (!bundleName.startsWith("assets://")) {
            source = "assets://" + bundleName;
        }
        if (!source.endsWith(jsState.bundleSuffix)) {
            source = source + jsState.bundleSuffix;
        }
        CatalystInstance catalyst = getCatalyst(application);
        try {
            if (catalyst != null) {
                catalyst.loadScriptFromAssets(application.getAssets(), source, isSync);
                addBundle(bundleName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void fromFile(Application application, String bundleName, String sourceUrl) {
        fromFile(application, bundleName, sourceUrl, jsState.isSync);
    }

    public static void fromFile(Application application, String bundleName, String sourceUrl, boolean isSync) {
        if (hasBundle(sourceUrl) || JsLoaderUtil.jsState.isDev) {
            return;
        }
        if (TextUtils.isEmpty(jsState.filePath)) {
            setDefaultFileDir(application);
        }
        String bundleDir = jsState.filePath;

        CatalystInstance catalyst = getCatalyst(application);
        try {
            if (catalyst != null) {
                catalyst.loadScriptFromFile(bundleDir + File.separator + bundleName, sourceUrl, isSync);
                addBundle(sourceUrl);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static String getBasicBundle(Application application, String bundleName) {
        if (jsState.isFilePrior) {
            String path = jsState.reactDir + File.separator + bundleName;
            if (new File(path).exists()) {
                return path;
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    private static String getReactDir(Application application) {
        return application.getFilesDir() + File.separator + jsState.reactDir + File.separator;
    }

    public static void setDefaultFileDir(Application application) {
        File scriptFile = new File(getReactDir(application));
        jsState.filePath = scriptFile.getAbsolutePath();
    }

    public static void addBundles(Application application, List<String> bundlesName, ReactContextCallBack callBack) {
        jsState.neededBundle.addAll(bundlesName);
        load(application, callBack);
    }


    private static void addBundle(String bundle) {
        int index = jsState.loadedBundle.size();
        jsState.loadedBundle.put(index, bundle);
    }

    private static boolean hasBundle(String bundle) {
        return jsState.loadedBundle.indexOfValue(bundle) != -1;
    }

    public static void clearBundle() {
        jsState.loadedBundle.clear();
    }

    public static void setJsBundle(String bundleName, String componentName) {
        jsState.bundleName = bundleName;
        jsState.componentName = componentName;
    }

    public static class JsState {
        public boolean isDev = false;
        boolean isSync = false;
        public boolean isFilePrior = true;
        public String filePath = "";
        public String reactDir = "bundle";
        public String bundleSuffix = ".android.bundle";
        public String bundleName = "";
        public String componentName = "";
        public int index = 1;

        public boolean isLoadBundle = false;
        private SparseArray<String> loadedBundle = new SparseArray<>();
        public List<String> neededBundle = new ArrayList<>();
    }

}
