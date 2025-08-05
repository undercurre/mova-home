package com.dreame.smartlife.ui.activity;

import android.app.Activity;
import android.content.Intent;
import android.dreame.module.base.BaseActivity;
import android.dreame.module.util.GsonUtils;
import android.dreame.module.util.LogUtil;
import android.dreame.module.util.SPUtil;
import android.net.wifi.ScanResult;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dreame.feature.connect.scan.DeviceScanCache;
import com.dreame.feature.connect.scan.DeviceScannerDelegate;
import com.dreame.smartlife.R;
import com.dreame.smartlife.config.step.WifiDeviceScanner;
import com.dreame.smartlife.config.step.callback.IWiFiScanListener;
import com.dreame.feature.connect.constant.ExtraConstants;
import com.dreame.smartlife.ui.adapter.WifiListAdapter;
import android.dreame.module.view.CommonTitleView;
import com.google.gson.reflect.TypeToken;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import butterknife.BindView;

/**
 * @author edy
 */
public class WifiSelectActivity extends BaseActivity {

    @BindView(R.id.titleView)
    CommonTitleView titleView;
    @BindView(R.id.rv_wifi)
    RecyclerView rvWifi;
    @BindView(R.id.srl_wifi)
    SmartRefreshLayout mSmartRefreshLayout;

    private boolean isScanning = false;
    ScanResult selectWifi;
    private WifiListAdapter wifiListAdapter;
    private List<ScanResult> mListData = new ArrayList<>();
    private DeviceScannerDelegate mDeviceScannerDelegate;

    @Override
    protected int getContentViewId() {
        return R.layout.activity_wifi_select;
    }

    @Override
    protected void initViewModel() {

    }

    @Override
    public void onClick(View v) {
    }

    @Override
    public void initView() {

    }

    @Override
    public void initData() {
        mDeviceScannerDelegate = new DeviceScannerDelegate(this);
        mDeviceScannerDelegate.setScanCount(2);
        wifiListAdapter = new WifiListAdapter(R.layout.item_wifi);
        rvWifi.setAdapter(wifiListAdapter);
        rvWifi.setHasFixedSize(true);
        rvWifi.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.HORIZONTAL));
        rvWifi.setLayoutManager(new LinearLayoutManager(this));
        wifiListAdapter.setOnItemClickListener((adapter, view, position) -> {
            selectWifi = (ScanResult) adapter.getItem(position);
            Intent data = new Intent();
            data.putExtra(ExtraConstants.EXTRA_INPUT_WIFI_NAME, selectWifi.SSID);
            String wifiListStr = (String) SPUtil.get(this, ExtraConstants.SP_KEY_WIFI_LIST, "");
            if (!TextUtils.isEmpty(wifiListStr)) {
                HashMap<String, String> map = GsonUtils.fromJson(wifiListStr, new TypeToken<HashMap<String, String>>() {
                }.getType());
                String wifiPwd = map.get(selectWifi.SSID);
                data.putExtra(ExtraConstants.EXTRA_INPUT_WIFI_PWD, wifiPwd);
            }
            setResult(Activity.RESULT_OK, data);
            finish();
        });
        initWifiLististener();
        isScanning = true;

        mDeviceScannerDelegate.filterDevice(false);
        mDeviceScannerDelegate.checkLocPermission(DeviceScanCache.TYPE_WIFI, DeviceScanCache.TYPE_WIFI);
        if (mDeviceScannerDelegate.isPermissionGrand()) {
            List<ScanResult> scanResultFirst = mDeviceScannerDelegate.getScanResultFirst();
            List<ScanResult> scanResult = new ArrayList<>();
            for (ScanResult result : scanResultFirst) {
                if (WifiDeviceScanner.INSTANCE.is24GHz(result.frequency)) {
                    scanResult.add(result);
                }
            }
            mListData.clear();
            mListData.addAll(filterScanResult(scanResult));
            wifiListAdapter.setList(mListData);
        }
    }

    private void initWifiLististener() {
        mDeviceScannerDelegate.setWifiScanCallBack(new IWiFiScanListener() {
            @Override
            public void onComplete() {
                LogUtil.d("onComplete: ");
            }

            @Override
            public void onScanStart() {
                LogUtil.d("onScanStart: ");
                mSmartRefreshLayout.finishRefresh(3000);
            }

            @Override
            public void onScanStop(int ret) {
                LogUtil.d("onScanStop: ");
            }

            @Override
            public void onProgress(int progress) {
                LogUtil.d("onProgress: ");
            }

            @Override
            public void onScanResult(@NonNull List<ScanResult> scanResults) {
                LogUtil.d("onScanResult: ");
                mListData.clear();
                mListData.addAll(filterScanResult(scanResults));
                wifiListAdapter.setList(mListData);
            }
        });
    }

    private List<ScanResult> filterScanResult(List<ScanResult> list) {
        LinkedHashMap<String, ScanResult> linkedMap = new LinkedHashMap<>(list.size());
        for (ScanResult rst : list) {
            if (linkedMap.containsKey(rst.SSID)) {
                if (rst.level > linkedMap.get(rst.SSID).level) {
                    linkedMap.put(rst.SSID, rst);
                }
                continue;
            }
            linkedMap.put(rst.SSID, rst);
        }
        list.clear();
        list.addAll(linkedMap.values());
        return list;
    }

    private void scanWifiList() {
        mDeviceScannerDelegate.startScanDeviceDirect();
    }


    @Override
    protected void onResume() {
        super.onResume();
        mDeviceScannerDelegate.onResume();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void initEvent() {
        titleView.setOnButtonClickListener(new CommonTitleView.SimpleButtonClickListener() {
            @Override
            public void onLeftIconClick() {
                finish();
            }
        });
        mSmartRefreshLayout.setEnableLoadMore(false);
        mSmartRefreshLayout.setOnRefreshListener(refreshLayout -> {
            scanWifiList();
        });
    }

}
