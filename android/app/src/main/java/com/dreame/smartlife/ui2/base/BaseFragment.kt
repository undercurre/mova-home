package com.dreame.smartlife.ui2.base

import android.dreame.module.R
import android.dreame.module.util.LogUtil
import android.dreame.module.view.dialog.CustomProgressDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.viewbinding.ViewBinding
import org.greenrobot.eventbus.EventBus
import java.lang.reflect.ParameterizedType

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/31
 *     desc   :
 *     version: 1.0
 * </pre>
 */
abstract class BaseFragment<VB : ViewBinding> : Fragment() {
    lateinit var binding: VB
    private var loading: CustomProgressDialog? = null


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val type = javaClass.genericSuperclass as ParameterizedType
        val aClass = type.actualTypeArguments[0] as Class<*>
        val method = aClass.getDeclaredMethod(
            "inflate",
            LayoutInflater::class.java,
            ViewGroup::class.java,
            Boolean::class.java
        )
        binding = method.invoke(null, layoutInflater, container, false) as VB
        initView()
        if (isRegisteredEventBus()) {
            EventBus.getDefault().register(this)
        }
        return binding.root
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
            .replace(containerId, fragment, fragment.javaClass.simpleName).commit()
    }

    protected fun showLoading() {
        if (loading == null || loading?.isShowing == false) {
            loading = CustomProgressDialog(requireActivity())
            loading?.show()
        }
    }

    protected fun dismissLoading() {
        try {
            loading?.dismiss()
        } catch (e: Exception) {
            LogUtil.e("BaseFragment", "dismissLoading error: $e")
        } finally {
            loading = null
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        if (EventBus.getDefault().isRegistered(this)) {
            EventBus.getDefault().unregister(this)
        }
    }

    /**
     * 是否注册事件分发
     *
     * @return true 注册；false 不注册，默认不注册
     */
    protected open fun isRegisteredEventBus(): Boolean {
        return false
    }

    protected abstract fun initView()
}