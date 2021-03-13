# Wolfram PacletServer Mirror General
由于中国国内与 Wolfram 官方的 PacletServer（包服务器） 的连接速度很慢，所以此镜像被建立来改善这一情况。

## 介绍

### 什么是 Paclet 程序包？

Paclet 官方译为“小数据包”，详见 https://reference.wolfram.com/language/guide/Paclets.html 。从 Mathematica 12.1 版本开始，软件自带帮助文档中也可以找到 Paclet 的相关说明了。

### 镜像有什么用？

* 软件在启动时会自动更新程序包，且不可中断。如果更新的时间很久，会妨碍用户的正常使用（用户也可能会觉得软件卡死了）。
* 软件的一些内置功能在安装时是不完整的，完整的部分要在线获取。比如首次使用 `TextRecogize` 函数会自动下载 TrainedData 数据包，配置好此镜像站就可以正常使用 `TextRecogize` 。
* 软件的一些 BUG 是软件发布后才发现的，而官方给出的修复补丁则正是作为程序包来安装的，如果无法正常连接包服务器，BUG 就不能被自动修复。我所知的例子有 PresenterTools 和 TeXImportFix 这两个包。

### 镜像是如何实现的？

你可以利用本项目获取 **所有** `Paclet` 程序包。

本项目已将绝大部分包的最新版本和一部分包的常见版本存储于码云仓库，并且利用 CloudFlare Workers 的免费版服务对官方包服务器进行了代理。不过代理的每日请求次数等指标是有限的，速度也不如码云，请勿滥用。

不过，在版本 12.0 之后，越来越多的大型数据包不再以 `Paclet` 发布，而是以 `CloudObject` 来发布。本镜像只镜像 Paclet ，所以对后者无能为力。

![Wolfram Mathematica 12.1 效果展示](https://gitee.com/wolframpaclet/WolframPacletGeneral/raw/master/example.png)
![Wolfram Engine 12.0 效果展示](https://gitee.com/wolframpaclet/WolframPacletGeneral/raw/master/example-cmdln.png)

## 使用本镜像站
启用主站后，执行
```
PacletInstall["PacletMirrorClient", "Site" -> "https://github.com/rnotlnglgq/WolframPacletMirror/raw/master"]
```
安装，并执行
```
UpdateMirrorSites[]
```
更新站点信息（你并不需要每次都进行更新）。

PacletMirrorClient程序包用于合并从码云仓库下载的文件，它至少是支持11+和12+版本的 Wolfram 内核版本的。

## 常见问题
### 为什么Update from Wolfram Server时还是很慢？
这通常说明包仍是从官方服务器读取的。要查看目前的包服务器列表，执行
```
PacletSites[]
```

PacletInstall会从PacletFindRemote所得列表的首个包信息所指定的位置下载包。要想了解PacletInstall默认会从哪里下载某个包，执行
```
PacletFindRemote["Benchmarking"][[1]]["Location"]
```
即可。

`PacletFindRemote` 对包信息的排序原则是：如果没有指定包的版本， `PacletFindRemote` 总是将版本较新的包排在前面。
在版本等特征都相同的包信息中，在 `PacletSites[]` 列表中排名靠后的包服务器中的包信息将被排在前面。

### 如何得知首次使用某个函数所需的包的名字？

可以先尝试使用函数，在进入下载状态之后在```FileNameJoin@{$UserBaseDirectory,"Paclets","Temporary"}```文件夹中寻找最近修改过的paclet文件。

### 如果我想自己建立镜像站，或者只是挂机下载所有自己想要的包怎么办？

可以利用 `PacletSiteManager` 中的工具。配置主镜像站后执行
```
PacletInstall["PacletSiteManager", "Site" -> "https://github.com/rnotlnglgq/WolframPacletSiteManager/raw/master"]
```
安装管理工具，然后开始阅读此管理工具包的帮助文档和源代码。

### 为什么从镜像站下载失败？

除了网络不好等平凡的原因，另一类可能性是镜像当前正在维护或更新。

由于码云仓库大小限制，每次都要清空仓库后再上传新的包，以我使用的网络速度（128KB/s），大概每个仓库需要一个半小时更新。这时你可以尝试使用本项目提供的包服务器代理站。

此外，客户端的BUG也可能导致这一结果。所以遇到问题请提 issue ，以免问题存在太久。

## 其他
### 相关资源链接

* [【资源下载】Wolfram Neural Net Repository（神经网络模型库）](https://mmaqa.com/blog/426/2018/08/16/%e3%80%90%e8%b5%84%e6%ba%90%e3%80%91wolfram-neural-net-repository%ef%bc%88%e7%a5%9e%e7%bb%8f%e7%bd%91%e7%bb%9c%e6%a8%a1%e5%9e%8b%e5%ba%93%ef%bc%89/)
* [Wolfram Language 程序包站](https://packagedata.net)
* [GitHub 第三方包服务器](https://b3m2a1.github.io/PacletServer/)

### 关于此项目

此项目使用 Github Action 自动触发更新，每当有提交推送到本仓库的 update 分支， Github Action 会自动更新包到码云仓库。

一般来说，仓库会保有包的两个版本：最新版本和兼容12.0.0.0版本内核的最高版本。如果有一些包的非最新的特殊版本有特殊作用或者最新版本的兼容性不好，你可以在Issue中报告该需求。

此项目还有很多可以/需要改进的地方，不过随着国内市场的发展，Wolfram Research 官方可能会在国内设服务器，届时此项目就没有存在的必要了。

### 联系我们

可以使用Issue功能。

### 许可

如果你没有可以让你访问 Wolfram知识库 的许可证，请不要使用此系列仓库。

如果 Wolfram Research 认为这一做法不合适，可以联系我们来删除这些仓库。

### 贡献者
* asdasd1dsadsa
* ryaliu
* rnotlnglgq
