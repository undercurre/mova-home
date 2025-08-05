package android.dreame.module.util.mqtt;

import androidx.annotation.Keep;

import com.google.gson.JsonElement;

import java.util.List;

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc:
 * @Date: 2021/5/11 10:10
 * @Version: 1.0
 */
@Keep
public class MqttMessageBean {

    private int id;
    private String did;
    private DataDTO data;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDid() {
        return did;
    }

    public void setDid(String did) {
        this.did = did;
    }

    public DataDTO getData() {
        return data;
    }

    public void setData(DataDTO data) {
        this.data = data;
    }
    @Keep
    public static class DataDTO {
        private int id;
        private String method;
        private JsonElement params;

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getMethod() {
            return method;
        }

        public void setMethod(String method) {
            this.method = method;
        }

        public JsonElement getParams() {
            return params;
        }

        public void setParams(JsonElement params) {
            this.params = params;
        }

        @Keep
        public static class ParamsDTO {
            private String did;
            private int siid;
            private int piid;
            private String value;
            // 返回值
            private Integer code;

            public Integer getCode() {
                return code;
            }

            public void setCode(Integer code) {
                this.code = code;
            }

            public String getDid() {
                return did;
            }

            public void setDid(String did) {
                this.did = did;
            }

            public int getSiid() {
                return siid;
            }

            public void setSiid(int siid) {
                this.siid = siid;
            }

            public int getPiid() {
                return piid;
            }

            public void setPiid(int piid) {
                this.piid = piid;
            }

            public String getValue() {
                return value;
            }

            public void setValue(String value) {
                this.value = value;
            }
        }
    }
}
