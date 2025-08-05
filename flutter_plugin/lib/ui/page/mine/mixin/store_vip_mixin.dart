import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/ui/page/mall/mall/mall_page.dart';

mixin StoreVipMixin {
  // Uniapp页面
  // 权益
  final String VIP_PAGE_MEMBERSHIP = '/pagesA/memberShip/memberShip';

  // 会员中心
  final String VIP_PAGE_VIPCENTER = '/pages/vipCenter/vipCenter';

  // 签到
  final String VIP_PAGE_DALIYCHECKIN = '/pagesA/daliyCheckIn/daliyCheckIn';

  // 优惠券
  final String VIP_PAGE_COUPON = '/pagesA/coupon/coupon';

  // 觅享分
  final String VIP_PAGE_DREAMEPOINT = '/pagesA/dreamePoint/dreamePoint';

  // 积分
  final String VIP_PAGE_POINT = '/pagesA/point/point';

  // 订单
  final String VIP_PAGE_ORDER = '/pagesA/order/order';

  // 售后
  final String VIP_PAGE_REFUND = '/pagesA/refund/refund';

  // 收货地址
  final String VIP_PAGE_ADDRESS = '/pagesA/address/address-list';

  // 产品注册
  final String VIP_PAGE_PRODUCT_REGISTER = '/pages/serve/serve';

  // 签到
  final String VIP_PAGE_CHECK_IN = 'pagesA/daliyCheckIn/daliyCheckIn';

  // 会员权益
  final String VIP_PAGE_MEMBER_SHIP = 'pagesA/memberShip/memberShip';

  // 觅码
  final String VIP_PAGE_GIFT_CARD = 'pagesB/giftCard/index';

  // 生日
  final String VIP_PAGE_BIRTHDAY = 'pagesA/birthday/birthday';

  // 商品评价
  final String VIP_PAGE_GOODS_EVALUATE = 'pagesB/evaluate/myEvaluate';

  final String VIP_PAGE_GOODS_DETAIL =
      'pagesA/goodsDetail/goodsDetail'; //pagesA/goodsDetail/goodsDetail?gid=40

  // 打开签到
  void pushToCheckIn() {
    pushToMallWeb(VIP_PAGE_CHECK_IN);
  }

  // 打开会员中心
  void pushToGrowthCenter() {
    pushToMallWeb(VIP_PAGE_VIPCENTER);
  }

  // 打开会员权益
  void pushToMoreVIPBenefit() {
    pushToMallWeb(VIP_PAGE_MEMBER_SHIP);
  }

  // 打开注册有礼
  void pushToRegisterGift() {
    pushToProductRegister();
  }

  // 产品注册
  void pushToProductRegister() {
    pushToMallWeb(VIP_PAGE_PRODUCT_REGISTER);
  }

  // 打开积分兑换
  void pushToPointExchange() {
    pushToMallWeb(VIP_PAGE_POINT);
  }

  // 打开优惠券
  void pushToCoupon() {
    pushToMallWeb(VIP_PAGE_COUPON);
  }

  // 打开觅码
  void pushToMiCode() {
    pushToMallWeb(VIP_PAGE_GIFT_CARD);
  }

  // 打开生日
  void pushToBirthday() {
    pushToMallWeb(VIP_PAGE_BIRTHDAY);
  }

  //跳转到我的订单
  void pushToOrder() {
    pushToMallWeb(VIP_PAGE_ORDER);
  }

  //跳转到售后
  void pushToAfterSales() {
    pushToMallWeb(VIP_PAGE_REFUND);
  }

  //跳转到收货地址
  void pushToReceiveAddress() {
    pushToMallWeb(VIP_PAGE_ADDRESS);
  }

  // 跳转到评价
  void pushToCNComments() {
    pushToMallWeb(VIP_PAGE_GOODS_EVALUATE);
  }

  Future<void> pushToMallWeb(String path) async {
    await AppRoutes().push(MallPage.routePath, extra: path);
  }
}
