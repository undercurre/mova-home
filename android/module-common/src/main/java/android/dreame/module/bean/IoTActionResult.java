package android.dreame.module.bean;

import java.util.List;

public class IoTActionResult {


    /**
     * result : {"code":0,"siid":3,"aiid":1,"did":"364863084","out":[]}
     * id : 16932
     */

    private ResultDTO result;
    private int id;
    private int code;

    public ResultDTO getResult() {
        return result;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public void setResult(ResultDTO result) {
        this.result = result;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public static class ResultDTO {
        /**
         * code : 0
         * siid : 3
         * aiid : 1
         * did : 364863084
         * out : []
         */

        private int code;
        private int siid;
        private int aiid;
        private String did;
        private List<OutDTO> out;

        public int getCode() {
            return code;
        }

        public void setCode(int code) {
            this.code = code;
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

        public String getDid() {
            return did;
        }

        public void setDid(String did) {
            this.did = did;
        }

        public List<OutDTO> getOut() {
            return out;
        }

        public void setOut(List<OutDTO> out) {
            this.out = out;
        }

        public static class OutDTO {
            private int piid;
            private String value;

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
