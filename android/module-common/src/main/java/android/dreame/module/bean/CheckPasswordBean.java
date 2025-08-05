package android.dreame.module.bean;

public class CheckPasswordBean {

    private int expireIn;
    private int interval;
    private boolean matches;
    private int maximum;
    private int remains;
    private int resetIn;

    public int getExpireIn() {
        return expireIn;
    }

    public void setExpireIn(int expireIn) {
        this.expireIn = expireIn;
    }

    public int getInterval() {
        return interval;
    }

    public void setInterval(int interval) {
        this.interval = interval;
    }

    public boolean isMatches() {
        return matches;
    }

    public void setMatches(boolean matches) {
        this.matches = matches;
    }

    public int getMaximum() {
        return maximum;
    }

    public void setMaximum(int maximum) {
        this.maximum = maximum;
    }

    public int getRemains() {
        return remains;
    }

    public void setRemains(int remains) {
        this.remains = remains;
    }

    public int getResetIn() {
        return resetIn;
    }

    public void setResetIn(int resetIn) {
        this.resetIn = resetIn;
    }
}
