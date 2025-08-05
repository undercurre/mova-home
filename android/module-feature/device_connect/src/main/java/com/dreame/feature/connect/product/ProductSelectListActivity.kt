package com.dreame.feature.connect.product

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.ext.dp
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.LogUtil
import android.dreame.module.view.CommonTitleView
import android.os.Bundle
import android.view.View
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import com.therouter.router.Route
import com.dreame.feature.connect.qr.QRDeviceScanActivity
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityProductSelectListBinding
import com.dreame.smartlife.ui.activity.main.DeviceSannerDelegateImpl
import android.dreame.module.util.toast.ToastUtils
import android.widget.TextView
import com.dreame.smartlife.config.step.StepData
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import com.zj.mvi.core.observeStateList

@Route(path = RoutPath.DEVICE_PRODUCT_SELECT)
class ProductSelectListActivity : BaseActivity<ActivityProductSelectListBinding>() {

    private val viewModel by lazy { ProductSelectListViewModel() }
    private val deviceSannerDelegateImpl by lazy { DeviceSannerDelegateImpl(this) }

    private val nearbyProductAdapter by lazy { ProductScanNearbyAdapter() }
    private val productCategoryAdapter by lazy { ProductCategoryAdapter() }
    private val productListAdapter by lazy { ProductListAdapter() }

    override fun onCreate(savedInstanceState: Bundle?) {
        deviceSannerDelegateImpl.initScanner()
        super.onCreate(savedInstanceState)
    }

    override fun onStart() {
        super.onStart()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            "", "",
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.ProductListPage.code
        )
        BuriedConnectHelper.updateEnterType(1)
    }

    override fun onStop() {
        super.onStop()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            "", "",
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.ProductListPage.code
        )
    }

    override fun onBackPressed() {
        super.onBackPressed()
        handleBack()
    }

    private fun handleBack() {
        val preActivity = ActivityUtil.getInstance().preActivity()
        if (preActivity != null && !(preActivity is QRDeviceScanActivity)) {
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code,
                PairNetEventCode.CostTime.code,
                hashCode(),
                StepData.deviceId, StepData.deviceModel(),
                int1 = 2,
                int2 = 1,
                int5 = BuriedConnectHelper.calculateCostTime(),
                str1 = BuriedConnectHelper.currentSessionID(),
            )
        }
    }

    override fun initData() {
        viewModel.dispatchAction(ProductSelectListUiAction.OnRefresh)
        deviceSannerDelegateImpl.startScanDevice(clear = false)
    }

    override fun initView() {
        binding.llScan.visibility = View.GONE

        binding.rvScanList.adapter = nearbyProductAdapter
        binding.rvScanList.layoutManager =
            LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false)
        binding.rvScanList.addItemDecoration(
            DividerItemDecoration(
                this,
                DividerItemDecoration.HORIZONTAL
            ).apply {
                ContextCompat.getDrawable(
                    this@ProductSelectListActivity,
                    R.drawable.item_divider_8dp
                )?.let {
                    setDrawable(it)
                }
            })
        binding.rvScanList.setHasFixedSize(true)

        binding.rvCategory.adapter = productCategoryAdapter
        binding.rvCategory.layoutManager =
            LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
        binding.rvCategory.setHasFixedSize(true)

        binding.rvProduct.adapter = productListAdapter
        val layoutManager = StaggeredGridLayoutManager(2, LinearLayoutManager.VERTICAL)
        productListAdapter.addFooterView(TextView(this).apply {
            text = " "
            layoutParams = RecyclerView.LayoutParams(
                RecyclerView.LayoutParams.MATCH_PARENT, 100.dp()
            )
        })
        binding.rvProduct.layoutManager = layoutManager
        binding.rvProduct.setHasFixedSize(true)
    }

    override fun initListener() {
//        binding.swipeRefreshLayout.setOnRefreshListener {
//            viewModel.dispatchAction(ProductSelectListUiAction.OnRefresh)
//        }
        binding.titleView.setOnButtonClickListener(object :
            CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                handleBack()
                finish()
            }

            override fun onRightIconClick() {
                startActivity(
                    Intent(
                        this@ProductSelectListActivity,
                        QRDeviceScanActivity::class.java
                    )
                )
            }
        })

        deviceSannerDelegateImpl.block2 = { show, list ->
            viewModel.dispatchAction(ProductSelectListUiAction.NearbyDevice(list))
            binding.llScan.visibility = if (list.isNotEmpty()) View.VISIBLE else View.GONE
            nearbyProductAdapter.setList(list)
        }

        nearbyProductAdapter.setOnItemClickListener { adapter, view, position ->
            val item = nearbyProductAdapter.getItem(position)
            viewModel.dispatchAction(ProductSelectListUiAction.ClickNearby(item))
        }

        productCategoryAdapter.setOnItemClickListener { adapter, view, position ->
            viewModel.dispatchAction(ProductSelectListUiAction.ClickCategory(position))
        }
        productListAdapter.setOnItemClickListener { adapter, view, position ->
            viewModel.dispatchAction(ProductSelectListUiAction.ClickProduct(position))
        }

        binding.rvProduct.setOnScrollChangeListener(conscrollChangeListener)
    }

    private val conscrollChangeListener: (v: View, scrollX: Int, scrollY: Int, oldScrollX: Int, oldScrollY: Int) -> Unit =
        { v, scrollX, scrollY, oldScrollX, oldScrollY ->
            val layoutManager = binding.rvProduct.layoutManager as StaggeredGridLayoutManager
            val findFirstVisibleItemPosition = layoutManager.findFirstVisibleItemPositions(null)
            val findFirstCompletelyVisibleItemPositions =
                layoutManager.findFirstCompletelyVisibleItemPositions(null)

            // LogUtil.d(
            //     "sunzhibin",
            //     "data.size ${productListAdapter.data.size} findFirstVisibleItemPosition = ${findFirstVisibleItemPosition.joinToString()}  findFirstCompletelyVisibleItemPositions = ${findFirstCompletelyVisibleItemPositions.joinToString()}"
            // )

            if (findFirstVisibleItemPosition.isNotEmpty()
                && findFirstVisibleItemPosition[findFirstVisibleItemPosition.size - 1] <= productListAdapter.data.size - 1
            ) {
                //
                // LogUtil.d(
                //     "sunzhibin",
                //     "findFirstVisibleItemPosition:${
                //         productListAdapter.getItem(findFirstVisibleItemPosition[0])
                //     }  ${productListAdapter.getItem(findFirstVisibleItemPosition[findFirstVisibleItemPosition.size - 1])}"
                // )
                // LogUtil.d(
                //     "sunzhibin",
                //     "findFirstCompletelyVisibleItemPositions:${
                //         productListAdapter.getItem(findFirstCompletelyVisibleItemPositions[0])
                //     }  ${productListAdapter.getItem(findFirstCompletelyVisibleItemPositions[findFirstCompletelyVisibleItemPositions.size - 1])}"
                // )

                viewModel.dispatchAction(
                    ProductSelectListUiAction.ScrollProduct(
                        findFirstVisibleItemPosition[findFirstVisibleItemPosition.size - 1]
                    )
                )
            }
        }

    override fun observe() {
        viewModel.uiStates.observeState(this, ProductSelectListUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiStates.observeState(this, ProductSelectListUiState::isRefreshing) {
            if (!it) {
//                if (binding.swipeRefreshLayout.isRefreshing) {
//                    binding.swipeRefreshLayout.isRefreshing = false
//                }
            }
        }

        viewModel.uiStates.observeStateList(this, ProductSelectListUiState::categoryList) { list ->
            productCategoryAdapter.setList(list)
        }

        viewModel.uiStates.observeStateList(this, ProductSelectListUiState::productList) { list ->
            if (list.isNotEmpty()) {
                productListAdapter.removeAllFooterView()
                /// 计算FooterView的高度
                val height = binding.rvProduct.height
                val category = viewModel.uiStates.value.categoryList.last()
                val size = list.filter { it.groupCategoryId == category.groupCategoryId }.size
                val useHeight = (size % 2 + size / 2) * 185.dp() + 50.dp()
                val offset = height - useHeight
                val view = View(this).apply {
                    layoutParams = RecyclerView.LayoutParams(
                        RecyclerView.LayoutParams.MATCH_PARENT, offset
                    )
                }
                productListAdapter.addFooterView(view)
            }
            productListAdapter.setList(list)
        }
        viewModel.uiStates.observeState(this, ProductSelectListUiState::productAllList) { list ->
            deviceSannerDelegateImpl.addAllProductList(list)
        }

        viewModel.uiEvents.observeEvent(this) { event ->
            when (event) {
                is ProductSelectListUiEvent.ShowToast -> {
                    ToastUtils.show(event.message)
                }

                is ProductSelectListUiEvent.CategoryScrollTo -> {
                    smoothMoveToPosition(binding.rvCategory, event.position)
                }

                is ProductSelectListUiEvent.ProductScrollTo -> {
                    binding.rvProduct.setOnScrollChangeListener(null)
                    smoothMoveToPosition(binding.rvProduct, event.position)
                    binding.rvProduct.setOnScrollChangeListener(conscrollChangeListener)
                }

                is ProductSelectListUiEvent.CategoryNotifyPosition -> {
                    productCategoryAdapter.notifyItemChanged(event.lastPosition)
                    productCategoryAdapter.notifyItemChanged(event.position)
                }

            }
        }
    }

    /**
     * 滑动到指定位置
     */
    private fun smoothMoveToPosition(mRecyclerView: RecyclerView, position: Int) {
        // 第一个可见位置
        val firstItem = mRecyclerView.getChildLayoutPosition(mRecyclerView.getChildAt(0))
        // 最后一个可见位置
        val lastItem =
            mRecyclerView.getChildLayoutPosition(mRecyclerView.getChildAt(mRecyclerView.getChildCount() - 1))
        if (position < firstItem) {
            // 第一种可能:跳转位置在第一个可见位置之前
            mRecyclerView.scrollToPosition(position)
        } else if (position <= lastItem) {
            // 第二种可能:跳转位置在第一个可见位置之后
            val movePosition = position - firstItem
            if (movePosition >= 0 && movePosition < mRecyclerView.getChildCount()) {
                val top = mRecyclerView.getChildAt(movePosition).getTop()
                mRecyclerView.scrollBy(0, top)
            }
        } else {
            // 第三种可能:跳转位置在最后可见项之后
            val layoutManager = mRecyclerView.layoutManager
            when (layoutManager) {
                is LinearLayoutManager -> {
                    layoutManager.scrollToPositionWithOffset(position, 0)
                }

                is StaggeredGridLayoutManager -> {
                    layoutManager.scrollToPositionWithOffset(position, 0)
                }

                else -> {
                    mRecyclerView.scrollToPosition(position)
                }
            }
        }
    }


}