package android.dreame.module.data.entry.message

data class MessageRecord(val records: List<MsgRecord>)

data class MessageRecordExt(val goods_name: String, val goods_num: String, val link_url: String)

data class MessageRecordDisplay(var lang: String, val content: String, val link: String, val name: String)


data class MsgRecordBean(
    val id: String,
    val msgCategory: String,
    val jumpType: String,
    val readStatus: Int,
    val readTime: String,
    val createTime: String,
    val updateTime: String,
    val ext: String,

    val display: MessageRecordDisplay,
    val extBean: MessageRecordExt?,

    )