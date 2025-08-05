package android.dreame.module.data.entry.help


data class SuggestionTagRes(
    val tagId: String,
    val tagName: String,
    var checked: Boolean = false,
)

data class HistoryCountRes(
    val oldNum: Int?,
)