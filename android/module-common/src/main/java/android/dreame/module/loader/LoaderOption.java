package android.dreame.module.loader;
/**
 * 作者：maqing-PC on 2020/1/4 11:45
 * <p>
 * 邮箱：2856992713@qq.com
 */
public class LoaderOption {
    /**
     * 显示为圆形
     */
    public boolean mShowCircle;
    /**
     * 占位图片
     */
    public int mPlaceHolder;

    /**
     * 失败占位图
     */
    public int mErrorHolder;

    public LoaderOption setShowCircle(boolean showCircle) {
        mShowCircle = showCircle;
        return this;
    }

    public LoaderOption setPlaceHolder(int placeHolder) {
        mPlaceHolder = placeHolder;
        return this;
    }

    public LoaderOption setErrorHolder(int mErrorHolder) {
        this.mErrorHolder = mErrorHolder;
        return this;
    }
}
