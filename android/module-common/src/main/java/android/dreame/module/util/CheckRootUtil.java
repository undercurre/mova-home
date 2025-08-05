package android.dreame.module.util;

import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Scanner;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/11/30
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class CheckRootUtil {

    static final String BINARY_SU = "su";
    static final String BINARY_BUSYBOX = "busybox";

    static final String[] knownRootAppsPackages = {
            "com.noshufou.android.su",
            "com.noshufou.android.su.elite",
            "eu.chainfire.supersu",
            "com.koushikdutta.superuser",
            "com.thirdparty.superuser",
            "com.yellowes.su",
            "com.topjohnwu.magisk",
            "com.kingroot.kinguser",
            "com.kingo.root",
            "com.smedialink.oneclickroot",
            "com.zhiqupk.root.global",
            "com.alephzain.framaroot"
    };

    public static final String[] knownDangerousAppsPackages = {
            "com.koushikdutta.rommanager",
            "com.koushikdutta.rommanager.license",
            "com.dimonvideo.luckypatcher",
            "com.chelpus.lackypatch",
            "com.ramdroid.appquarantine",
            "com.ramdroid.appquarantinepro",
            "com.android.vending.billing.InAppBillingService.COIN",
            "com.android.vending.billing.InAppBillingService.LUCK",
            "com.chelpus.luckypatcher",
            "com.blackmartalpha",
            "org.blackmart.market",
            "com.allinone.free",
            "com.repodroid.app",
            "org.creeplays.hack",
            "com.baseappfull.fwd",
            "com.zmapp",
            "com.dv.marketmod.installer",
            "org.mobilism.android",
            "com.android.wp.net.log",
            "com.android.camera.update",
            "cc.madkite.freedom",
            "com.solohsu.android.edxp.manager",
            "org.meowcat.edxposed.manager",
            "com.xmodgame",
            "com.cih.game_cih",
            "com.charles.lpoqasert",
            "catch_.me_.if_.you_.can_"
    };

    public static final String[] knownRootCloakingPackages = {
            "com.devadvance.rootcloak",
            "com.devadvance.rootcloakplus",
            "de.robv.android.xposed.installer",
            "com.saurik.substrate",
            "com.zachspong.temprootremovejb",
            "com.amphoras.hidemyroot",
            "com.amphoras.hidemyrootadfree",
            "com.formyhm.hiderootPremium",
            "com.formyhm.hideroot"
    };

    // These must end with a /
    private static final String[] suPaths = {
            "/data/local/",
            "/data/local/bin/",
            "/data/local/xbin/",
            "/sbin/",
            "/su/bin/",
            "/system/bin/",
            "/system/bin/.ext/",
            "/system/bin/failsafe/",
            "/system/sd/xbin/",
            "/system/usr/we-need-root/",
            "/system/xbin/",
            "/cache/",
            "/data/",
            "/dev/"
    };


    static final String[] pathsThatShouldNotBeWritable = {
            "/system",
            "/system/bin",
            "/system/sbin",
            "/system/xbin",
            "/vendor/bin",
            "/sbin",
            "/etc",
            //"/sys",
            //"/proc",
            //"/dev"
    };

    /**
     * Get a list of paths to check for binaries
     *
     * @return List of paths to check, using a combination of a static list and those paths
     * listed in the PATH environment variable.
     */
    static String[] getPaths() {
        ArrayList<String> paths = new ArrayList<>(Arrays.asList(suPaths));

        String sysPaths = System.getenv("PATH");

        // If we can't get the path variable just return the static paths
        if (sysPaths == null || "".equals(sysPaths)) {
            return paths.toArray(new String[0]);
        }

        for (String path : sysPaths.split(":")) {

            if (!path.endsWith("/")) {
                path = path + '/';
            }

            if (!paths.contains(path)) {
                paths.add(path);
            }
        }

        return paths.toArray(new String[0]);
    }

    private boolean loggingEnabled = true;


    /**
     * Run all the root detection checks.
     *
     * @return true, we think there's a good *indication* of root | false good *indication* of no root (could still be cloaked)
     */
    public static boolean isRooted(Context context) {
        return checkSuExists() || checkForBinary(BINARY_SU)
                || checkForDangerousProps() || checkForRWPaths() || detectTestKeys()
                || detectRootManagementApps(context) || detectPotentiallyDangerousApps(context) || checkForMagiskBinary();
    }

    /**
     * @deprecated This method is deprecated as checking without the busybox binary is now the
     * default. This is because many manufacturers leave this binary on production devices.
     */
    @Deprecated
    public boolean isRootedWithoutBusyBoxCheck(Context context) {
        return isRooted(context);
    }

    /**
     * Run all the checks including checking for the busybox binary.
     * Warning: Busybox binary is not always an indication of root, many manufacturers leave this
     * binary on production devices
     *
     * @return true, we think there's a good *indication* of root | false good *indication* of no root (could still be cloaked)
     */
    public boolean isRootedWithBusyBoxCheck(Context context) {
        return checkSuExists() || checkForBinary(BINARY_SU) || checkForBinary(BINARY_BUSYBOX)
                || checkForDangerousProps() || checkForRWPaths() || detectTestKeys()
                || detectRootManagementApps(context) || detectPotentiallyDangerousApps(context) || checkForMagiskBinary();
    }

    /**
     * Release-Keys and Test-Keys has to do with how the kernel is signed when it is compiled.
     * Test-Keys means it was signed with a custom key generated by a third-party developer.
     *
     * @return true if signed with Test-keys
     */
    public static boolean detectTestKeys() {
        String buildTags = android.os.Build.TAGS;

        return buildTags != null && buildTags.contains("test-keys");
    }

    /**
     * Using the PackageManager, check for a list of well known root apps. @link {Const.knownRootAppsPackages}
     *
     * @return true if one of the apps it's installed
     */
    public static boolean detectRootManagementApps(Context context) {
        return detectRootManagementApps(context, null);
    }

    /**
     * Using the PackageManager, check for a list of well known root apps. @link {Const.knownRootAppsPackages}
     *
     * @param additionalRootManagementApps - array of additional packagenames to search for
     * @return true if one of the apps it's installed
     */
    public static boolean detectRootManagementApps(Context context, String[] additionalRootManagementApps) {

        // Create a list of package names to iterate over from constants any others provided
        ArrayList<String> packages = new ArrayList<>(Arrays.asList(knownRootAppsPackages));
        if (additionalRootManagementApps != null && additionalRootManagementApps.length > 0) {
            packages.addAll(Arrays.asList(additionalRootManagementApps));
        }

        return isAnyPackageFromListInstalled(context, packages);
    }

    /**
     * Using the PackageManager, check for a list of well known apps that require root. @link {Const.knownRootAppsPackages}
     *
     * @return true if one of the apps it's installed
     */
    public static boolean detectPotentiallyDangerousApps(Context context) {
        return detectPotentiallyDangerousApps(context, null);
    }

    /**
     * Using the PackageManager, check for a list of well known apps that require root. @link {Const.knownRootAppsPackages}
     *
     * @param additionalDangerousApps - array of additional packagenames to search for
     * @return true if one of the apps it's installed
     */
    public static boolean detectPotentiallyDangerousApps(Context context, String[] additionalDangerousApps) {

        // Create a list of package names to iterate over from constants any others provided
        ArrayList<String> packages = new ArrayList<>();
        packages.addAll(Arrays.asList(knownDangerousAppsPackages));
        if (additionalDangerousApps != null && additionalDangerousApps.length > 0) {
            packages.addAll(Arrays.asList(additionalDangerousApps));
        }

        return isAnyPackageFromListInstalled(context, packages);
    }

    /**
     * Checks various (Const.suPaths) common locations for the SU binary
     *
     * @return true if found
     */
    public boolean checkForSuBinary() {
        return checkForBinary(BINARY_SU);
    }

    /**
     * Checks various (Const.suPaths) common locations for the magisk binary (a well know root level program)
     *
     * @return true if found
     */
    public static boolean checkForMagiskBinary() {
        return checkForBinary("magisk");
    }

    /**
     * Checks various (Const.suPaths) common locations for the busybox binary (a well know root level program)
     *
     * @return true if found
     */
    public boolean checkForBusyBoxBinary() {
        return checkForBinary(BINARY_BUSYBOX);
    }

    /**
     * @param filename - check for this existence of this file
     * @return true if found
     */
    public static boolean checkForBinary(String filename) {

        String[] pathsArray = getPaths();

        boolean result = false;

        for (String path : pathsArray) {
            String completePath = path + filename;
            File f = new File(path, filename);
            boolean fileExists = f.exists();
            if (fileExists) {
                LogUtil.v(completePath + " binary detected!");
                result = true;
            }
        }

        return result;
    }

    /**
     * @param logging - set to true for logging
     */
    public void setLogging(boolean logging) {
        loggingEnabled = logging;
    }

    private static String[] propsReader() {
        try {
            InputStream inputstream = Runtime.getRuntime().exec("getprop").getInputStream();
            if (inputstream == null) return null;
            String propVal = new Scanner(inputstream).useDelimiter("\\A").next();
            return propVal.split("\n");
        } catch (IOException | NoSuchElementException e) {
            LogUtil.e(e);
            return null;
        }
    }

    private static String[] mountReader() {
        try {
            InputStream inputstream = Runtime.getRuntime().exec("mount").getInputStream();
            if (inputstream == null) return null;
            String propVal = new Scanner(inputstream).useDelimiter("\\A").next();
            return propVal.split("\n");
        } catch (IOException | NoSuchElementException e) {
            LogUtil.e(e);
            return null;
        }
    }

    /**
     * Check if any package in the list is installed
     *
     * @param packages - list of packages to search for
     * @return true if any of the packages are installed
     */
    private static boolean isAnyPackageFromListInstalled(Context context, List<String> packages) {
        boolean result = false;

        PackageManager pm = context.getPackageManager();

        for (String packageName : packages) {
            try {
                // Root app detected
                pm.getPackageInfo(packageName, 0);
                LogUtil.e(packageName + " ROOT management app detected!");
                result = true;
            } catch (PackageManager.NameNotFoundException e) {
                // Exception thrown, package is not installed into the system
            }
        }

        return result;
    }

    /**
     * Checks for several system properties for
     *
     * @return - true if dangerous props are found
     */
    public static boolean checkForDangerousProps() {

        final Map<String, String> dangerousProps = new HashMap<>();
        dangerousProps.put("ro.debuggable", "1");
        dangerousProps.put("ro.secure", "0");

        boolean result = false;

        String[] lines = propsReader();

        if (lines == null) {
            // Could not read, assume false;
            return false;
        }

        for (String line : lines) {
            for (String key : dangerousProps.keySet()) {
                if (line.contains(key)) {
                    String badValue = dangerousProps.get(key);
                    badValue = "[" + badValue + "]";
                    if (line.contains(badValue)) {
                        LogUtil.v(key + " = " + badValue + " detected!");
                        result = true;
                    }
                }
            }
        }
        return result;
    }

    /**
     * When you're root you can change the permissions on common system directories, this method checks if any of these patha Const.pathsThatShouldNotBeWritable are writable.
     *
     * @return true if one of the dir is writable
     */
    public static boolean checkForRWPaths() {

        boolean result = false;

        //Run the command "mount" to retrieve all mounted directories
        String[] lines = mountReader();

        if (lines == null) {
            // Could not read, assume false;
            return false;
        }

        //The SDK version of the software currently running on this hardware device.
        int sdkVersion = android.os.Build.VERSION.SDK_INT;

        /**
         *
         *  In devices that are running Android 6 and less, the mount command line has an output as follow:
         *
         *   <fs_spec_path> <fs_file> <fs_spec> <fs_mntopts>
         *
         *   where :
         *   - fs_spec_path: describes the path of the device or remote filesystem to be mounted.
         *   - fs_file: describes the mount point for the filesystem.
         *   - fs_spec describes the block device or remote filesystem to be mounted.
         *   - fs_mntopts: describes the mount options associated with the filesystem. (E.g. "rw,nosuid,nodev" )
         *
         */

        /** In devices running Android which is greater than Marshmallow, the mount command output is as follow:
         *
         *      <fs_spec> <ON> <fs_file> <TYPE> <fs_vfs_type> <(fs_mntopts)>
         *
         * where :
         *   - fs_spec describes the block device or remote filesystem to be mounted.
         *   - fs_file: describes the mount point for the filesystem.
         *   - fs_vfs_type: describes the type of the filesystem.
         *   - fs_mntopts: describes the mount options associated with the filesystem. (E.g. "(rw,seclabel,nosuid,nodev,relatime)" )
         */

        for (String line : lines) {

            // Split lines into parts
            String[] args = line.split(" ");

            if ((sdkVersion <= android.os.Build.VERSION_CODES.M && args.length < 4)
                    || (sdkVersion > android.os.Build.VERSION_CODES.M && args.length < 6)) {
                // If we don't have enough options per line, skip this and log an error
                LogUtil.e("Error formatting mount line: " + line);
                continue;
            }

            String mountPoint;
            String mountOptions;

            /**
             * To check if the device is running Android version higher than Marshmallow or not
             */
            if (sdkVersion > android.os.Build.VERSION_CODES.M) {
                mountPoint = args[2];
                mountOptions = args[5];
            } else {
                mountPoint = args[1];
                mountOptions = args[3];
            }

            for (String pathToCheck : pathsThatShouldNotBeWritable) {
                if (mountPoint.equalsIgnoreCase(pathToCheck)) {

                    /**
                     * If the device is running an Android version above Marshmallow,
                     * need to remove parentheses from options parameter;
                     */
                    if (android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.M) {
                        mountOptions = mountOptions.replace("(", "");
                        mountOptions = mountOptions.replace(")", "");

                    }

                    // Split options out and compare against "rw" to avoid false positives
                    for (String option : mountOptions.split(",")) {

                        if (option.equalsIgnoreCase("rw")) {
                            LogUtil.v(pathToCheck + " path is mounted with rw permissions! " + line);
                            result = true;
                            break;
                        }
                    }
                }
            }
        }

        return result;
    }


    /**
     * A variation on the checking for SU, this attempts a 'which su'
     *
     * @return true if su found
     */
    private static boolean checkSuExists() {
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(new String[]{"which", BINARY_SU});
            BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
            return in.readLine() != null;
        } catch (Throwable t) {
            return false;
        } finally {
            if (process != null) process.destroy();
        }
    }
}