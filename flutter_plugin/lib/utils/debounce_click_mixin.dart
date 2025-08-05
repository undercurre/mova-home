/// 放抖动mixin
mixin DebounceClickMixin {
  bool _clickable = true;
  int _milliseconds = 800;

  void setMilliseconds(int milliseconds) {
    _milliseconds = milliseconds;
  }

  /// 点击间隔时间
  bool canClick() {
    return _clickable;
  }

  /// 点击间隔时间
  void debounceClick() {
    _clickable = false;
    Future.delayed(Duration(milliseconds: _milliseconds), () {
      _clickable = true;
    });
  }
}
