package android.dreame.module.dto;

public class IoTPropertyReq extends IoTPropertyBaseReq<Object> {



    public static class PropertyDTO {
        /**
         * did : 1234
         * siid : 2
         * piid : 1
         */

        private String did;
        private int siid;
        private Integer piid;
        private Integer aiid;

        private Integer value;

        public Integer getAiid() {
            return aiid;
        }

        public void setAiid(Integer aiid) {
            this.aiid = aiid;
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

        public void setPiid(Integer piid) {
            this.piid = piid;
        }

        public Integer getValue() {
            return value;
        }

        public void setValue(Integer value) {
            this.value = value;
        }
    }

}
