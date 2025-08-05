package android.dreame.module.feature.connect.bluetooth

import android.os.ParcelUuid
import android.dreame.module.feature.connect.bluetooth.MyBluetoothUuid
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.*

/**
 * Static helper methods and constants to decode the ParcelUuid of remote devices.
 *
 * @hide
 */
object MyBluetoothUuid {
    /* See Bluetooth Assigned Numbers document - SDP section, to get the values of UUIDs
     * for the various services.
     *
     * The following 128 bit values are calculated as:
     *  uuid * 2^96 + BASE_UUID
     */
    val A2DP_SINK = ParcelUuid.fromString("0000110B-0000-1000-8000-00805F9B34FB")
    val A2DP_SOURCE = ParcelUuid.fromString("0000110A-0000-1000-8000-00805F9B34FB")
    val ADV_AUDIO_DIST = ParcelUuid.fromString("0000110D-0000-1000-8000-00805F9B34FB")
    val HSP = ParcelUuid.fromString("00001108-0000-1000-8000-00805F9B34FB")
    val HSP_AG = ParcelUuid.fromString("00001112-0000-1000-8000-00805F9B34FB")
    val HFP = ParcelUuid.fromString("0000111E-0000-1000-8000-00805F9B34FB")
    val HFP_AG = ParcelUuid.fromString("0000111F-0000-1000-8000-00805F9B34FB")
    val AVRCP_CONTROLLER = ParcelUuid.fromString("0000110E-0000-1000-8000-00805F9B34FB")
    val AVRCP_TARGET = ParcelUuid.fromString("0000110C-0000-1000-8000-00805F9B34FB")
    val OBEX_OBJECT_PUSH = ParcelUuid.fromString("00001105-0000-1000-8000-00805f9b34fb")
    val HID = ParcelUuid.fromString("00001124-0000-1000-8000-00805f9b34fb")
    val HOGP = ParcelUuid.fromString("00001812-0000-1000-8000-00805f9b34fb")
    val PANU = ParcelUuid.fromString("00001115-0000-1000-8000-00805F9B34FB")
    val NAP = ParcelUuid.fromString("00001116-0000-1000-8000-00805F9B34FB")
    val BNEP = ParcelUuid.fromString("0000000f-0000-1000-8000-00805F9B34FB")
    val PBAP_PCE = ParcelUuid.fromString("0000112e-0000-1000-8000-00805F9B34FB")
    val PBAP_PSE = ParcelUuid.fromString("0000112f-0000-1000-8000-00805F9B34FB")
    val MAP = ParcelUuid.fromString("00001134-0000-1000-8000-00805F9B34FB")
    val MNS = ParcelUuid.fromString("00001133-0000-1000-8000-00805F9B34FB")
    val MAS = ParcelUuid.fromString("00001132-0000-1000-8000-00805F9B34FB")
    val SAP = ParcelUuid.fromString("0000112D-0000-1000-8000-00805F9B34FB")
    val HEARING_AID = ParcelUuid.fromString("0000FDF0-0000-1000-8000-00805f9b34fb")
    val LE_AUDIO = ParcelUuid.fromString("0000184E-0000-1000-8000-00805F9B34FB")
    val DIP = ParcelUuid.fromString("00001200-0000-1000-8000-00805F9B34FB")
    val VOLUME_CONTROL = ParcelUuid.fromString("00001844-0000-1000-8000-00805F9B34FB")
    val GENERIC_MEDIA_CONTROL = ParcelUuid.fromString("00001849-0000-1000-8000-00805F9B34FB")
    val MEDIA_CONTROL = ParcelUuid.fromString("00001848-0000-1000-8000-00805F9B34FB")
    val COORDINATED_SET = ParcelUuid.fromString("00001846-0000-1000-8000-00805F9B34FB")
    val CAP = ParcelUuid.fromString("EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEEEEE")
    val BASE_UUID = ParcelUuid.fromString("00000000-0000-1000-8000-00805F9B34FB")

    /**
     * Length of bytes for 16 bit UUID
     *
     * @hide
     */
    const val UUID_BYTES_16_BIT = 2

    /**
     * Length of bytes for 32 bit UUID
     *
     * @hide
     */
    const val UUID_BYTES_32_BIT = 4

    /**
     * Length of bytes for 128 bit UUID
     *
     * @hide
     */
    const val UUID_BYTES_128_BIT = 16

    /**
     * Returns true if there any common ParcelUuids in uuidA and uuidB.
     *
     * @param uuidA - List of ParcelUuids
     * @param uuidB - List of ParcelUuids
     * @hide
     */
    fun containsAnyUuid(
        uuidA: Array<ParcelUuid?>?,
        uuidB: Array<ParcelUuid>?
    ): Boolean {
        if (uuidA == null && uuidB == null) return true
        if (uuidA == null) {
            return uuidB!!.size == 0
        }
        if (uuidB == null) {
            return uuidA.size == 0
        }
        val uuidSet = HashSet(Arrays.asList(*uuidA))
        for (uuid in uuidB) {
            if (uuidSet.contains(uuid)) return true
        }
        return false
    }

    /**
     * Extract the Service Identifier or the actual uuid from the Parcel Uuid.
     * For example, if 0000110B-0000-1000-8000-00805F9B34FB is the parcel Uuid,
     * this function will return 110B
     *
     * @param parcelUuid
     * @return the service identifier.
     */
    private fun getServiceIdentifierFromParcelUuid(parcelUuid: ParcelUuid): Int {
        val uuid = parcelUuid.uuid
        val value = uuid.mostSignificantBits and -0x100000000L ushr 32
        return value.toInt()
    }

    /**
     * Parse UUID from bytes. The `uuidBytes` can represent a 16-bit, 32-bit or 128-bit UUID,
     * but the returned UUID is always in 128-bit format.
     * Note UUID is little endian in Bluetooth.
     *
     * @param uuidBytes Byte representation of uuid.
     * @return [ParcelUuid] parsed from bytes.
     * @throws IllegalArgumentException If the `uuidBytes` cannot be parsed.
     * @hide
     */
    @JvmStatic
    fun parseUuidFrom(uuidBytes: ByteArray): ParcelUuid {
        requireNotNull(uuidBytes) { "uuidBytes cannot be null" }
        val length = uuidBytes.size
        require(!(length != UUID_BYTES_16_BIT && length != UUID_BYTES_32_BIT && length != UUID_BYTES_128_BIT)) { "uuidBytes length invalid - $length" }
        // Construct a 128 bit UUID.
        if (length == UUID_BYTES_128_BIT) {
            val buf = ByteBuffer.wrap(uuidBytes).order(ByteOrder.LITTLE_ENDIAN)
            val msb = buf.getLong(8)
            val lsb = buf.getLong(0)
            return ParcelUuid(UUID(msb, lsb))
        }
        // For 16 bit and 32 bit UUID we need to convert them to 128 bit value.
        // 128_bit_value = uuid * 2^96 + BASE_UUID
        var shortUuid: Long
        if (length == UUID_BYTES_16_BIT) {
            shortUuid = (uuidBytes[0].toInt() and 0xFF).toLong()
            shortUuid += (uuidBytes[1].toInt() and 0xFF shl 8).toLong()
        } else {
            shortUuid = (uuidBytes[0].toInt() and 0xFF).toLong()
            shortUuid += (uuidBytes[1].toInt() and 0xFF shl 8).toLong()
            shortUuid += (uuidBytes[2].toInt() and 0xFF shl 16).toLong()
            shortUuid += (uuidBytes[3].toInt() and 0xFF shl 24).toLong()
        }
        val msb = BASE_UUID.uuid.mostSignificantBits + (shortUuid shl 32)
        val lsb = BASE_UUID.uuid.leastSignificantBits
        return ParcelUuid(UUID(msb, lsb))
    }

    /**
     * Parse UUID to bytes. The returned value is shortest representation, a 16-bit, 32-bit or
     * 128-bit UUID, Note returned value is little endian (Bluetooth).
     *
     * @param uuid uuid to parse.
     * @return shortest representation of `uuid` as bytes.
     * @throws IllegalArgumentException If the `uuid` is null.
     * @hide
     */
    fun uuidToBytes(uuid: ParcelUuid?): ByteArray {
        requireNotNull(uuid) { "uuid cannot be null" }
        if (is16BitUuid(uuid)) {
            val uuidBytes = ByteArray(UUID_BYTES_16_BIT)
            val uuidVal = getServiceIdentifierFromParcelUuid(uuid)
            uuidBytes[0] = (uuidVal and 0xFF).toByte()
            uuidBytes[1] = (uuidVal and 0xFF00 shr 8).toByte()
            return uuidBytes
        }
        if (is32BitUuid(uuid)) {
            val uuidBytes = ByteArray(UUID_BYTES_32_BIT)
            val uuidVal = getServiceIdentifierFromParcelUuid(uuid)
            uuidBytes[0] = (uuidVal and 0xFF).toByte()
            uuidBytes[1] = (uuidVal and 0xFF00 shr 8).toByte()
            uuidBytes[2] = (uuidVal and 0xFF0000 shr 16).toByte()
            uuidBytes[3] = (uuidVal and -0x1000000 shr 24).toByte()
            return uuidBytes
        }
        // Construct a 128 bit UUID.
        val msb = uuid.uuid.mostSignificantBits
        val lsb = uuid.uuid.leastSignificantBits
        val uuidBytes = ByteArray(UUID_BYTES_128_BIT)
        val buf = ByteBuffer.wrap(uuidBytes).order(ByteOrder.LITTLE_ENDIAN)
        buf.putLong(8, msb)
        buf.putLong(0, lsb)
        return uuidBytes
    }

    /**
     * Check whether the given parcelUuid can be converted to 16 bit bluetooth uuid.
     *
     * @param parcelUuid
     * @return true if the parcelUuid can be converted to 16 bit uuid, false otherwise.
     * @hide
     */
    fun is16BitUuid(parcelUuid: ParcelUuid): Boolean {
        val uuid = parcelUuid.uuid
        return if (uuid.leastSignificantBits != BASE_UUID.uuid.leastSignificantBits) {
            false
        } else uuid.mostSignificantBits and -0xffff00000001L == 0x1000L
    }

    /**
     * Check whether the given parcelUuid can be converted to 32 bit bluetooth uuid.
     *
     * @param parcelUuid
     * @return true if the parcelUuid can be converted to 32 bit uuid, false otherwise.
     * @hide
     */
    fun is32BitUuid(parcelUuid: ParcelUuid): Boolean {
        val uuid = parcelUuid.uuid
        if (uuid.leastSignificantBits != BASE_UUID.uuid.leastSignificantBits) {
            return false
        }
        return if (is16BitUuid(parcelUuid)) {
            false
        } else uuid.mostSignificantBits and 0xFFFFFFFFL == 0x1000L
    }
}