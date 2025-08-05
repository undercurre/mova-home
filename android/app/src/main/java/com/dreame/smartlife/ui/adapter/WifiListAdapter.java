package com.dreame.smartlife.ui.adapter;

import android.net.wifi.ScanResult;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.viewholder.BaseViewHolder;
import com.dreame.smartlife.R;

import org.jetbrains.annotations.NotNull;

public class WifiListAdapter extends BaseQuickAdapter<ScanResult, BaseViewHolder> {
  public WifiListAdapter(int layoutResId) {
    super(layoutResId);
  }

  @Override
  protected void convert(@NotNull BaseViewHolder baseViewHolder, ScanResult scanResult) {
    baseViewHolder.setText(R.id.tv_wifi_name, scanResult.SSID);
//    baseViewHolder.setText(R.id.tv_wifi_desc, "信号强度：" + WifiManager.calculateSignalLevel(scanResult.level, 5));
  }
}
