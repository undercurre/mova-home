package android.dreame.module.data.entry.help


data class ProductFaqRes(
    val bodyItems: List<BodyItem>,
    val cat: Boolean,
    val createdAt: String,
    val id: String,
    val locale: String,
    val priority: Int,
    val productId: String,
    val title: String,
    val updatedAt: String
)

data class BodyItem(
    val content: String,
    val type: String
)