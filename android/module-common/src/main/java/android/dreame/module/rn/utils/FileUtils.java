package android.dreame.module.rn.utils;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetManager;
import android.dreame.module.util.download.rn.IProgressCallback;
import android.dreame.module.util.download.rn.RnLoadingType;
import android.dreame.module.util.IOUtils;
import android.dreame.module.util.LogUtil;
import android.util.Log;

import org.jetbrains.annotations.NotNull;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.zip.GZIPInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

public class FileUtils {
    public static final String PACKAGE_FILE_NAME = "app.json";
    public static final String PACKAGE_HASH_KEY = "md5";
    public static final String UNZIPPED_FOLDER_NAME = "unzipped";
    public static final String FOLDER_RN = "bundles";//目标目录
    public static final String REACT_NATIVE_FILE = "index.android.bundle";

    public static final String STATUS_FILE = "code_rn.json";

    public static final int DOWNLOAD_BUFFER_SIZE = 1024 * 512;
    private static final int WRITE_BUFFER_SIZE = 1024 * 8;
    private static WeakReference<Activity> rnActivityRef;
    private static final String TAG = FileUtils.class.getSimpleName();

    public static final String BUNDLE_DOWNLOADPATH = "bundle-downloaded";//下载目录
    public static final String RN_NAME = "rnbundle";//临时下载名

    public static String appendPathComponent(String basePath, String appendPathComponent) {
        return new File(basePath, appendPathComponent).getAbsolutePath();
    }

    public static void deleteDirectoryAtPath(String directoryPath) {
        if (directoryPath == null) {
            Log.e(TAG, "deleteDirectoryAtPath attempted with null directoryPath");
            return;
        }
        File file = new File(directoryPath);
        if (file.exists()) {
            deleteFileOrFolderSilently(file);
        }
    }

    public static void deleteFileAtPathSilently(String path) {
        deleteFileOrFolderSilently(new File(path));
    }

    public static void deleteFileOrFolderSilently(File file) {
        deleteFileOrFolderSilently(file, true);
    }


    public static void deleteFileOrFolderSilently(File file, boolean deleteRootFolder) {
        deleteFileOrFolderSilently(file, deleteRootFolder, deleteRootFolder);
    }

    /**
     * 删除文件， 或者删除文件夹下的子文件
     *
     * @param file             目标文件
     * @param deleteRootFolder 控制是否删除根目录， true：默认全删， false： 保留根目录
     * @param deleteFolder     控制是否删除子目录， true：默认全删， false： 保留子目录
     */
    public static void deleteFileOrFolderSilently(File file, boolean deleteRootFolder, boolean deleteFolder) {
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            if (files != null) {
                for (File fileEntry : files) {
                    if (fileEntry.isDirectory()) {
                        deleteFileOrFolderSilently(fileEntry, deleteFolder, deleteFolder);
                    } else {
                        fileEntry.delete();
                    }
                }
            }
        }

        if (deleteRootFolder && !file.delete()) {
            Log.e(TAG, "Error deleting file " + file.getName());
        }
    }

    public static String getRNCodePath(Context context) {
        return appendPathComponent(context.getExternalFilesDir(null).getAbsolutePath(), FOLDER_RN);
    }

    public static String getPackageFolderPath(Context context, String packageHash) {
        return appendPathComponent(getRNCodePath(context), packageHash);
    }

    public static String getCurrentPackageMd5(Context context) {
        String statusFilePath = appendPathComponent(getRNCodePath(context), "code_rn.json");
        String content = null;
        try {
            content = readFileToString(statusFilePath);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (content == null) {
            return content;
        } else {
            content.replace('\n', ' ');
            return content.trim();
        }
    }

    public static boolean fileAtPathExists(String filePath) {
        return new File(filePath).exists();
    }

    public static void moveFile(File fileToMove, String newFolderPath, String newFileName) throws IOException {
        File newFolder = new File(newFolderPath);
        if (!newFolder.exists()) {
            newFolder.mkdirs();
        }

        File newFilePath = new File(newFolderPath, newFileName);
        if (!fileToMove.renameTo(newFilePath)) {
            throw new IOException("Unable to move file from " +
                    fileToMove.getAbsolutePath() + " to " + newFilePath.getAbsolutePath() + ".");
        }
    }

    public static String readFileToString(String filePath) throws IOException {
        FileInputStream fin = null;
        BufferedReader reader = null;
        try {
            File fl = new File(filePath);
            fin = new FileInputStream(fl);
            reader = new BufferedReader(new InputStreamReader(fin));
            StringBuilder sb = new StringBuilder();
            String line = null;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }

            return sb.toString();
        } finally {
            if (reader != null) reader.close();
            if (fin != null) fin.close();
        }
    }

    /**
     * 解压 适合顺序和边下边解压
     *
     * @param fileZip
     * @param destination
     * @throws IOException
     */
    public static void unzipFile(String moduleName, File fileZip, String destination, IProgressCallback callback) throws IOException {
        FileInputStream fileStream = null;
        BufferedInputStream bufferedStream = null;
        ZipInputStream zipStream = null;
        try {
            fileStream = new FileInputStream(fileZip);
            bufferedStream = new BufferedInputStream(fileStream);
            zipStream = new ZipInputStream(bufferedStream);
            ZipEntry entry;

            File destinationFolder = new File(destination);
//            if (destinationFolder.exists()) {
//                deleteFileOrFolderSilently(destinationFolder);
//            }

            destinationFolder.mkdirs();

            byte[] buffer = new byte[WRITE_BUFFER_SIZE];

            int progross = 0;
            while ((entry = zipStream.getNextEntry()) != null) {
                //FIXME 假的进度条，此处未计算进度
                if (callback != null) {
                    if (progross < 90) {
                        progross = progross + 1;
                    }
                    callback.onProgress(moduleName, progross, RnLoadingType.TYPE_DEFAULT);
                }
                File file = new File(destinationFolder, entry.getName());
                String canonicalPath = file.getCanonicalPath();
                if (!canonicalPath.startsWith(destination)) {
                    if (!canonicalPath.startsWith(destination.replace("/user/0", "/data"))) {
                        LogUtil.e(TAG, "unzipFile: " + canonicalPath);
                        LogUtil.e(TAG, "unzipFile: " + destination);
                        throw new SecurityException("file unzip is error");
                    }
                }
                if (entry.isDirectory()) {
                    file.mkdirs();
                } else {
                    File parent = file.getParentFile();
                    if (!parent.exists()) {
                        parent.mkdirs();
                    }

                    FileOutputStream fout = new FileOutputStream(file);
                    try {
                        int numBytesRead;
                        while ((numBytesRead = zipStream.read(buffer)) != -1) {
                            fout.write(buffer, 0, numBytesRead);
                        }
                    } finally {
                        fout.close();
                    }
                }
                long time = entry.getTime();
                if (time > 0) {
                    file.setLastModified(time);
                }
            }
        } finally {
            try {
                if (zipStream != null) zipStream.close();
                if (bufferedStream != null) bufferedStream.close();
                if (fileStream != null) fileStream.close();
            } catch (IOException e) {
                throw new IOException("Error closing IO resources.", e);
            }
        }
    }

    /**
     * 解压 适合从磁盘读文件解压
     *
     * @param fileZip
     * @param destination
     * @throws IOException
     */
    public static void unzipFile2(String moduleName, File fileZip, String destination, IProgressCallback callback) throws IOException {
        ZipFile zipFile = null;
        try {
            zipFile = new ZipFile(fileZip);
            File destinationFolder = new File(destination);
            destinationFolder.mkdirs();
            byte[] buffer = new byte[WRITE_BUFFER_SIZE];
            int progross = 0;
            final Enumeration<? extends ZipEntry> entries = zipFile.entries();
            while (entries.hasMoreElements()) {
                final ZipEntry zipEntry = entries.nextElement();
                //FIXME 假的进度条，此处未计算进度
                if (callback != null) {
                    if (progross < 90) {
                        progross = progross + 5;
                    }
                    callback.onProgress(moduleName, progross, RnLoadingType.TYPE_DEFAULT);
                }
                File file = new File(destinationFolder, zipEntry.getName());
                String canonicalPath = file.getCanonicalPath();
                if (!canonicalPath.startsWith(destination)) {
                    if (!canonicalPath.startsWith(destination.replace("/user/0", "/data"))) {
                        LogUtil.e(TAG, "unzipFile: " + canonicalPath);
                        LogUtil.e(TAG, "unzipFile: " + destination);
                        throw new SecurityException("file unzip is error");
                    }
                }
                if (zipEntry.isDirectory()) {
                    file.mkdirs();
                } else {
                    File parent = file.getParentFile();
                    if (!parent.exists()) {
                        parent.mkdirs();
                    }

                    FileOutputStream fout = new FileOutputStream(file);
                    InputStream zipStream = zipFile.getInputStream(zipEntry);
                    try {
                        int numBytesRead;
                        while ((numBytesRead = zipStream.read(buffer)) != -1) {
                            fout.write(buffer, 0, numBytesRead);
                        }
                    } finally {
                        IOUtils.closeIOQuietly(zipStream);
                        IOUtils.closeIOQuietly(fout);
                    }
                }
                long time = zipEntry.getTime();
                if (time > 0) {
                    file.setLastModified(time);
                }
            }
        } finally {
            IOUtils.closeIOQuietly(zipFile);
        }
    }

    public static void writeStringToFile(String content, String filePath) throws IOException {
        PrintWriter out = null;
        try {
            out = new PrintWriter(filePath);
            out.print(content);
        } finally {
            if (out != null) out.close();
        }
    }

    /**
     * @param context
     * @param assetFilePath
     * @param destPath
     */
    public static boolean copyAssetFile(Context context, String assetFilePath, String destPath, boolean overWrite) {
        AssetManager assetManager = context.getAssets();
        File fileDir = context.getFilesDir();
        String absoluteDestPath = fileDir.getAbsolutePath() + File.separator + destPath;
        try {
            ArrayList<String> files = getAssetsFilePath(context, assetFilePath, null);
            for (int i = 0; i < files.size(); i++) {
                Log.i(TAG, files.get(i));
                String path = files.get(i);
                File desFile = new File(absoluteDestPath + File.separator + path);
                if (desFile == null) return false;
                if (!overWrite) {
                    if (desFile.exists()) {
                        continue;
                    }
                }
                try {
                    InputStream is = assetManager.open(path);
                    boolean result = writeFileFromIS(desFile, is);
                    if (!result) return false;
                } catch (FileNotFoundException e) {
                    return false;
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }


    private static ArrayList<String> getAssetsFilePath(Context context, String oriPath, ArrayList<String> paths) throws IOException {

        if (paths == null) paths = new ArrayList<>();

        String[] list = context.getAssets().list(oriPath);
        for (String l : list) {
            int length = context.getAssets().list(l).length;
            String desPath = oriPath.equals("") ? l : oriPath + "/" + l;
            if (length == 0) {
                paths.add(desPath);
            } else {
                getAssetsFilePath(context, desPath, paths);
            }
        }
        return paths;

    }


    private static boolean writeFileFromIS(File file, InputStream is) {
        if (file == null || is == null) return false;
        if (!createOrExistsFile(file)) return false;

        OutputStream os = null;
        try {
            os = new BufferedOutputStream(new FileOutputStream(file));
            byte data[] = new byte[1024];
            int len;
            while ((len = is.read(data, 0, 1024)) != -1) {
                os.write(data, 0, len);
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeIO(is, os);
        }
    }


    private static boolean createOrExistsFile(File file) {
        if (file == null) return false;
        if (file.exists()) return file.isFile();
        if (!createOrExistsDir(file.getParentFile())) return false;
        try {
            return file.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }


    private static boolean createOrExistsDir(File file) {
        return file != null && (file.exists() ? file.isDirectory() : file.mkdirs());
    }


    private static void closeIO(Closeable... closeables) {
        if (closeables == null) return;
        for (Closeable closeable : closeables) {
            if (closeable != null) {
                try {
                    closeable.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static boolean makeDirectory(@NotNull String savePath) {
        File file = new File(savePath);
        if (file.exists()) {
            return true;
        }
        return file.mkdirs();
    }

    public static void unGzipFile(String sourcedir) {
        String ouputfile = "";
        try {
            //建立gzip压缩文件输入流
            FileInputStream fin = new FileInputStream(sourcedir);
            //建立gzip解压工作流
            GZIPInputStream gzin = new GZIPInputStream(fin);
            //建立解压文件输出流
            ouputfile = sourcedir.substring(0, sourcedir.lastIndexOf('.'));
            ouputfile = ouputfile.substring(0, ouputfile.lastIndexOf('.'));
            FileOutputStream fout = new FileOutputStream(ouputfile);

            int num;
            byte[] buf = new byte[1024];

            while ((num = gzin.read(buf, 0, buf.length)) != -1) {
                fout.write(buf, 0, num);
            }

            gzin.close();
            fout.close();
            fin.close();
        } catch (Exception ex) {
            System.err.println(ex.toString());
        }
    }
}
