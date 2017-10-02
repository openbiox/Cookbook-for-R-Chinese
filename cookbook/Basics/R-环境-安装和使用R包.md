---
title: "安装和使用R包"
date: 2017-09-01
status: publish
output: html_notebook
categories: 
- R
- R-Cookbook
tags:
- R
- Packages
---
 
 
# 问题
 
你想要安装和使用一个R包。
 
<!-- more -->
 
# 方案
 
如果你正在使用支持R的图形界面软件，应该存在通过菜单栏方式安装R包的选项（比如，常用的Rstudio中，可以点击菜单栏Tools中的Install Packages进行R包的安装）。
 
这里主要介绍如何用命令行来安装R包。
 
```
install.packages("reshape2") # reshap2为包名
```
 
在一个新R线程中使用该包之前，你必须先导入它。
 
```
library(reshape2)
```
如果你在一个脚本中使用该包，把这一行输入脚本中。
 
如果想要更新包，使用
```
update.packages()
```
 
如果你在Linux系统上使用R，管理员可能已经在系统上安装了一些R包，你将不能以上述方式对R包更新（因为你没有权限）。
 
********
 
原文链接：<http://www.cookbook-r.com/Basics/Installing_and_using_packages/>
 
# 其他
 
***
导入包也可以使用`require()`函数。



常见的包安装命令

| 命令                 | 描述                           |      |
| ------------------ | ---------------------------- | ---- |
| installed.packages | 返回一个矩阵，包含所有已安装的包信息           |      |
| available.packages | 返回一个矩阵，包含资源库上所有可用的R包         |      |
| old.packages       | 返回一个矩阵，显示所有已安装的包中具有新版本的包     |      |
| new.packages       | 返回一个矩阵，显示所有可从资源库上获得而当前尚未安装的包 |      |
| download.packages  | 下载一系列R包到本地目录                 |      |
| install.packages   | 从资源库下载安装一系列R包                |      |
| remove.packages    | 移除一系列已安装的R包                  |      |
| update.packages    | 将已经安装的R包更新到最新版本              |      |
| setRepositories    | 设定当前的R包的资源库列表                |      |



**通过命令行安装R包**

```shell
R CMD INSTALL aplpack_1.1.1.tgz # 安装aplpack包
```



**从其他资源库安装R包**

`devtools`库提供了从其他流行的`Git`资源库或其他URL上安装R包的工具。

比如我们想安装开发版本的`ggplot2`包，可以使用下面命令：

```R
# 如果没有安装devtools，需要先安装
install.packages("devtools")

library(devtools)
install_github("ggplot2")
```

更多信息查看相应的帮助文档。
 
by 诗翔
 
