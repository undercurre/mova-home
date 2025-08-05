package com.dreame.module.base.mvvm.fragment

import android.content.Context
import android.dreame.module.R
import android.dreame.module.view.dialog.CustomProgressDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.viewbinding.ViewBinding
import com.dreame.module.base.ext.inflateBindingWithGeneric
import com.dreame.module.base.mvvm.IView
import org.greenrobot.eventbus.EventBus

abstract class BaseVbFragment<VB : ViewBinding> : Fragment(), IView {

    private var _binding: VB? = null
    val binding get() = _binding!!

    var mActivity: AppCompatActivity? = null
    private val loading by lazy { CustomProgressDialog(mActivity!!) }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        _binding = inflateBindingWithGeneric(inflater, container, false)
        if (isRegisteredEventBus()) {
            EventBus.getDefault().register(this)
        }
        return binding.root
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mActivity = context as AppCompatActivity
    }

    override fun onDetach() {
        super.onDetach()
        mActivity = null
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        if (useViewModel()) createViewModel()
        initView()
        initData(savedInstanceState)
    }

    override fun showLoading(message: String) {
        loading.setMessage(message)
        loading.show()
    }

    override fun dismissLoading() {
        loading.dismiss()
    }

    protected open fun replaceWithLeftRightAnimator(containerId: Int, fragment: Fragment) {
        startFragment(containerId, fragment)
    }

    private fun startFragment(containerId: Int, fragment: Fragment) {
        parentFragmentManager.beginTransaction()
            .setCustomAnimations(
                R.animator.fragment_slide_right_enter,
                R.animator.fragment_slide_left_exit,
                R.animator.fragment_slide_left_enter,
                R.animator.fragment_slide_right_exit
            )
            .addToBackStack(fragment.javaClass.simpleName)
            .replace(containerId, fragment, fragment.javaClass.simpleName)
            .commit()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        if (isRegisteredEventBus() && EventBus.getDefault().isRegistered(this)) {
            EventBus.getDefault().unregister(this)
        }
        _binding = null
    }

    /**
     * 供子类BaseVmVbActivity 初始化ViewModel操作
     */
    open fun createViewModel() {}

    /**
     * 是否注册事件分发
     *
     * @return true 注册；false 不注册，默认不注册
     */
    protected open fun isRegisteredEventBus(): Boolean {
        return false
    }
}