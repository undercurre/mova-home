package com.zj.mvi.core

import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlin.reflect.KProperty1

fun <T, A> StateFlow<T>.observeState(
    lifecycleOwner: LifecycleOwner,
    prop1: KProperty1<T, A>,
    action: (A) -> Unit
) {
    lifecycleOwner.lifecycleScope.launch {
        lifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
            this@observeState.map {
                prop1.get(it)
            }.distinctUntilChanged().collect { a ->
                action.invoke(a)
            }
        }
    }
}

fun <T, A> StateFlow<T>.observeStateList(
    lifecycleOwner: LifecycleOwner,
    prop1: KProperty1<T, Collection<A>>,
    action: (Collection<A>) -> Unit
) {
    lifecycleOwner.lifecycleScope.launch {
        lifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
            this@observeStateList.map {
                prop1.get(it)
            }.distinctUntilChanged { old, new ->
                old === new
            }
                .collect { a ->
                action.invoke(a)
            }
        }
    }
}

fun <T, A, B> StateFlow<T>.observeState(
    lifecycleOwner: LifecycleOwner,
    prop1: KProperty1<T, A>,
    prop2: KProperty1<T, B>,
    action: (A, B) -> Unit
) {
    lifecycleOwner.lifecycleScope.launch {
        lifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
            this@observeState.map {
                Pair(prop1.get(it), prop2.get(it))
            }.distinctUntilChanged().collect { (first, second) ->
                action.invoke(first, second)
            }
        }
    }
}

fun <T, A, B, C> StateFlow<T>.observeState(
    lifecycleOwner: LifecycleOwner,
    prop1: KProperty1<T, A>,
    prop2: KProperty1<T, B>,
    prop3: KProperty1<T, C>,
    action: (A, B, C) -> Unit
) {
    lifecycleOwner.lifecycleScope.launch {
        lifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
            this@observeState.map {
                Triple(prop1.get(it), prop2.get(it), prop3.get(it))
            }.distinctUntilChanged().collect { (first, second, third) ->
                action.invoke(first, second, third)
            }
        }
    }
}

fun <T> MutableStateFlow<T>.setState(reducer: T.() -> T) {
    this.value = this.value.reducer()
}

inline fun <T, R> withState(state: StateFlow<T>, block: (T) -> R): R {
    return state.value.let(block)
}

suspend fun <T> Channel<T>.setEvent(value: T) {
    this.send(value)
}

fun <T> Flow<T>.observeEvent(lifecycleOwner: LifecycleOwner, action: (T) -> Unit) {
    lifecycleOwner.lifecycleScope.launchWhenStarted {
        this@observeEvent.collect {
            action.invoke(it)
        }
    }
}

fun <T> Flow<T>.observeEventWhenCreate(lifecycleOwner: LifecycleOwner, action: (T) -> Unit) {
    lifecycleOwner.lifecycleScope.launchWhenCreated {
        this@observeEventWhenCreate.collect {
            action.invoke(it)
        }
    }
}