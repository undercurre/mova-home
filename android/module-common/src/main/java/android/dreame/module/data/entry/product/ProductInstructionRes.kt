package android.dreame.module.data.entry.product

import android.dreame.module.data.entry.Image

data class ProductInstructionRes(val instruction: ProductInstruction?)
data class ProductInstruction(
    val image: Image?,
    val intro: String?,
    val title: String?
)
