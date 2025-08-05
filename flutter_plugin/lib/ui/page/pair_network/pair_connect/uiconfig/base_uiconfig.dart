enum UiConfigEnum {
  UI_CONFIG_STEP_CONNECT,
  UI_CONFIG_STEP_MANUAL,

  // 单蓝牙配网
  UI_CONFIG_STEP_BLE_ONLY,
  ;
}

class UIStep {
  static const int STEP_1_UI = 1;
  static const int STEP_2_UI = 2;
  static const int STEP_3_UI = 3;
  static const int STEP_QR_PAIR_UI = 4;

  static const int STEP_MANUAL_UI = 100;

  static const int STEP_STATUS_NONE = -1;
  static const int STEP_STATUS_LOADING = 0;
  static const int STEP_STATUS_SUCCESS = 1;
  static const int STEP_STATUS_FAIL = 2;
}
