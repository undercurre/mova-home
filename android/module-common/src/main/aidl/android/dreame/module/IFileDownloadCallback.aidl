// IFileDownloadCallback.aidl
package android.dreame.module;

// Declare any non-default types here with import statements

interface IFileDownloadCallback {
    void downloadSuccess(String filePath);

    void downloadFail(String error);
}