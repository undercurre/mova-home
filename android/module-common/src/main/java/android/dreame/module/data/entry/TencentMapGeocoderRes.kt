package android.dreame.module.data.entry

data class TencentMapGeocoderRes(
    val status: Int?,
    val message: String?,
    val result: Result?
)

data class Result(
    val title: String?,
    val location: Location?,
    val address_component: AddressComponents?,
    val ad_info: AdInfo?,
    val address_reference: AddressReference?
)

data class Location(
    val lat: Double?,
    val lng: Double?
)

data class AddressComponents(
    val nation: String?,
    val province: String?,
    val city: String?,
    val district: String?,
    val locality: String?,
)

data class AdInfo(
    val adcode: String?,
    val nation_code: String?,
    val city_code: String?
)

data class AddressReference(
    val business_area: BusinessArea?,
    val famous_area: FamousArea?
)

data class BusinessArea(
    val title: String?,
    val location: Location?
)

data class FamousArea(
    val title: String?,
    val location: Location?
)
