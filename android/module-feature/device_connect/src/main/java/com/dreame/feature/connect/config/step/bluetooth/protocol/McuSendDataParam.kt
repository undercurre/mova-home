package com.dreame.feature.connect.config.step.bluetooth.protocol

import android.dreame.module.manager.AccountManager
import android.dreame.module.feature.connect.bluetooth.BluetoothLeProtocol
import android.dreame.module.feature.connect.bluetooth.BluetoothLeProtocol.convertBytes
import android.dreame.module.feature.connect.bluetooth.formatHexString
import java.util.Arrays
import java.util.Random

/**
 * 单片机配网参数组装
 * [https://dreametech.feishu.cn/docx/DwTmdsTSKoUirQxqePoc2NnenBe]
 */
class McuData(val siid: Byte, val piid: Byte, val type: Byte, val content: ByteArray) {

}

class McuSendDataParam {
    companion object {
        const val HEAD = 0xC0.toByte()
        const val END = HEAD

        const val SIID_CONFIG_NET = 0x01.toByte()

        const val PIID_STEP_1_RANDOM_CODE = 0x01.toByte()
        const val PIID_STEP_1_CONFIG_NET = 0x02.toByte()


        const val TYPE_ARRAY_NO = 0x0F.toByte()
        const val TYPE_ARRAY = 0x80.toByte()

        const val TYPE_STRING = 0x0.toByte()
        const val TYPE_UINT8 = 0x1.toByte()
        const val TYPE_UINT16 = 0x2.toByte()
        const val TYPE_UINT32 = 0x3.toByte()
        const val TYPE_UINT64 = 0x4.toByte()
    }

    private val randomCode = getRandomString(6)


    /**
     * 下发配网参数
     * @param randomCode 6位随机数
     * @param uid uid
     * @return ByteArray  randomCode + uid
     */
    fun packageRandomCode(): ByteArray {
        val uid = AccountManager.getInstance().account.uid ?: ""
        val list = mutableListOf<Byte>()
        // head

        // SIID
        list.add(SIID_CONFIG_NET)
        val dataList = mutableListOf<Byte>()
        // PIID
        dataList.add(PIID_STEP_1_RANDOM_CODE)
        // type
        val type = 0x80.toByte()
        dataList.add(type)
        val a1 = randomCode.toByteArray()
        val a2 = uid.toByteArray()
        dataList.add((2).toByte())
        dataList.add(a1.size.toByte())
        dataList.addAll(a1.toList())
        dataList.add(a2.size.toByte())
        dataList.addAll(a2.toList())
        // end
        list.addAll(dataList)
        val packageDataFrame = BluetoothLeProtocol.packageDataFrame(list.toByteArray())
        packageDataFrame.add(0, HEAD)
        packageDataFrame.add(END)
        return packageDataFrame.toByteArray()
    }

    /**
     * 解析配网参数
     * @param content 配网参数
     * @return Pair<encryptContent, did>
     */
    fun parseRandomCode(content: ByteArray): Map<String, String> {
        val parseMcuContent = parseMcuContent(SIID_CONFIG_NET, content)
        if (parseMcuContent.isEmpty()) {
            return emptyMap()
        }
        val encryptContent = parseMcuContent[0].content.formatHexString(false)
        val did = String(parseMcuContent[1].content)
        val ver = if (parseMcuContent.size > 2) {
            String(parseMcuContent[2].content)
        } else {
            ""
        }
        return mapOf(
            "code" to "0",
            "encryptUid" to encryptContent,
            "did" to did,
            "ver" to ver,
            "nonce" to randomCode,
        )
    }

    /**
     * @param success 0x0:失败 0x1:成功
     */
    fun packageConfigNet(success: Byte): ByteArray {
        val list = mutableListOf<Byte>()
        // head
        // SIID
        list.add(SIID_CONFIG_NET)
        //配网结果
        list.addAll(packageMcuData(PIID_STEP_1_CONFIG_NET, TYPE_ARRAY_NO, TYPE_UINT8, byteArrayOf(success)).toList())
        // end
        val packageDataFrame = BluetoothLeProtocol.packageDataFrame(list.toByteArray())
        packageDataFrame.add(0, HEAD)
        packageDataFrame.add(END)
        return packageDataFrame.toByteArray()
    }

    fun packageConfigNet(content: ByteArray): Map<String, String> {
        val parseMcuContent = parseMcuContent(SIID_CONFIG_NET, content)
        if (parseMcuContent.isNotEmpty()) {
            val content1 = parseMcuContent[0].content
            val type = parseMcuContent[0].type
            if (type == TYPE_UINT8) {
                return mapOf("code" to content1[0].toString())
            }
        }
        return mapOf("code" to "-1")
    }

    /**
     * 组装数据
     * @param piid 操作类型
     * @param type1 是否是数组 0x0:否 0x1:是
     * @param type2 数据类型 0x0:string 0x1:uint8 0x2:uint16 0x3:uint32 0x4:uint64
     * @param content  当为字符串数组的时候，数组内容为: 字符串长度,字符串，字符串长度，字符串......
     */
    private fun packageMcuData(piid: Byte, type1: Byte, type2: Byte, content: ByteArray): ByteArray {
        val list = mutableListOf<Byte>()
        // PIID
        list.add(piid)
        // type
        val type = (type1.toInt() and TYPE_ARRAY.toInt()) or (type2.toInt() and TYPE_ARRAY_NO.toInt())
        list.add(type.toByte())
        if (content.size > 1) {
            list.add(content.size.toByte())
        }
        list.addAll(content.toList())
        return list.toByteArray()
    }

    private fun parseMcuContent(siid: Byte, convertBytes: ByteArray): List<McuData> {
        if (convertBytes.isEmpty()) {
            // 数据头尾错误
            return emptyList()
        }
        if (convertBytes[0] != HEAD && convertBytes[convertBytes.size - 1] != END) {
            // 数据头尾错误
            return emptyList()
        }
        if (convertBytes[1] != siid) {
            // 数据siid错误
            return emptyList()
        }
        val content = convertBytes.convertBytes()
        // C0 01 01 80 02 15 8B 13 58 14 BC 62 13 63 3B 5E 04 F2 0A 22 6D CE F9 9E 5C C1 10 0A 31 32 33 34 35 36 37 38 39 30 C0
        val contents: MutableList<McuData> = mutableListOf()
        var index = 2
        while (index < content.size) {
            val piid = content[index++]
            val type = content[index++]
            val typeArr = type.toInt() and TYPE_ARRAY.toInt()
            val arrLength = content[index++].toInt()
            if (typeArr.toByte() == TYPE_ARRAY) {
                val byteType = (type.toInt() and TYPE_ARRAY_NO.toInt()).toByte()
                if (byteType == TYPE_STRING) {
                    var subIndex = 0
                    while (subIndex < arrLength) {
                        val length = content[index++].toInt()
                        val data = Arrays.copyOfRange(content, index, index + length)
                        contents.add(McuData(siid, piid, byteType, data))
                        index += length
                        subIndex++
                    }
                } else {
                    val data = Arrays.copyOfRange(content, index++, index + arrLength)
                    contents.add(McuData(siid, piid, byteType, data))
                }
            } else {
                val byteType = (type.toInt() and TYPE_ARRAY_NO.toInt()).toByte()
                if (byteType == TYPE_UINT8) {
                    contents.add(McuData(siid, piid, byteType, byteArrayOf(arrLength.toByte())))
                } else {
                    val data = Arrays.copyOfRange(content, index++, index + arrLength)
                    contents.add(McuData(siid, piid, byteType, data))
                }
            }
            //Advance
            index += arrLength
        }
        return contents
    }

    fun getRandomString(length: Int): String {
        val str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        val random = Random()
        val sb = StringBuffer()
        for (i in 0 until length) {
            val number = random.nextInt(str.length)
            sb.append(str[number])
        }
        return sb.toString()
    }
}
