import 'package:flutter_plugin/ui/page/main/tab_item.dart';
class AccountInfoEvent {}
class SelectTabEvent {
  final TabItemType tabItemType;
  SelectTabEvent({required this.tabItemType});
}
