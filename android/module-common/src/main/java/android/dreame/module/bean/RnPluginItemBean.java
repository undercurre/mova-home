package android.dreame.module.bean;

import java.util.Objects;

public class RnPluginItemBean {
    private String packageName;
    private String model;
    private String customId;
    private boolean checked;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RnPluginItemBean that = (RnPluginItemBean) o;
        return Objects.equals(packageName, that.packageName) && Objects.equals(model, that.model);
    }

    @Override
    public int hashCode() {
        return Objects.hash(packageName, model);
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getCustomId() {
        return customId;
    }

    public void setCustomId(String customId) {
        this.customId = customId;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }
}
