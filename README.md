# MOVAhome 项目概述

## React-Native模块

### 版本: 0.61.5(无需安装)
一般注意npm仓库下载依赖库版本是特别注意;

### RN源码

##### RN源码地址：[http://git.dreame.com/terminal-library/react-native/tree/0.61.0-stable]

##### 参考编译文档【https://github.com/facebook/react-native/wiki/Building-from-source】

## Flutter模块
### 版本:3.19.6

## 原生模块

# 环境搭建
参考文档: [环境搭建](https://dreametech.feishu.cn/docx/XMPldQxROouyf9xql2GcHoPknOb)

## Android

### JDK-17

### Flutter 3.19.6

### Node: 3.21.3

## iOS

### [文档](https://dreametech.feishu.cn/docx/XMPldQxROouyf9xql2GcHoPknOb)

# 项目编译

### Android
- 先clone react-native外层依赖库 [https://git.dreame.tech/smarthome_app/mova-group/mova-home.git]
- 进入clone下来的代码库，执行 git submodule init,git submodule update
- 执行npm install,下载node_module 依赖库
- 执行 npm install --save-dev jetifier 和 npx jetify将node_module下的第三方依赖改为Androidx
- Android studio打开android目录
### iOS
- 先clone react-native外层依赖库 [https://git.dreame.tech/smarthome_app/mova-group/mova-home.git]
- 进入clone下来的代码库，执行 git submodule init,git submodule update
- 执行npm install,下载node_module 依赖库