class ResourceModel {
  String themePath = 'light';
  ResourceModel({this.themePath = 'light'});

  /// 读取资源图片
  /// @param name resName
  /// @param suffix .png
  String getResource(String name, {String suffix = '.png', bool x2 = false}) {
    return 'assets/$themePath/icons/${x2 ? 2 : 3}.0x/$name$suffix';
  }
}
