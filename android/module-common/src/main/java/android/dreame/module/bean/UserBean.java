package android.dreame.module.bean;

/**
 * Created by maqing on 2020/11/10.
 * Email:2856992713@qq.com
 */
public class UserBean {
    private String mId;
    private String mName;
    private String mTokenType = "";
    private String mToken = "";
    private String mRefreshToken = "";

    public String getId() {
        return mId;
    }

    public void setId(String id) {
        mId = id;
    }

    public String getName() {
        return mName;
    }

    public void setName(String name) {
        mName = name;
    }

    public String getTokenType() {
        return mTokenType;
    }

    public void setTokenType(String tokenType) {
        mTokenType = tokenType;
    }

    public String getToken() {
        return mToken;
    }

    public void setToken(String token) {
        mToken = token;
    }

    public String getRefreshToken() {
        return mRefreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        mRefreshToken = refreshToken;
    }

    @Override
    public String toString() {
        return "UserBean{" +
                "mId='" + mId + '\'' +
                ", mName='" + mName + '\'' +
                '}';
    }
}
