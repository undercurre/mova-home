package android.dreame.module.data.entry

data class CommonPageResult<T>(
    val empty:Boolean,
    val first:Boolean,
    val last:Boolean,
    val number:Int,
    val numberOfElements:Int,
    val pageable:Pageable,
    val size:Int,
    val sort:Sort,
    val totalElements:Int,
    val totalPages:Int,
    val content:List<T>
)
data class Pageable(
    val offset: Int,
    val pageNumber: Int,
    val pageSize: Int,
    val paged: Boolean,
    val sort: Sort,
    val unpaged: Boolean
)

data class Sort(
    val empty: Boolean,
    val sorted: Boolean,
    val unsorted: Boolean
)