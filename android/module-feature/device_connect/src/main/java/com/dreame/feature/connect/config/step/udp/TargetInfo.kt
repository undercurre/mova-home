package com.dreame.smartlife.config.step.udp

/**
 *
 */
class TargetInfo(val ip: String, val port: Int) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other == null || javaClass != other.javaClass) return false
        val that = other as TargetInfo
        if (port != that.port) return false
        return ip == that.ip
    }

    override fun hashCode(): Int {
        var result = ip.hashCode()
        result = 31 * result + port
        return result
    }

    override fun toString(): String {
        return "TargetInfo{" +
                "ip='" + ip + '\'' +
                ", port='" + port + '\'' +
                '}'
    }

}