package android.dreame.module.feature.connect.bluetoothv2

import java.util.UUID

object BluetoothUUIDUtils {

    fun uuid16To128Complete(uuid: String): String {
        return when (uuid.length) {
            4 -> {
                // 16-bit uuid
                String.format("0000%s-0000-1000-8000-00805F9B34FB", uuid).uppercase()
            }

            8 -> {
                // 32-bit uuid
                String.format("%s-0000-1000-8000-00805F9B34FB", uuid).uppercase()
            }

            else -> {
                // 128-bit uuid
                uuid.uppercase()
            }
        }
    }

    fun uuid16To128CompleteUUID(uuid: String): UUID {
        val uuidNew = when (uuid.length) {
            4 -> {
                // 16-bit uuid
                String.format("0000%s-0000-1000-8000-00805F9B34FB", uuid).uppercase()
            }

            8 -> {
                // 32-bit uuid
                String.format("%s-0000-1000-8000-00805F9B34FB", uuid).uppercase()
            }

            else -> {
                // 128-bit uuid
                uuid.uppercase()
            }
        }
        return UUID.fromString(uuidNew)
    }

}