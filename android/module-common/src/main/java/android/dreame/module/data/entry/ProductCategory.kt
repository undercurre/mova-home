package android.dreame.module.data.entry

data class ProductCategoryRes(
    val categoryOrder: Int?,
    val categoryId: String?,
    // 扫地机，洗地机等名字
    val name: String?,
    val childrenList: List<ChildrenListBean>?,

    )

data class ChildrenListBean(
    val categoryOrder: Int?,
    // 扫地机/洗地机系列的名字 X系列，Z 系列
    val name: String?,
    val categoryId: String?,
    val productList: List<ProductListBean>?
)

data class ProductListBean(
    val displayName: String?,
    val feature: String?,
    val model: String?,
    val productId: String?,
    val productOrder: String?,
    // pid to model
    val quickConnects: Map<String, String>?,
    val scType: String?,
    val extendScType: List<String>?,
    val mainImage: Image?,
    val icon: Image?,
    val iamges: Image?,
    val overlook: Image?,
    val popup: Image?,
)

