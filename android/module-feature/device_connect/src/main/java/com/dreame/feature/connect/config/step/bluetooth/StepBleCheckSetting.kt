package android.dreame.module.feature.connect.bluetooth

import android.dreame.module.util.LogUtil
import android.os.Message
import android.util.Log
import com.dreame.smartlife.config.step.*
import android.dreame.module.feature.connect.bluetooth.callback.BleMtuChangedCallback

class StepBleCheckSetting : SmartStepConfig() {
    override fun stepName(): Step = Step.STEP_SETTING_CHECK_BLE

    override fun handleMessage(msg: Message) {

    }

    override fun stepCreate() {
        super.stepCreate()
        LogUtil.d(TAG, "stepCreate: StepBleCheckSetting")
        settingMtu()
    }

    private fun settingMtu() {
        LogUtil.i(TAG, "settingMtu")
        StepData.bleDeviceWrapper?.deviceWrapper?.let {
            BluetoothLeManager.setMtu(it, DEFAULT_MAX_MTU, mtuCallback)
        }
    }

    private val mtuCallback = object : BleMtuChangedCallback() {
        override fun onSetMTUFailure(exception: BleException) {
            LogUtil.e(TAG, "onSetMTUFailure: ${exception.description}")
            if (StepData.productModel.contains(".mower")) {
                nextStep(Step.STEP_SEND_DATA_BLE_MOWER)
            } else if (StepData.productModel.contains(".toothbrush.") || StepData.extendScType.contains(
                    ScanType.MCU
                )
            ) {
                nextStep(Step.STEP_SEND_DATA_BLE_MCU)
            } else {
                nextStep(Step.STEP_SEND_DATA_BLE)
            }
        }

        override fun onMtuChanged(mtu: Int) {
            LogUtil.i(TAG, "onMtuChanged: $mtu")
            if (mtu < DEFAULT_MAX_MTU) {
                Log.e(TAG, "settingMtu onMtuChanged: $mtu, maybe error!!!")
            }
            if (StepData.productModel.contains(".mower")) {
                nextStep(Step.STEP_SEND_DATA_BLE_MOWER)
            } else if (StepData.productModel.contains(".toothbrush.") || StepData.extendScType.contains(
                    ScanType.MCU
                )
            ) {
                nextStep(Step.STEP_SEND_DATA_BLE_MCU)
            } else {
                nextStep(Step.STEP_SEND_DATA_BLE)
            }
        }

    }


    override fun stepDestroy() {
        StepData.bleDeviceWrapper?.deviceWrapper?.let {
            BluetoothLeManager.removeMtuChangeCallback(it, mtuCallback)
        }
    }
}