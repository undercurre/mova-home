package com.dreame.feature.connect.config.step.udp;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.dreame.feature.connect.config.step.udp.listener.UdpClientListener;
import com.dreame.smartlife.config.step.udp.TargetInfo;
import com.dreame.smartlife.config.step.udp.TestSocketCanConnect;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.LinkedBlockingQueue;

import kotlin.Unit;
import kotlin.jvm.functions.Function2;

/**
 * udp 客户端
 * <a href="https://github.com/Blankeer/XAndroidSocket">XAndroidSocket</a>
 */
public class XUdp {
    private static final String TAG = "XUdp";
    protected UdpClientConfig mUdpClientConfig;
    protected List<UdpClientListener> mUdpClientListeners;
    private DatagramSocket datagramSocket;
    private SendThread sendThread;
    private ReceiveThread receiverThread;
    private Handler mUIHandler;
    private TestSocketCanConnect testSocketCanConnect;

    private XUdp() {
        super();
        mUIHandler = new Handler(Looper.getMainLooper());
        testSocketCanConnect = new TestSocketCanConnect(mUIHandler);
    }

    public static XUdp getUdpClient() {
        XUdp client = new XUdp();
        client.init();
        return client;
    }

    private void init() {
        mUdpClientListeners = new ArrayList<>();
        mUdpClientConfig = new UdpClientConfig.Builder().create();
    }

    public void closeSocket() {
        if (datagramSocket != null && datagramSocket.isConnected()) {
            try {
                datagramSocket.disconnect();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                datagramSocket = null;
            }
        }
        if (datagramSocket != null) {
            datagramSocket = null;
        }
    }

    public void socketReadRobotLastFailCode(TargetInfo info, Function2<Boolean, String, Unit> function) {
        testSocketCanConnect.socketReadRobotLastFailCode(info.getIp(), info.getPort(), true, function);
    }

    public void socketReadRobotLastFailLog(TargetInfo info, Function2<Boolean, String, Unit> function) {
        testSocketCanConnect.socketReadRobotLastFailLog(info.getIp(), info.getPort(), true, function);
    }

    public void testSocketConnect(TargetInfo info, Function2<Boolean, String, Unit> function) {
        testSocketCanConnect.testSocketConnect(info.getIp(), info.getPort(), true, function);
    }

    public void startUdpServer() {
        if (!getReceiveThread().isAlive()) {
            getReceiveThread().start();
            Log.d(TAG, "udp server started");
        }
    }

    public void stopUdpServer() {
        getReceiveThread().interrupt();
        notifyStopListener();
    }

    public boolean isUdpServerRuning() {
        return getReceiveThread().isAlive();
    }

    public void sendMsg(UdpMsg msg, boolean isReply) {
        if (!getSendThread().isAlive()) {//开启发送线程
            getSendThread().start();
        }
        getSendThread().enqueueUdpMsg(msg);
        if (isReply) {//根据是否需要回复，开启接受线程
            startUdpServer();
        }
    }

    public void sendMsg(UdpMsg msg) {
        sendMsg(msg, false);
    }

    private SendThread getSendThread() {
        if (sendThread == null || !sendThread.isAlive()) {
            sendThread = new SendThread();
        }
        return sendThread;
    }

    private ReceiveThread getReceiveThread() {
        if (receiverThread == null || !receiverThread.isAlive()) {
            receiverThread = new ReceiveThread();
        }
        return receiverThread;
    }

    private synchronized DatagramSocket createSocket() {
        if (datagramSocket != null) {
            return datagramSocket;
        }
        try {
            datagramSocket = new DatagramSocket();
            datagramSocket.setReuseAddress(true);
            datagramSocket.setBroadcast(true);
            datagramSocket.setSoTimeout((int) mUdpClientConfig.getReceiveTimeout());
        } catch (SocketException e) {
            e.printStackTrace();
            notifyErrorListener("udp create socket error", e);
            datagramSocket = null;
        }
        return datagramSocket;
    }

    public synchronized DatagramSocket getDatagramSocket() {
        if (datagramSocket != null) {
            return datagramSocket;
        }
        return createSocket();
    }

    private class SendThread extends Thread {
        private LinkedBlockingQueue<UdpMsg> msgQueue;
        private UdpMsg sendingMsg;

        protected LinkedBlockingQueue<UdpMsg> getMsgQueue() {
            if (msgQueue == null) {
                msgQueue = new LinkedBlockingQueue<UdpMsg>();
            }
            return msgQueue;
        }

        protected SendThread setSendingMsg(UdpMsg sendingMsg) {
            this.sendingMsg = sendingMsg;
            return this;
        }

        public UdpMsg getSendingMsg() {
            return this.sendingMsg;
        }

        public boolean enqueueUdpMsg(final UdpMsg tcpMsg) {
            if (tcpMsg == null || getSendingMsg() == tcpMsg
                    || getMsgQueue().contains(tcpMsg)) {
                return false;
            }
            try {
                getMsgQueue().put(tcpMsg);
                return true;
            } catch (InterruptedException e) {
//                e.printStackTrace();
            }
            return false;
        }

        public boolean cancel(UdpMsg packet) {
            return getMsgQueue().remove(packet);
        }

        public boolean cancel(int tcpMsgID) {
            return getMsgQueue().remove(new UdpMsg(tcpMsgID));
        }

        @Override
        public void run() {
            UdpMsg msg;
            if (getDatagramSocket() == null) {
                return;
            }
            try {
                while (!Thread.interrupted()
                        && (msg = getMsgQueue().take()) != null) {
                    setSendingMsg(msg);//设置正在发送的
                    Log.d(TAG, "udp send msg=" + msg);
                    byte[] data = msg.getSourceDataBytes();
                    if (data == null) {//根据编码转换消息
                        data = msg.getSourceDataString().getBytes(StandardCharsets.UTF_8);
                    }
                    if (data != null && data.length > 0) {
                        TargetInfo mTargetInfo = msg.getTarget();
                        DatagramPacket packet = new DatagramPacket(data, data.length,
                                new InetSocketAddress(mTargetInfo.getIp(), mTargetInfo.getPort()));
                        try {
                            msg.setTime();
                            getDatagramSocket().send(packet);
                            notifySendedListener(msg);
                        } catch (Exception e) {
                            e.printStackTrace();
                            notifyErrorListener("发送消息失败", e);
                        }
                    }
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private class ReceiveThread extends Thread {
        @Override
        public void run() {
            if (getDatagramSocket() == null) {
                return;
            }
            byte[] buff = new byte[1024];
            DatagramPacket pack = new DatagramPacket(buff, buff.length);
            notifyStartListener();
            while (!Thread.interrupted()) {
                try {
                    getDatagramSocket().receive(pack);
                    byte[] res = Arrays.copyOf(buff, pack.getLength());
                    Log.d(TAG, "udp receive byte=" + Arrays.toString(res));
                    UdpMsg udpMsg = new UdpMsg(res, new TargetInfo(pack.getAddress().getHostAddress(), pack.getPort()),
                            UdpMsg.MsgType.Receive);
                    udpMsg.setTime();
                    String msgstr = new String(res);
                    udpMsg.setSourceDataString(msgstr);
                    Log.d(TAG, "udp receive msg=" + udpMsg);
                    notifyReceiveListener(udpMsg);
                } catch (IOException e) {
                    if (!(e instanceof SocketTimeoutException)) {//不是超时报错
                        notifyErrorListener(e.getMessage(), e);
                        notifyStopListener();
                    }
                }
            }
        }
    }

    public void config(UdpClientConfig udpClientConfig) {
        mUdpClientConfig = udpClientConfig;
    }

    public void addUdpClientListener(UdpClientListener listener) {
        if (mUdpClientListeners.contains(listener)) {
            return;
        }
        this.mUdpClientListeners.add(listener);
    }

    public void removeUdpClientListener(UdpClientListener listener) {
        this.mUdpClientListeners.remove(listener);
    }

    private void notifyReceiveListener(final UdpMsg msg) {
        for (UdpClientListener l : mUdpClientListeners) {
            final UdpClientListener listener = l;
            if (listener != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        listener.onReceive(XUdp.this, msg);
                    }
                });
            }
        }
    }

    private void notifyStartListener() {
        for (UdpClientListener l : mUdpClientListeners) {
            final UdpClientListener listener = l;
            if (listener != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        listener.onStarted(XUdp.this);
                    }
                });
            }
        }
    }

    private void notifyStopListener() {
        for (UdpClientListener l : mUdpClientListeners) {
            final UdpClientListener listener = l;
            if (listener != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        listener.onStoped(XUdp.this);
                    }
                });
            }
        }
    }

    private void notifySendedListener(final UdpMsg msg) {
        for (UdpClientListener l : mUdpClientListeners) {
            final UdpClientListener listener = l;
            if (listener != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        listener.onSended(XUdp.this, msg);
                    }
                });
            }
        }
    }

    private void notifyErrorListener(final String msg, final Exception e) {
        for (UdpClientListener l : mUdpClientListeners) {
            final UdpClientListener listener = l;
            if (listener != null) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        listener.onError(XUdp.this, msg, e);
                    }
                });
            }
        }
    }

    @Override
    public String toString() {
        return "XUdp{" +
                "datagramSocket=" + datagramSocket +
                '}';
    }

    protected void runOnUiThread(Runnable runnable) {
        mUIHandler.post(runnable);
    }
}
