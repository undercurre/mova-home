import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';


mixin IotPairNetInfoStepMixin on BasePageState {
  @override
  void initState() {
    IotPairNetworkInfo().increaseStep();
    super.initState();
  }

  @override
  void dispose() {
    IotPairNetworkInfo().decreaseStep();
    super.dispose();
  }
}
