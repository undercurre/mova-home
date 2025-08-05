package android.dreame.module.dto;

import java.io.Serializable;
import java.util.List;

public class IoTActionReq extends BaseDTO {


    /**
     * id : 123
     * method : action
     * params : {"did":"1234","siid":2,"aiid":1}
     */

    private int id;
    private String method;
    private ParamsDTO params;

    private String from = "android";

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

    public ParamsDTO getParams() {
        return params;
    }

    public void setParams(ParamsDTO params) {
        this.params = params;
    }

    public static class ParamsDTO {
        /**
         * did : 1234
         * siid : 2
         * aiid : 1
         */

        private String did;
        private int siid;
        private int aiid;
        private List<InDTO> in;

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

        public int getAiid() {
            return aiid;
        }

        public void setAiid(int aiid) {
            this.aiid = aiid;
        }

        public List<InDTO> getIn() {
            return in;
        }

        public void setIn(List<InDTO> in) {
            this.in = in;
        }

        public static class InDTO {
            private int piid;
            private Serializable value;

            public int getPiid() {
                return piid;
            }

            public void setPiid(int piid) {
                this.piid = piid;
            }

            public Serializable getValue() {
                return value;
            }

            public void setValue(Serializable value) {
                this.value = value;
            }
        }
    }
}
