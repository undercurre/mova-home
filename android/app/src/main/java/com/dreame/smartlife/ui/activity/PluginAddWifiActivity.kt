package com.dreame.smartlife.ui.activity

import android.content.Intent
import android.dreame.module.constant.CommExtraConstant
import android.dreame.module.data.entry.WifiInfo
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.KeyboardUtil
import android.dreame.module.util.SPUtil
import android.text.*
import android.text.method.HideReturnsTransformationMethod
import android.text.method.PasswordTransformationMethod
import android.util.Pair
import android.view.animation.LinearInterpolator
import android.widget.CompoundButton
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.R
import com.dreame.smartlife.databinding.ActivityPluginAddWifiBinding
import com.dreame.smartlife.ui.dialog.AddWifiHelpDialog
import com.dreame.smartlife.ui2.base.BaseActivity
import android.dreame.module.view.input.BytesLengthTextWatcher
import android.dreame.module.view.CommonTitleView
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.smartlife.widget.ConnectWifiListBottomPopup
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import android.dreame.module.util.toast.ToastUtils
import razerdp.basepopup.BasePopupWindow
import java.util.*

class PluginAddWifiActivity : BaseActivity<ActivityPluginAddWifiBinding>() {
    private val REQ_WIFI_SELECT = 0x10
    private var wifiInfoList: List<WifiInfo>? = null
    private var savedWifiList: LinkedHashMap<String, String?> = LinkedHashMap()
    private var connectedWifiListPopup: ConnectWifiListBottomPopup? = null
    private val helpDialog by lazy {
        AddWifiHelpDialog(this)
    }

    override fun initData() {
        val wifiJson = intent.getStringExtra(CommExtraConstant.WIFI_INFO_LIST)
        if (!TextUtils.isEmpty(wifiJson)) {
            wifiInfoList = Gson().fromJson<List<WifiInfo>>(
                wifiJson,
                object : TypeToken<List<WifiInfo>>() {}.type
            )
        }
        val savedWifiJson = SPUtil.get(this, ExtraConstants.SP_KEY_WIFI_LIST, "") as String
        if (!TextUtils.isEmpty(savedWifiJson)) {
            savedWifiList = GsonUtils.fromJson(
                savedWifiJson,
                object : TypeToken<LinkedHashMap<String, String?>>() {}.type
            )
        }
    }

    override fun initView() {
        binding.etWifiPassword.filters = arrayOf(object : InputFilter {
            override fun filter(source: CharSequence?, start: Int, end: Int, dest: Spanned?, dstart: Int, dend: Int): CharSequence? {
                // 如果输入的字符是中文，则返回空字符串
                return if (!source.isNullOrEmpty() && Character.isIdeographic(source[0].code)) {
                    ""
                } else null
            }
        })
        binding.titleView.setOnButtonClickListener(object :
            CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }

            override fun onRightIconClick() {
                helpDialog.showPopupWindow()
            }
        })

        binding.btnNext.setOnShakeProofClickListener {
            val wifiName = binding.etWifiName.text.toString()
            val wifiPwd = binding.etWifiPassword.text.toString()
            if (TextUtils.isEmpty(wifiName)) {
                ToastUtils.show(getString(R.string.wifi_ssid_empty))
                return@setOnShakeProofClickListener
            }
            if (TextUtils.isEmpty(wifiPwd)) {
                showNoPswDialog(wifiName, wifiPwd)
                return@setOnShakeProofClickListener
            }
            saveWifi(wifiName, wifiPwd)
        }
        binding.ivMore.setOnShakeProofClickListener {
            KeyboardUtil.hideSoftInput(this)
            showWifiList()
        }
        binding.cbShowHide.setOnCheckedChangeListener { _: CompoundButton?, isChecked: Boolean ->
            if (isChecked) {
                binding.etWifiPassword.transformationMethod =
                    PasswordTransformationMethod.getInstance()
            } else {
                binding.etWifiPassword.transformationMethod =
                    HideReturnsTransformationMethod.getInstance()
            }
            if (binding.etWifiPassword.text != null) {
                binding.etWifiPassword.setSelection(binding.etWifiPassword.text!!.length)
            }
        }

        binding.etWifiName.addTextChangedListener(BytesLengthTextWatcher(binding.etWifiName, 32, object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

            }

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

            }

            override fun afterTextChanged(s: Editable?) {
                nextEnable(s?.toString() ?: "", binding.etWifiPassword.text.toString())
            }
        }))
        binding.etWifiPassword.addTextChangedListener(BytesLengthTextWatcher(binding.etWifiPassword, 63, object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

            }

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

            }

            override fun afterTextChanged(s: Editable?) {
                nextEnable(binding.etWifiName.text.toString(), s?.toString() ?: "")
            }
        }))

        if (savedWifiList.isNotEmpty()) {
            val wifiInfo = savedWifiList.toList().last()
            binding.etWifiName.setText(wifiInfo.first)
            binding.etWifiPassword.setText(wifiInfo.second)
        }
        nextEnable(binding.etWifiName.text.toString(), binding.etWifiPassword.text.toString())
    }

    override fun observe() {

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == RESULT_OK && requestCode == REQ_WIFI_SELECT) {
            data?.let {
                val wifiName = it.getStringExtra(ExtraConstants.EXTRA_INPUT_WIFI_NAME)
                val wifiPwd = it.getStringExtra(ExtraConstants.EXTRA_INPUT_WIFI_PWD)
                if (!TextUtils.isEmpty(wifiName)) {
                    if (!TextUtils.isEmpty(wifiName) && wifiName == "<unknown ssid>") {
                        binding.etWifiName.setText("")
                    } else {
                        binding.etWifiName.setText(wifiName)
                    }
                    val text = binding.etWifiName.text.toString()
                    if (!TextUtils.isEmpty(text)) {
                        binding.etWifiName.setSelection(text.length)
                    }
                }
                if (!TextUtils.isEmpty(wifiPwd)) {
                    binding.etWifiPassword.setText(wifiPwd)
                } else {
                    binding.etWifiPassword.setText("")
                }
            }
        }
    }

    private fun showWifiList() {
        if (savedWifiList.isEmpty()) {
            val intent = Intent(this, WifiSelectActivity::class.java)
            startActivityForResult(intent, REQ_WIFI_SELECT)
        } else {
            if (connectedWifiListPopup?.isShowing == true) {
                connectedWifiListPopup?.dismiss();
            }
            connectedWifiListPopup = ConnectWifiListBottomPopup(this).apply {
                onWifiItemClickListener = object : ConnectWifiListBottomPopup.OnWifiItemClickListener {
                    override fun onItemClick(data: Pair<String, String>?, position: Int) {
                        dismiss()
                        if (position == -100) {
                            startActivityForResult(
                                Intent(
                                    this@PluginAddWifiActivity,
                                    WifiSelectActivity::class.java
                                ), REQ_WIFI_SELECT
                            )
                        } else {
                            data?.let {
                                binding.etWifiName.setText(it.first)
                                binding.etWifiName.setSelection(it.first.length)
                                binding.etWifiPassword.setText(it.second)
                            }
                        }
                    }
                }

                onDismissListener = object : BasePopupWindow.OnDismissListener() {
                    override fun onDismiss() {
                        binding.ivMore.animate().rotation(360f).setDuration(300)
                            .setInterpolator(LinearInterpolator()).start()
                    }

                }
            }
            binding.ivMore.animate().rotation(180f).setDuration(300)
                .setInterpolator(LinearInterpolator())
                .start()
            connectedWifiListPopup?.showPopupWindow()
        }
    }

    private fun showNoPswDialog(wifiName: String, wifiPwd: String) {
        BottomConfirmDialog(this)
            .show(
                getString(R.string.text_no_need_pwd),
                getString(R.string.yes),
                getString(R.string.input_wifi_password),
                { dialog: BottomConfirmDialog ->
                    dialog.dismiss()
                    saveWifi(wifiName, wifiPwd)
                }
            ) { dialog: BottomConfirmDialog ->
                dialog.dismiss()
            }
    }

    private fun saveWifi(wifiName: String, wifiPwd: String) {
        if (wifiInfoList != null && wifiInfoList!!.isNotEmpty()) {
            val find = wifiInfoList!!.find { it.ssid == wifiName }
            if (find != null) {
                ToastUtils.show(getString(R.string.text_add_wifi_info_repeat))
                return
            }
        }

        if (savedWifiList[wifiName] != null) {
            savedWifiList.remove(wifiName)
        }
        savedWifiList[wifiName] = wifiPwd
        if (savedWifiList.size > 10) {
            val keyList = LinkedList<String?>()
            for (s in savedWifiList.keys) {
                keyList.add(s)
            }
            val first = keyList.first
            savedWifiList.remove(first)
        }
        val wifiListStr = GsonUtils.toJson(savedWifiList)
        SPUtil.put(this, ExtraConstants.SP_KEY_WIFI_LIST, wifiListStr)

        setResult(RESULT_OK, Intent().apply {
            putExtra(CommExtraConstant.WIFI_INFO, Gson().toJson(WifiInfo(wifiName, wifiPwd)))
        })
        finish()
    }

    private fun nextEnable(ssid: String, password: String) {
        if (!TextUtils.isEmpty(ssid)
            && (TextUtils.isEmpty(password) || !TextUtils.isEmpty(password) && password.length >= 8)
        ) {
            binding.btnNext.setEnabled(true)
        } else {
            binding.btnNext.setEnabled(false)
        }
    }
}