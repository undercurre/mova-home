import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';

class ActionAccountBind extends CommonEventAction {}

class ActionSocialAccountBind extends CommonEventAction {
  String? source;
  String? uuid;
  SocialCodeModel? model;

  ActionSocialAccountBind({this.source, this.uuid});
}

class ActionSocialAccountBindT extends CommonEventAction {
  String? source;
  dynamic token;

  ActionSocialAccountBindT({this.source, this.token});
}

class ActionSocialAccountBindRepeat extends CommonEventAction {
  String? source;
  dynamic token;

  ActionSocialAccountBindRepeat({this.source, this.token});
}

class ShowSignUpDialog extends CommonEventAction {}

class ShowEmailCollectionSubscribe extends CommonEventAction {}
