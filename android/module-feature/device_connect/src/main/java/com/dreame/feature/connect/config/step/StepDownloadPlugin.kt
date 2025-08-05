package com.dreame.smartlife.config.step

import android.os.Message

/**
 * # 插件下载
 */
class StepDownloadPlugin : SmartStepConfig() {

    override fun stepName(): Step = Step.STEP_APP_DOWNLOAD_PLUGIN

    override fun handleMessage(msg: Message) {
    }

    override fun stepCreate() {
        super.stepCreate()
    }

    override fun stepDestroy() {
    }

}