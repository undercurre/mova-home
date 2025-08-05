package android.dreame.module.data.entry


data class SettingPassword(val newPassword: String, val confirmedPassword: String)


data class ModifyPassword(val password: String, val newPassword: String, val confirmedPassword: String)
