package android.dreame.module.provider;

import android.database.MatrixCursor;
import android.os.Bundle;

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/06/07
 *     desc   :
 *     version: 1.0
 * </pre>
 */
public class BundleCursor extends MatrixCursor {
    private Bundle mBundle;

    public BundleCursor(Bundle extras) {
        super(new String[]{}, 0);
        mBundle = extras;
    }

    @Override
    public Bundle getExtras() {
        return mBundle;
    }

    @Override
    public Bundle respond(Bundle extras) {
        mBundle = extras;
        return mBundle;
    }
}
