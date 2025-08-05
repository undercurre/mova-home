# 追觅自研APP

#### 一、React-Native源码

##### RN源码地址：[http://git.dreame.com/terminal-library/react-native/tree/0.61.0-stable]

##### 参考编译文档【https://github.com/facebook/react-native/wiki/Building-from-source】

#### 二、Xlog 密钥  加解密脚本：[https://github.com/Tencent/mars/tree/master/mars/log/crypt]

> 公钥：
>
80bdf2f61f247db6992dc16003ec4b79a1a21e2bf3220a2b6ee7ffd6dac591bac1dc94741b1087d742ddbe001f5caa2eefb5d6583ae6ef05d715b66a805aa62f
> 私钥：
> fcb14215781acda7fdd195de1ec30b3e8f0553cd72aaec96e20f68032fca9591

#### 三、代码说明

+ 先clone react-native外层依赖库 [https://git.dreame.tech/qiyi/dreame-smarthome.git]
+ 进入clone下来的代码库，执行 git submodule init,git submodule update
+ 执行npm install,下载node_module 依赖库
+ 执行 npm install --save-dev jetifier 和 npx jetify将node_module下的第三方依赖改为Androidx
+ Android studio打开android目录

### 四、打包脚本配置说明：

#### 版本名和版本号说明

##### 版本名：1.0.8.1 则版本号10008001

| 参数名                           | 说明                          | 配置                                                      |
| -------------------------------- | ----------------------------- |---------------------------------------------------------|
| 名称                             | 模板名称（固定）              | MOVA-Android-打包                                         |
| 通知机器人chat_id                | 通知群组（固定）              | oc_8ce648662e879123336a0e98ea0d5449                     |
| 备注                             | 打包上传时的说明信息          | MOVA-Android-打包调试                                       |
| Gitlab 参数（可配置多个）        | （固定）                      |                                                         |
| **url**   （flutter 仓库地址）   | **branch**  （flutter分支）   | **workspace**  （项目地址）                                   |
| **url**   （submodule 仓库地址） | **branch**  （submodule分支） | **workspace**  （submodule地址）                            |
| 环境变量                         |                               |                                                         |
| appVersionName                   | 版本名称                      | 1.0.8.10                                                |
| pluginAppVersion                 | RN SDK 版本                   | 150                                                     |
| appVersionCode                   | 版本号                        | 1000810                                                 |
| code_branch                      | jfrog 传的目录                | mova_develop/feature/release 不要传其他                      |
| mainspace                        | Flutter目录（固定）           | /Users/mova/cicd/app/android/Movahome                   |
| taskspace                        | Android目录（固定）           | /Users/mova/cicd/app/android/Movahome/mova-home/android |
| build_cmds                       | 打包命令                      | assembleCnRelease                                       |
| android_release_env              | p g y 渠道名称                | movahome-feature/movahome-rn/movahome-release等。 没有需联系添加 |
| tag_branch_flutter               | tag分支名                     | feature/x x x                                           |
| tag_branch_android               | tag分支名                     | feature/x x x                                           |
| tag_prefix                       | tag前缀                       | mova-feat-android                                       |
| 触发器名称                       | 通知群组（固定）              | test_mova_android                                       |

