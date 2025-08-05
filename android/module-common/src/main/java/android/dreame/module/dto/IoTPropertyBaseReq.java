package android.dreame.module.dto;

public class IoTPropertyBaseReq<T> extends BaseDTO {


    /**
     * id : 123
     * method : action
     * params : {"did":"1234","siid":2,"aiid":1}
     */

    private int id;
    private String method;
    protected T params;
    private String did;

    private String from = "android";

    public String getDid() {
        return did;
    }

    public void setDid(String did) {
        this.did = did;
    }

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

    public T getParams() {
        return params;
    }

    public void setParams(T params) {
        this.params = params;
    }

}
