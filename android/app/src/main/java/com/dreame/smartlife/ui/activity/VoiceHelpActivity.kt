package com.dreame.smartlife.ui.activity

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.bean.AiSoundBean
import android.dreame.module.data.Result
import android.dreame.module.ext.dp
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper.eventCommonPageInsert
import android.dreame.module.view.CommonTitleView.SimpleButtonClickListener
import android.dreame.module.view.SpaceDecoration
import android.view.View
import android.widget.ImageView
import com.therouter.router.Route
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.smartlife.R
import com.dreame.smartlife.databinding.ActivityVoiceHelpBinding
import com.dreame.smartlife.ui2.base.BaseActivity
import com.dreame.smartlife.ui2.voicecontrol.AlexaAppToAppActivity
import com.dreame.smartlife.ui2.voicecontrol.VoiceControlViewModel
import java.util.Locale

@Route(path = RoutPath.VOICE_CONTROL)
class VoiceHelpActivity : BaseActivity<ActivityVoiceHelpBinding>() {

    private val viewModel by lazy { VoiceControlViewModel() }

    public override fun initData() {
        viewModel.getVoiceProductList(LanguageManager.getInstance().getLangTag(this))
    }

    override fun observe() {
        viewModel.getVoiceProductList.observe(this) { result ->
            if (result is Result.Success) {
                productAdapter.setNewInstance(result.data?.toMutableList())
            }
        }
    }

    public override fun initView() {
        binding.titleView.setOnButtonClickListener(object : SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
        productAdapter.setOnItemClickListener { adapter: BaseQuickAdapter<*, *>?, view: View?, position: Int ->
            val item = productAdapter.getItem(position)
            eventTrack(item)
            if (item.name.lowercase(Locale.getDefault()).contains("alexa")) {
                val intent = Intent(this, AlexaAppToAppActivity::class.java)
                intent.putExtra("key_data", item)
                startActivity(intent)
            } else {
                val intent = Intent(this, VoiceHelpWebActivity::class.java)
                intent.putExtra("key_data", item)
                startActivity(intent)
            }
        }
        binding.rvProduct.addItemDecoration(SpaceDecoration(15.dp()))
        binding.rvProduct.adapter = productAdapter
    }

    private val productAdapter by lazy {
        object : BaseQuickAdapter<AiSoundBean, BaseViewHolder>(R.layout.item_voice_help_product) {
            override fun convert(holder: BaseViewHolder, item: AiSoundBean) {
                holder.setText(R.id.tv_name, item.name)
                val ivDevice = holder.getView<ImageView>(R.id.iv_device)
                ImageLoaderProxy.getInstance().displayImageWithCorners(
                    ivDevice.context,
                    item.imageUrl,
                    R.drawable.shape_palceholder,
                    4.dp(),
                    ivDevice
                )
            }
        }
    }


    private fun eventTrack(item: AiSoundBean) {
        val packageName = item.android.packageName
        var code = 0
        if ("com.baidu.duer.superapp,com.baidu.duer.superapp.oversea".equals(packageName, ignoreCase = true)) {
            code = 1
        } else if ("com.alibaba.ailabs.tg".equals(packageName, ignoreCase = true)) {
            code = 2
        } else if ("com.xiaomi.smarthome".equals(packageName, ignoreCase = true)) {
            code = 3
        } else if ("com.amazon.dee.app".equals(packageName, ignoreCase = true)) {
            code = 5
        } else if ("com.google.android.apps.chromecast.app".equals(packageName, ignoreCase = true)) {
            code = 6
        }
        eventCommonPageInsert(7, 30, this.hashCode(), code)
    }

}
