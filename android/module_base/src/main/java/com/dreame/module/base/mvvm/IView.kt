package com.dreame.module.base.mvvm

import android.os.Bundle
import androidx.annotation.Nullable

interface IView {
    fun showLoading(message: String = "")

    fun dismissLoading()

    fun useViewModel(): Boolean = false

    fun initView()

    fun initData(@Nullable savedInstanceState: Bundle?)

}