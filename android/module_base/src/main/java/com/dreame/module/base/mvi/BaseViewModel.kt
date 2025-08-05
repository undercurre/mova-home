package com.dreame.module.base.mvi

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/03/23
 *     desc   :
 *     version: 1.0
 * </pre>
 */
interface UiState
interface UiEvent
interface UiAction

abstract class BaseViewModel<State : UiState, Event : UiEvent> : ViewModel() {

    /**
     * 初始状态
     * stateFlow区别于LiveData必须有初始值
     */
    private val initialState: State by lazy { createInitialState() }
    abstract fun createInitialState(): State

    /**
     * uiState聚合页面的全部UI 状态
     */
    protected val _uiStates: MutableStateFlow<State> = MutableStateFlow(initialState)
    val uiStates = _uiStates.asStateFlow()

    /**
     * 事件带来的副作用，通常是 一次性事件 且 一对一的订阅关系
     * 例如：弹Toast
     */

    protected val _uiEvents: Channel<Event> = Channel()
    val uiEvents = _uiEvents.receiveAsFlow()

    abstract fun dispatchAction(action: UiAction)
}