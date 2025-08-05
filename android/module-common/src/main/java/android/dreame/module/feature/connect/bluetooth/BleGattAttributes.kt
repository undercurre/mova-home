/*
 * Copyright (C) 2013 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package android.dreame.module.feature.connect.bluetooth

import java.util.*

/**
 * This class includes a small subset of standard GATT attributes for demonstration purposes.
 */
object BleGattAttributes {
    private val attributes = mutableMapOf<String, UUID>()
    const val HEART_RATE_MEASUREMENT = "00002A37-0000-1000-8000-00805F9B34FB"
    const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805F9B34FB"

    //
    const val BASE_UUID = "00000000-0000-1000-8000-00805F9B34FB"
    const val BASE_UUID_128_COMPLETE_FIX = "0000xxxx-0000-1000-8000-00805F9B34FB"
    const val BASE_UUID_128_COMPLETE_SUFFIX = "-0000-1000-8000-00805F9B34FB"

    const val CLIENT_CHARACTERISTIC_SERVICE = "0000FE98-0000-1000-8000-00805F9B34FB"
    const val CLIENT_CHARACTERISTIC_READ = "00002A02-0000-1000-8000-00805F9B34FB"
    const val CLIENT_CHARACTERISTIC_WRITE = "00002A03-0000-1000-8000-00805F9B34FB"

    // 割草机交互
    const val CLIENT_CHARACTERISTIC_WRITE_NOTIFY = "00002A04-0000-1000-8000-00805F9B34FB"

    fun lookup(uuid: String): UUID {
        val uuid1 = attributes[uuid]
        if (uuid1 != null) {
            return uuid1;
        }
        val fromString = UUID.fromString(uuid)
        attributes[uuid] = fromString;
        return fromString;
    }

}