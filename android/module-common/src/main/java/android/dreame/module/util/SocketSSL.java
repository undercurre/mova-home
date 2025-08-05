package android.dreame.module.util;

import android.dreame.module.LocalApplication;
import android.dreame.module.R;

import java.io.InputStream;
import java.security.KeyStore;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManagerFactory;

public class SocketSSL {
    public static SSLSocketFactory getDevSocketFactory() throws Exception {
        InputStream ca = LocalApplication.getInstance().getResources().openRawResource(R.raw.ca);
        InputStream cert = LocalApplication.getInstance().getResources().openRawResource(R.raw.client);
        return getSocketFactory(cert, ca, "");
    }

    public static SSLSocketFactory getUatSocketFactory() throws Exception {
        InputStream ca = LocalApplication.getInstance().getResources().openRawResource(R.raw.uat_cacert);
        InputStream cert = LocalApplication.getInstance().getResources().openRawResource(R.raw.uat_client);
        return getUatSocketFactory(ca, cert, "1234");
    }

    public static SSLSocketFactory getCustomSocketFactory() throws Exception {
        InputStream ca = LocalApplication.getInstance().getResources().openRawResource(R.raw.dev_cacert);
        InputStream cert = LocalApplication.getInstance().getResources().openRawResource(R.raw.dev_client);
        return getUatSocketFactory(ca, cert, "Rquy4UA7YwxczvmW");
    }

    public static SSLSocketFactory getSocketFactory() throws Exception {
//        switch (RequestManager.getType()) {
//            case RequestManager.DEV:
//                return getDevSocketFactory();
//            case RequestManager.UAT:
//                return getUatSocketFactory();
//        }
        return getCustomSocketFactory();
    }

    public static SSLSocketFactory getSocketFactory(InputStream keyStore, InputStream trustStore, String password) throws Exception {
        KeyStore km = KeyStore.getInstance("BKS");
        km.load(keyStore, password.toCharArray());
        KeyManagerFactory kmf = KeyManagerFactory.getInstance("X509");
        kmf.init(km, password.toCharArray());
        KeyStore ts = KeyStore.getInstance("BKS");
        ts.load(trustStore, password.toCharArray());
        TrustManagerFactory tmf = TrustManagerFactory.getInstance("X509");
        tmf.init(ts);
        SSLContext ctx = SSLContext.getInstance("SSL");
        ctx.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);
        return ctx.getSocketFactory();
    }

    public static SSLSocketFactory getUatSocketFactory(InputStream ca, InputStream client, String password) throws Exception {
        //客户端证书
        KeyStore km = KeyStore.getInstance("PKCS12");
        km.load(client, password.toCharArray());
        KeyManagerFactory kmf = KeyManagerFactory.getInstance("X509");
        kmf.init(km, password.toCharArray());

        //信任服务端自签名证书
        CertificateFactory certificateFactory = CertificateFactory.getInstance("X.509");
        X509Certificate cert = (X509Certificate) certificateFactory.generateCertificate(ca);
        String alias = cert.getSubjectX500Principal().getName();
        KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
        trustStore.load(null);
        trustStore.setCertificateEntry(alias, cert);
        TrustManagerFactory tmf = TrustManagerFactory.getInstance("X509");
        tmf.init(trustStore);

        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);
        return sslContext.getSocketFactory();
    }
}
