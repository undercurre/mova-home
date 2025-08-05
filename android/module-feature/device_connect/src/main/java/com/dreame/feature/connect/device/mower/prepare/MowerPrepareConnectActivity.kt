package com.dreame.feature.connect.device.mower.prepare

import android.dreame.module.RoutPath
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.dp
import android.dreame.module.view.CommonTitleView
import android.dreame.module.view.SpaceItemDecoration
import android.os.Bundle
import android.view.View
import android.widget.ImageView
import androidx.activity.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.RequestOptions
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.utils.permission.CheckBlePermissionDelegate
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityMowerPrepareConnectBinding
import com.google.android.exoplayer2.C
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.audio.AudioAttributes
import com.google.android.exoplayer2.ui.AspectRatioFrameLayout
import com.therouter.TheRouter
import com.therouter.router.Route
import com.zj.mvi.core.observeState
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

/**
 * 割草机配网准备页
 */
@Route(path = RoutPath.PRODUCT_CONNECT_PREPARE_BLE)
class MowerPrepareConnectActivity : BaseActivity<ActivityMowerPrepareConnectBinding>() {

    private val viewModel by viewModels<MowerPrepareConnectViewModel>()
    private val checkBlePermissionDelegate by lazy { CheckBlePermissionDelegate(this) }

    private val prepareConnectAdapter by lazy { PrepareConnectAdapter() }
    private var player: ExoPlayer? = null

    override fun initData() {
        val productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
        val isShowBtn = intent.getBooleanExtra(ExtraConstants.EXTRA_FEATURE, true)
        viewModel.dispatchAction(MowerPrepareConnectUiAction.InitData(productInfo, isShowBtn))

        val arr3 = if (productInfo?.productModel?.contains("dreame.mower.") == true) {
            resources.getStringArray(R.array.prepare_connect_mower)
        } else {
            resources.getStringArray(R.array.prepare_connect)
        }
        prepareConnectAdapter.setList(arr3.toMutableList())
    }

    override fun initView() {
        binding.recyclerview.layoutManager = LinearLayoutManager(this)
        binding.recyclerview.addItemDecoration(SpaceItemDecoration(16.dp(), RecyclerView.VERTICAL))
        binding.recyclerview.adapter = prepareConnectAdapter
    }

    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.OnButtonClickListener {
            override fun onLeftIconClick() {
                finish()
            }

            override fun onRightIconClick() {

            }

            override fun onRightTextClick() {

            }
        })
        binding.btnStartConnect.setOnClickListener {

            if (viewModel.uiStates.value.bind_domain.isNullOrEmpty()) {
                viewModel.dispatchAction(MowerPrepareConnectUiAction.RequestBindDomain)
            } else {
                gotoNext()
            }
        }
    }

    private fun gotoNext() {
        // 开始配网
        // 如果蓝牙关闭，弹框，打开蓝牙
        val showBleOpenDialog = checkBlePermissionDelegate.showBleOpenDialog()
        if (showBleOpenDialog) {
            // 下一步
            val path = if (viewModel.uiStates.value.productInfo?.enterOrigin == ParameterConstants.ORIGIN_SCAN) {
                RoutPath.DEVICE_CONNECT_BLE
            } else {
                RoutPath.DEVICE_TRIGGER_BLE
            }
            TheRouter.build(path)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                .withInt(ExtraConstants.EXTRA_STEP, StepId.STEP_DEVICE_SCAN_BLE)
                .navigation()
        }
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, MowerPrepareConnectUiState::image, MowerPrepareConnectUiState::video) { image, video ->
            extracted(video, image)
        }
        viewModel.uiStates.observeState(this, MowerPrepareConnectUiState::isShowBtn) {
            binding.btnStartConnect.visibility = if (it) View.VISIBLE else View.GONE
        }

    }

    private fun extracted(video: String?, image: String?) {
        if (!video.isNullOrEmpty()) {
            binding.llVideo.visibility = View.VISIBLE
            player = ExoPlayer.Builder(this).build()
            binding.playerView.player = player
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(C.AUDIO_CONTENT_TYPE_MOVIE)
                .setUsage(C.USAGE_MEDIA)
                .build()
            binding.playerView.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_ZOOM
            player?.setAudioAttributes(audioAttributes, false)
            val mediaItem = MediaItem.fromUri(video)
            player?.setMediaItem(mediaItem)
            player?.prepare()

            if (isDestroyed || isFinishing) return
            val view = ImageView(this)
            if (image.isNullOrEmpty()) {
                Glide.with(this)
                    .setDefaultRequestOptions(
                        RequestOptions()
                            .frame(1000000)
                            .centerCrop()
                    )
                    .load(image)
                    .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                    .into(view)
            } else {
                Glide.with(this)
                    .setDefaultRequestOptions(
                        RequestOptions()
                            .centerCrop()
                    )
                    .load(image)
                    .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                    .into(view)
            }
//            binding.gsyVv.thumbImageView = view
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        checkBlePermissionDelegate.init()
        super.onCreate(savedInstanceState)
        EventBus.getDefault().register(this)
    }

    override fun onResume() {
        super.onResume()
//        if (binding.gsyVv.isInPlayingState()) {
//            binding.gsyVv.onVideoResume()
//        }
    }

    override fun onPause() {
        super.onPause()
//        binding.gsyVv.onVideoPause()
    }

    override fun onDestroy() {
        super.onDestroy()
        player?.release()
        EventBus.getDefault().unregister(this)
    }


    override fun onStop() {
        super.onStop()
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: EventMessage<*>) {
        when (event.code) {

            EventCode.ADD_DEVICE_SUCCESS -> {
                finish()
            }
        }
    }
}