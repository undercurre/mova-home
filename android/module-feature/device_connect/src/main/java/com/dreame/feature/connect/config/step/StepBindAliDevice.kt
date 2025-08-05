package com.dreame.feature.connect.config.step

import android.os.Message
import com.dreame.smartlife.config.step.SmartStepConfig
import com.dreame.smartlife.config.step.StepName
import com.dreame.smartlife.config.step.StepResult
import com.dreame.smartlife.config.step.StepState

class StepBindAliDevice : SmartStepConfig() {

    override fun stepName(): Step = Step.STEP_BIND_ALI_DEVICE

    override fun handleMessage(msg: Message) {

    }

    override fun stepCreate() {
        super.stepCreate()
        stepSuccess()
    }

    override fun stepDestroy() {

    }

    private fun stepFail(reason: String) {
        getHandler().sendMessage(Message.obtain().apply {
            obj =
                StepResult(
                    StepName.STEP_CHECK,
                    StepState.FAILED,
                    reason = reason
                )
        })
        finish(true)
    }

    private fun stepSuccess() {
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_CHECK, StepState.SUCCESS)
        })
        finish(true)
    }

}