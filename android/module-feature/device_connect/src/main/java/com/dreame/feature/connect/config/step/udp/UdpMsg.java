package com.dreame.feature.connect.config.step.udp;


import com.dreame.smartlife.config.step.udp.TargetInfo;

import java.util.Arrays;
import java.util.concurrent.atomic.AtomicInteger;

/**
 *
 */
public class UdpMsg {
    public enum MsgType {
        Send, Receive
    }

    private static final AtomicInteger IDAtomic = new AtomicInteger();
    private int id;
    private byte[] sourceDataBytes;//数据源
    private String sourceDataString;//数据源
    private TargetInfo target;
    private long time;//发送、接受消息的时间戳
    private MsgType mMsgType = MsgType.Send;
    private byte[][] endDecodeData;

    public UdpMsg(int id) {
        this.id = id;
    }

    public UdpMsg(byte[] data, TargetInfo target, MsgType type) {
        this.sourceDataBytes = data;
        this.target = target;
        this.mMsgType = type;
        init();
    }

    public UdpMsg(String data, TargetInfo target, MsgType type) {
        this.target = target;
        this.sourceDataString = data;
        this.mMsgType = type;
        init();
    }

    public void setTime() {
        time = System.currentTimeMillis();
    }

    private void init() {
        id = IDAtomic.getAndIncrement();
    }

    public long getTime() {
        return time;
    }

    public byte[][] getEndDecodeData() {
        return endDecodeData;
    }

    public void setEndDecodeData(byte[][] endDecodeData) {
        this.endDecodeData = endDecodeData;
    }

    public MsgType getMsgType() {
        return mMsgType;
    }

    public void setMsgType(MsgType msgType) {
        mMsgType = msgType;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        UdpMsg UdpMsg = (UdpMsg) o;
        return id == UdpMsg.id;
    }

    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        if (endDecodeData != null) {
            for (byte[] bs : endDecodeData) {
                sb.append(Arrays.toString(bs));
            }
        }
        return "UdpMsg{" +
                "sourceDataBytes=" + Arrays.toString(sourceDataBytes) +
                ", id=" + id +
                ", sourceDataString='" + sourceDataString + '\'' +
                ", target=" + target +
                ", time=" + time +
                ", msgtyoe=" + mMsgType +
                ", enddecode=" + sb.toString() +
                '}';
    }

    @Override
    public int hashCode() {
        return id;
    }


    public byte[] getSourceDataBytes() {
        return sourceDataBytes;
    }

    public void setSourceDataBytes(byte[] sourceDataBytes) {
        this.sourceDataBytes = sourceDataBytes;
    }

    public String getSourceDataString() {
        return sourceDataString;
    }

    public void setSourceDataString(String sourceDataString) {
        this.sourceDataString = sourceDataString;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public static AtomicInteger getIDAtomic() {
        return IDAtomic;
    }

    public TargetInfo getTarget() {
        return target;
    }

    public void setTarget(TargetInfo target) {
        this.target = target;
    }
}
