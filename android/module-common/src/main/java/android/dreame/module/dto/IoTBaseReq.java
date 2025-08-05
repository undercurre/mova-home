package android.dreame.module.dto;

import android.dreame.module.util.RequestParamsUtil;

import com.google.gson.Gson;

import okhttp3.MediaType;
import okhttp3.RequestBody;

public class IoTBaseReq<T> {


    public RequestBody getBody() {
        return RequestBody.create(MediaType.parse("application/json"),new Gson().toJson(this));
    }

    /**
     * id : 123
     * method : action
     * params : {"did":"1234","siid":2,"aiid":1}
     */

    private int id;
    private T data;
    private String did;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getDid() {
        return did;
    }

    public void setDid(String did) {
        this.did = did;
    }
}
