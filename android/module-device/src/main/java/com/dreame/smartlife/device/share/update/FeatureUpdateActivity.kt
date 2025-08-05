package com.dreame.smartlife.device.share.update

import android.dreame.module.RoutPath
import android.dreame.module.data.entry.device.ShareUserRes
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.view.CommonTitleView
import android.view.View
import androidx.activity.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.therouter.router.Route
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.device.R
import com.dreame.smartlife.device.databinding.ActivityFeatureUpdateBinding
import com.dreame.smartlife.device.share.CommonSingleImageDialog
import com.dreame.smartlife.device.share.confirm.FeatureShareConfirmUiEvent
import android.dreame.module.util.toast.ToastUtils
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState

@Route(path = RoutPath.SHARE_DEVICE_FEATURE_UPDATE)
class FeatureUpdateActivity : BaseActivity<ActivityFeatureUpdateBinding>() {

    private val viewModel by viewModels<FeatureUpdateViewModel>()
    private var adapter: FeatureUpdateAdapter? = null

    override fun initData() {
        val did = intent?.getStringExtra("did")
        val pid = intent?.getStringExtra("pid")
        val shareUser = intent?.getParcelableExtra<ShareUserRes>("shareUser")
        viewModel.dispatchAction(FeatureUpdateUiAction.InitAction(did, pid, shareUser))
    }

    override fun initView() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.OnButtonClickListener {
            override fun onLeftIconClick() {
                viewModel.dispatchAction(FeatureUpdateUiAction.CheckBackAction)
            }

            override fun onRightIconClick() {
                viewModel.dispatchAction(FeatureUpdateUiAction.FeatureUpdateSubmitAction)
            }

            override fun onRightTextClick() {

            }
        })
        binding.rvFeatureList.layoutManager = LinearLayoutManager(this)
        adapter = FeatureUpdateAdapter({ _, _ ->
            viewModel.dispatchAction(FeatureUpdateUiAction.FeatureStatusUpdateAction)
        },
            { imageUrl, content ->
                showFeatureDescription(imageUrl, content)
            }
        )
        binding.rvFeatureList.adapter = adapter
        viewModel.dispatchAction(FeatureUpdateUiAction.RefreshFeatureAction)
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, FeatureUpdateUiState::shareUser) {
            it?.let {
                binding.tvNickname.text = it.name
                binding.tvUserId.text = "MOVA ID: ${it.uid}"
                ImageLoaderProxy.getInstance().displayImage(
                    this@FeatureUpdateActivity,
                    it.avatar,
                    R.drawable.icon_avatar_default,
                    binding.civAvatar
                )
            }
        }
        viewModel.uiStates.observeState(this, FeatureUpdateUiState::featureList) {
            if (it.isNullOrEmpty()) {
                binding.tvFeature.visibility = View.INVISIBLE
                binding.tvFeatureShareTip.visibility = View.INVISIBLE
            } else {
                binding.tvFeature.visibility = View.VISIBLE
                binding.tvFeatureShareTip.visibility = View.VISIBLE
                adapter?.setList(it)
            }
        }
        viewModel.uiStates.observeState(this, FeatureUpdateUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiStates.observeState(this, FeatureUpdateUiState::enableUpdate) {
            binding.titleView.getRightIconView().isEnabled = it
        }
        viewModel.uiEvents.observeEvent(this) {
            if (it is FeatureUpdateUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            } else if (it is FeatureUpdateUiEvent.UpdateSuccess) {
                finish()
            } else if (it is FeatureUpdateUiEvent.CheckBackEvent){
                if(it.needUpdate){
                    showUpdateDialog()
                }else {
                    finish()
                }
            }
        }
    }

    private fun showUpdateDialog() {
        val confirmDialog = BottomConfirmDialog(this)
        confirmDialog.show(
            getString(R.string.text_permission_update_confirm_msg),
            getString(R.string.save),
            getString(R.string.cancel),
            {
                viewModel.dispatchAction(FeatureUpdateUiAction.FeatureUpdateSubmitAction)
                it.dismiss()
            },
            {
                it.dismiss()
                finish()
            }
        )
    }

    private fun showFeatureDescription(image: String?, content: String?) {
        val confirmDialog = CommonSingleImageDialog(this)
        confirmDialog.show(
            image,
            content,
            getString(R.string.know)
        ) {
            it.dismiss()
        }
    }
}