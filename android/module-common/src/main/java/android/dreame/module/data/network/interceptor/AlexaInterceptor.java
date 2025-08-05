package android.dreame.module.data.network.interceptor;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.HttpUrl;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

public class AlexaInterceptor implements Interceptor {

    private static final String TAG = AlexaInterceptor.class.getSimpleName();

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();
        HttpUrl oldHttpUrl = request.url();
        String oldUrl = oldHttpUrl.toString();
        if ((!oldUrl.contains("-uat") && !oldUrl.contains("-dev") && !oldUrl.contains("-test"))
                && (oldUrl.contains("dreame-smarthome/alexaApp2App/getUrl")
                || oldUrl.contains("dreame-smarthome/alexaApp2App/skillAccountLink")
                || oldUrl.contains("dreame-smarthome/alexaApp2App/skillAuthorizeCode")
                || oldUrl.contains("dreame-smarthome/alexaApp2App/disableSkillAccountLink"))) {
            HttpUrl newBaseUrl = HttpUrl.parse("https://eu.iot.mova-tech.com:13267");
            HttpUrl newFullUrl = oldHttpUrl.newBuilder()
                    .scheme(newBaseUrl.scheme())
                    .host(newBaseUrl.host())
                    .port(newBaseUrl.port())
                    .build();
            Request.Builder builder = request.newBuilder();
            return chain
                    .withConnectTimeout(20, TimeUnit.SECONDS)
                    .withReadTimeout(20,TimeUnit.SECONDS)
                    .withWriteTimeout(20,TimeUnit.SECONDS)
                    .proceed(builder.url(newFullUrl).build());
        } else {
            return chain.proceed(request);
        }
    }


}
