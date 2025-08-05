# flutter_plugin

A new Flutter module project.

1. 项目整体框架使用`riverpod`，自动持续话管理页面状态，无需手动setState
文档地址: https://docs-v2.riverpod.dev/zh-Hans/docs/getting_started
框架会自动生成代码，在使用前运行`flutter pub run build_runner watch`
AndroidStudio、VSCode插件`Flutter Riverpod Snippets`
2. 数据类data class 使用`freezed`框架，定义后会自动生成代码
文档地址：https://pub.dev/packages/freezed
AndroidStudio插件`Flutter snippet for generator tool`，VSCode插件`freezed`
3. 网络框架使用`dio`，类Android OkHttp框架
文档地址：https://github.com/cfug/dio/blob/main/dio/README-ZH.md
App内部已做封装，添加 处理headers、log日志、token拦截器
4. 多语言框架使用`easy_localization`
文档地址 https://pub.dev/packages/easy_localization
多语文件目录为 assets/translations，支持定义`languageCode.json`与`languageCode-countryCode.json`文件,
使用`任意翻译key.tr()`即可，具体以文档为准
5. retrofit: 基于dio二次封装
文档地址 https://pub.dev/packages/retrofit
6. dartz: Either范型使用
文档地址: https://pub.dev/packages/dartz

# 命名规范 (2023-06-08)
1. 包名、文件名以下划线命名，如:home_page
2. 代码内、变量名、类名使用驼峰方式命名，如:class HomePage , string nickName
3. 私有方法、变量使用下划线开头如:string _nickName
4. 页面分为三个类:
   页面: _page结尾，如:home_page.dart
   逻辑处理provider: _state_notifier结尾,包含页面变动的state,数据,如:home_state_notifier
   数据源provider: _repository结尾,包含本地数据，远程数据，如：home_repository
5. 资源文件命名: 图片ic_开头