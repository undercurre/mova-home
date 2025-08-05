package android.dreame.module.bean;

import java.io.Serializable;

public class OAuthBeanDetail implements Serializable {
    private String maximum;
    private String remains;

    public String getMaximum() {
        return maximum;
    }

    public void setMaximum(String maximum) {
        this.maximum = maximum;
    }

    public String getRemains() {
        return remains;
    }

    public void setRemains(String remains) {
        this.remains = remains;
    }
}
