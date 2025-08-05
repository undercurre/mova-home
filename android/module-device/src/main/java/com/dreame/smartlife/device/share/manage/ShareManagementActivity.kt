package com.dreame.smartlife.device.share.manage

import android.dreame.module.RoutPath
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.view.CommonTitleView
import android.graphics.Color
import android.graphics.Typeface
import android.view.View
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.therouter.router.Route
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.device.R
import com.dreame.smartlife.device.databinding.ActivityShareManagementBinding

@Route(path = RoutPath.SHARE_DEVICE_MANAGEMENT)
class ShareManagementActivity : BaseActivity<ActivityShareManagementBinding>() {

    val fragmentList = listOf(
        ShareDeviceListFragment.newInstance(ShareDeviceListFragment.DEVICE_TYPE_SELF),
        ShareDeviceListFragment.newInstance(ShareDeviceListFragment.DEVICE_TYPE_FROM_OTHER),
    )

    override fun initData() {

    }

    override fun initView() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.OnButtonClickListener {
            override fun onLeftIconClick() {
                finish()
            }

            override fun onRightIconClick() {

            }

            override fun onRightTextClick() {

            }
        })
        binding.layoutTab.llTab1.setOnShakeProofClickListener {
            onTabSelected(0)
        }
        binding.layoutTab.llTab2.setOnShakeProofClickListener {
            onTabSelected(1)
        }
        binding.vpDevice.isUserInputEnabled = false
        val adapter = object : FragmentStateAdapter(this) {
            override fun getItemCount(): Int {
                return fragmentList.size
            }

            override fun createFragment(position: Int): Fragment {
                return fragmentList[position]
            }
        }
        binding.vpDevice.adapter = adapter
        onTabSelected(0)
    }

    override fun observe() {

    }

    private fun onTabSelected(position: Int) {
        if (position == 0) {
            binding.layoutTab.tvTab1Title.setTextColor(getColor(R.color.common_textMain))
            binding.layoutTab.tvTab1Title.setTypeface(null, Typeface.BOLD)
            binding.layoutTab.tab1Underline.visibility = View.VISIBLE

            binding.layoutTab.tvTab2Title.setTextColor(getColor(R.color.common_textNormal))
            binding.layoutTab.tvTab2Title.setTypeface(null, Typeface.NORMAL)
            binding.layoutTab.tab2Underline.visibility = View.INVISIBLE
        } else if (position == 1) {
            binding.layoutTab.tvTab2Title.setTextColor(getColor(R.color.common_textMain))
            binding.layoutTab.tvTab2Title.setTypeface(null, Typeface.BOLD)
            binding.layoutTab.tab2Underline.visibility = View.VISIBLE

            binding.layoutTab.tvTab1Title.setTextColor(getColor(R.color.common_textNormal))
            binding.layoutTab.tvTab1Title.setTypeface(null, Typeface.NORMAL)
            binding.layoutTab.tab1Underline.visibility = View.INVISIBLE
        }
        binding.vpDevice.setCurrentItem(position, false)
    }
}