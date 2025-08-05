package android.dreame.module.util;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.dreame.module.R;
import android.dreame.module.util.toast.ToastUtils;
import android.graphics.Bitmap;
import android.os.Build;
import android.util.Log;

import androidx.core.content.pm.ShortcutInfoCompat;
import androidx.core.content.pm.ShortcutManagerCompat;
import androidx.core.graphics.drawable.IconCompat;

import java.util.Collections;
import java.util.List;

public class DesktopUtil {

    public static final int RC_CREATE_SHORTCUT = 0x200;

    /**
     * 添加桌面图标快捷方式
     *
     * @param activity     Activity对象
     * @param name         快捷方式名称
     * @param icon         快捷方式图标
     * @param actionIntent 快捷方式图标点击动作
     */
    public static void addShortcut2(Activity activity, String name, String shortCutId, Bitmap icon, Intent actionIntent) {
        //启动器是否支持添加快捷方式
        if (!ShortcutManagerCompat.isRequestPinShortcutSupported(activity)) {
            LogUtil.e("DesktopUtil", "addShortcut2: isRequestPinShortcutSupported false");
            ToastUtils.show(activity.getString(R.string.try_add_desktop_icon_tip));
            return;
        }
        String id = "id:" + shortCutId;
        ShortcutInfoCompat info = new ShortcutInfoCompat.Builder(activity, id)
                //设置图标icon
                .setLongLabel(name)
                .setIcon(IconCompat.createWithBitmap(icon))
                //设置名称
                .setShortLabel(name)
                .setIntent(actionIntent)
                .build();

        if (hasShortcut(activity, id)) {
            LogUtil.i("updateShortcuts start");
            boolean updateShortcuts = ShortcutManagerCompat.updateShortcuts(activity, Collections.singletonList(info));
            LogUtil.i("updateShortcuts end " + updateShortcuts);
            if (updateShortcuts) {
                ToastUtils.show(activity.getString(R.string.operate_success));
            }
        } else {
            LogUtil.i("requestPinShortcut start");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                // 注册固定快捷方式成功广播
                try {
                    // IntentFilter intentFilter = new IntentFilter();
                    // intentFilter.addAction("com.example.shortcutstest.PINNED_BROADCAST");
                    // PinnedReceiver receiver = new PinnedReceiver();
                    // activity.registerReceiver(receiver, intentFilter);

                    Intent pinnedShortcutCallbackIntent = new Intent("com.example.shortcutstest.PINNED_BROADCAST");
                    PendingIntent successCallback = PendingIntent.getBroadcast(activity, /* request code */ 0,
                            pinnedShortcutCallbackIntent, /* flags */ Build.VERSION.SDK_INT >= 31 ? PendingIntent.FLAG_IMMUTABLE : 0);
                    ShortcutManagerCompat.requestPinShortcut(activity, info, successCallback.getIntentSender());
//                    extracted(activity, id, receiver);
                } catch (Exception e) {
                    e.printStackTrace();

                }
            } else {
                final int width = icon.getWidth();
                final int height = icon.getHeight();
                Log.d("sunzhibin", "addShortcut2: width: " + width + " ,height: " + height);
                Intent intent2 = new Intent("com.android.launcher.action.INSTALL_SHORTCUT");
                intent2.putExtra("duplicate", false);
                intent2.putExtra(Intent.EXTRA_SHORTCUT_NAME, name);
                intent2.putExtra(Intent.EXTRA_SHORTCUT_ICON, icon);
                intent2.putExtra(Intent.EXTRA_SHORTCUT_INTENT, actionIntent);
                activity.sendBroadcast(intent2);
                ToastUtils.show(activity.getString(R.string.operate_success));
            }

        }
    }

    // private static void extracted(Activity activity, String id, PinnedReceiver receiver) {
    //     activity.getWindow().getDecorView().postDelayed(() -> {
    //         if (hasShortcut(activity, id)) return;
    //         LogUtil.e("hasShortcut postDelayed delay");
    //         try {
    //             ToastUtils.show(activity.getString(R.string.try_add_desktop_icon_tip));
    //             if (receiver != null) {
    //                 activity.unregisterReceiver(receiver);
    //             }
    //         } catch (Exception e) {
    //         }
    //     }, 300);
    // }

    /**
     * 是否已注册
     *
     * @param context
     * @param id
     * @return
     */
    private static boolean hasShortcut(Context context, String id) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N_MR1) {
            int maxShortcutCountPerActivity = ShortcutManagerCompat.getMaxShortcutCountPerActivity(context);
            LogUtil.i("快捷方式最大添加数量： " + maxShortcutCountPerActivity);
            List<ShortcutInfoCompat> shortcuts = ShortcutManagerCompat.getShortcuts(context, ShortcutManagerCompat.FLAG_MATCH_PINNED);
            for (ShortcutInfoCompat shortcutInfo : shortcuts) {
                if (shortcutInfo.getId().equals(id)) {
                    //
                    LogUtil.i("快捷方式已添加 " + shortcutInfo.getId());
                    return true;
                }
            }
        }
        return false;
    }

    // public static class PinnedReceiver extends BroadcastReceiver {
    //     @Override
    //     public void onReceive(Context context, Intent intent) {
    //         LogUtil.i("---------添加快捷方式 end-------");
    //         ToastUtils.show(context.getString(R.string.operate_success));
    //         try {
    //             context.unregisterReceiver(this);
    //         } catch (Exception e) {
    //             Log.e("DesktopUtil", "unregisterReceiver PinnedReceiver fail " + Log.getStackTraceString(e));
    //         }
    //     }
    // }

}
