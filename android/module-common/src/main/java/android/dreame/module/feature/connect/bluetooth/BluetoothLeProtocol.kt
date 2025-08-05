package android.dreame.module.feature.connect.bluetooth

import java.util.*
import kotlin.experimental.inv


/**
 * 蓝牙配网协议
 */
object BluetoothLeProtocol {

    // 协议 开始和结束
    private const val BYTE_HEAD = 0xC0.toByte()

    // 0xC0 用替换0xDB 0xDC
    private const val BYTE_DB = 0xDB.toByte()
    private const val BYTE_DC = 0xDC.toByte()

    // 0xDB 用替换0xDB 0xDD
    private const val BYTE_DD = 0xDD.toByte()

    // 操作类型
    private const val BYTE_QUERY = 0x81.toByte()
    private const val BYTE_SETTING = 0x82.toByte()
    private const val BYTE_UPLOAD = 0x83.toByte()
    private const val BYTE_ACK_QUERY = 0x84.toByte()
    private const val BYTE_ACK_SETTING = 0x90.toByte()
    private const val BYTE_ACK_ERR = 0xA0.toByte()

    // 对象标识 联机 配网 故障
    private const val BYTE_OBJ_LINK = 0x01.toByte()
    private const val BYTE_OBJ_NETWORK = 0x02.toByte()
    private const val BYTE_OBJ_FAULT = 0x03.toByte()

    /**
     * 解析数据
     * @param data 接受内容
     * @return 拆包结果
     */
    fun parseQueryACKData(data: ByteArray): Pair<Int, String> {
        return parseDataPackage(data, BYTE_ACK_QUERY, BYTE_OBJ_LINK)
    }

    /**
     * 解析数据
     * @param data 接受内容
     * @return 拆包结果
     */
    fun parseSettingACKData(data: ByteArray): Pair<Int, String> {
        return parseDataPackage(data, BYTE_ACK_SETTING, BYTE_OBJ_NETWORK)
    }

    /**
     * 发送数据，组包
     * @return 组包结果
     */
    fun packageQueryData(content: String? = null): ByteArray {
        return packageSendData(BYTE_QUERY, BYTE_OBJ_LINK, content?.toByteArray())
    }

    fun packageQueryData(content: ByteArray): ByteArray {
        return packageSendData(BYTE_QUERY, BYTE_OBJ_LINK, content)
    }

    /**
     * 发送配网数据，组包
     * @return 组包结果
     */
    fun packageSettingData(content: String): ByteArray {
        return packageSendData(BYTE_SETTING, BYTE_OBJ_NETWORK, content.toByteArray())
    }

    fun packageSettingData(content: ByteArray): ByteArray {
        return packageSendData(BYTE_SETTING, BYTE_OBJ_NETWORK, content)
    }


    /**
     * 解析数据包
     * @param data      接收到的数据
     * @param ackType   应答类型
     * @param objType   应答操作对象
     * @return pair 结果 0 success
     *                  -1"： 数据包错误/数据包标识不对
     *                  -2： 应答错误
     *                  -3： 应答类型不对
     *                  -4： 签名校验错误
     */
    fun parseDataPackage(revdata: ByteArray, ackType: Byte, objType: Byte): Pair<Int, String> {

        // 截取第一个数据包
        val indexLast = revdata.size - 1
        // 1、校验数据包是否完整
        if (revdata[0] != BYTE_HEAD && revdata[indexLast] != BYTE_HEAD) {
            return -1 to "data is not complete"
        }
        // 发送方标识
        if (revdata[1] != 0.toByte() && revdata[2] != 0.toByte()) {
            return -1 to "data is not mine"
        }
        if (revdata[3] == BYTE_ACK_ERR) {
            return -2 to "ack err"
        }
        if (revdata[3] != ackType) {
            return -3 to "data is other"
        }
        if (revdata[4] != objType) {
            return -3 to "data is other"
        }

        // 接收到的转换后的数据包
        val data = revdata.convertBytes().dataSubList()

        // 5 6 7 8 9为保留位
        // 10 11 两位数据长度位
        val dataLen = (data[10].toInt() and 0xff) * 256 + (data[11].toInt() and 0xff)

        val dataFromIndex = if (dataLen > 0) 12 else -1
        val dataToIndex = 12 + dataLen - 1

        // 计算校验签名
        val toList = revdata.toList()
        val byte2 = revdata[revdata.size - 2]
        val byte3 = revdata[revdata.size - 3]

        // 签名位数据
        var checksumData = revdata[revdata.size - 2]
        val endIndex = if (byte3 == BYTE_DB && byte2 == BYTE_DC) {
            // C0
            checksumData = BYTE_HEAD
            revdata.size - 3
        } else if (byte3 == BYTE_DB && byte2 == BYTE_DD) {
            // DB
            checksumData = BYTE_DB
            revdata.size - 3
        } else {
            revdata.size - 2
        }

        val checksum = toList.checksum(true, endIndex)

        // 2、校验签名是否正确
        if (checksum[0] != checksumData) {
            return -4 to "data checksum error"
        }
        // 3、获取real数据list
        val contentBytes = if (dataLen > 0) {
            val dataRealList = toList.subList(dataFromIndex, dataToIndex + 1)
            // 4、取数据 去掉转义数据
            dataRealList.toByteArray()
        } else byteArrayOf(0)

        return 0 to String(contentBytes)
    }

    // 配网
    private fun packageSendData(type: Byte, objType: Byte, content: ByteArray?): ByteArray {
        val dataFrame = LinkedList<Byte>()
        val data = content?.run { packageDataFrame(this) } ?: arrayListOf()
        // head
//        dataFrame.add(BYTE_HEAD)
        // 发送方标识
        dataFrame.add(0)
        dataFrame.add(0)
        // 操作类型
        dataFrame.add(type)
        // 对象标识
        dataFrame.add(objType)
        // 保留
        dataFrame.add(0)
        dataFrame.add(0)
        dataFrame.add(0)
        dataFrame.add(0)
        dataFrame.add(0)

        if (data.isNotEmpty()) {
            // 数据长度
            addDataLen(data, dataFrame)
            // 数据内容
            dataFrame.addAll(data)
            // 计算校验位
            val checksum = dataFrame.checksum()
            // 添加校验位
            checksum.forEach {
                dataFrame.add(it)
            }
        } else {
            // 数据长度
            dataFrame.add(0)
            dataFrame.add(0)
            // 数据内容

            // 计算校验位
            val checksum = dataFrame.checksum()
            // 添加校验位
            checksum.forEach {
                dataFrame.add(it)
            }
        }


        // 替换
        val flatMap = dataFrame.flatMap {
            it.convertByte().asIterable()
        }
        // 帧结束
        dataFrame.clear()
        dataFrame.add(BYTE_HEAD)
        dataFrame.addAll(flatMap)
        dataFrame.add(BYTE_HEAD)
        return dataFrame.toByteArray()
    }

    fun addDataLen(
        data: MutableList<Byte>,
        dataFrame: LinkedList<Byte>
    ) {
        val dataLength = data.size.calculateLength()
        if (dataLength.size > 1) {
            dataFrame.add(dataLength[0])
            dataFrame.add(dataLength[1])
        } else {
            // 高位
            dataFrame.add(0)
            //低位
            dataFrame.add(dataLength[0])

        }
    }

    /**
     * 计算数据帧
     */
    fun packageDataFrame(contentByteArray: ByteArray): MutableList<Byte> {
        // 计算数据位
        return contentByteArray.convertBytes().map {
            it.convertByte().asIterable()
        }.flatten().toMutableList()
    }


    /**
     * 计算校验位
     */
    private fun List<Byte>.checksum(skipHead: Boolean = false, endIndex: Int = size): ByteArray {
        var ret: Byte = 0
        this.onEachIndexed { index, b ->
            if ((skipHead && index == 0) || index >= endIndex) {
                // 跳过 head 和 校验位
            } else {
                ret = (ret + b).toByte()
            }

        }
        ret = ret.inv()
        return byteArrayOf(ret)
    }

    /**
     * byte 位
     * 0xC0 用替换0xDB 0xDC
     * 0xDB 用替换0xDB 0xDD
     */
    private fun Byte.convertByte(): ByteArray {
        return when (this) {
            BYTE_HEAD -> {
                byteArrayOf(BYTE_DB, BYTE_DC)
            }

            BYTE_DB -> {
                byteArrayOf(BYTE_DB, BYTE_DD)
            }

            else -> {
                byteArrayOf(this)
            }
        }
    }

    fun ByteArray.convertBytes(): ByteArray {
        val list = mutableListOf<Byte>()
        var skip = false;
        for (i in 0 until size) {
            val b1 = this[i]
            if (skip) {
                skip = false
                continue
            }
            // 控制结束
            if (i + 1 > size - 1) {
                list.add(b1)
                continue
            }
            val b2 = this[i + 1]
            if (b1 == BYTE_DB && b2 == BYTE_DC) {
                list.add(BYTE_HEAD)
                skip = true;
            } else if (b1 == BYTE_DB && b2 == BYTE_DD) {
                list.add(BYTE_DB)
                skip = true;
            } else {
                list.add(b1)
            }
        }
        return list.toByteArray()

    }

    /**
     * 截取有效数据
     */
    private fun ByteArray.dataSubList(): ByteArray {
        val list = mutableListOf<Byte>()
        list.add(BYTE_HEAD)
        for (i in 1 until size) {
            if (this[i] == BYTE_HEAD) {
                break
            }
            list.add(this[i])
        }
        list.add(BYTE_HEAD)
        return list.toByteArray()
    }


    private fun Int.calculateLength(): ByteArray {
        val h = this shr 8 and 0xff
        val l = this and 0xff
        return byteArrayOf(h.toByte(), l.toByte())
    }
}