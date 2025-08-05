package android.dreame.module.dto;

public class UpdateUserInfoDTO extends BaseDTO {
    private String name;
    private String country;
    private String lang;

    public UpdateUserInfoDTO(String name, String country, String lang) {
        this.name = name;
        this.country = country;
        this.lang = lang;
    }

    public UpdateUserInfoDTO(String name) {
        this.name = name;
    }

    public UpdateUserInfoDTO(String country, String lang) {
        this.country = country;
        this.lang = lang;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }
}
