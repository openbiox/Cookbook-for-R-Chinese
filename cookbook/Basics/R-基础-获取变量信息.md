---
title: "Basics-R中的变量"
date: 2017-09-02
status: publish
output: html_notebook
categories: 
- R
- R-Cookbook
tags:
- R
- variables
---

## 问题

你想找到关于变量的信息。

<!-- more -->

## 方案

以下为关于样本变量的一些例子

```
x <- 6
n <- 1:4
let <- LETTERS[1:4]
df <- data.frame(n, let)
 
```

### 关于存在

```
# 列出当前所定义的变量
ls()
#> [1] "df"       "filename" "let"      "n"        "old_dir"  "x"
 
# 检查名为“x”的变量是否存在
exists("x")
#> [1] TRUE
 
# 检查名为“y”的变量是否存在
exists("y")
#> [1] FALSE
 
# 删除变量“x”
rm(x)
x
#> Error in eval(expr, envir, enclos): object 'x' not found
# eval(expr, envir, enclos)错误：找不到对象“x”
```

### 关于大小/结构

```
# 获得关于结构的信息
str(n)
#>  int [1:4] 1 2 3 4
 
str(df)
#> 'data.frame':    4 obs. of  2 variables:
#>  $ n  : int  1 2 3 4
#>  $ let: Factor w/ 4 levels "A","B","C","D": 1 2 3 4
 
# 得到一个向量的长度
length(n)
#> [1] 4
 
# 可能会得不到我们想要的长度
length(df)
#> [1] 2
 
# 行数
nrow(df)
#> [1] 4
 
# 列数
ncol(df)
#> [1] 2
 
# 得到行数和列数
dim(df)
#> [1] 4 2
 
```

------

原文链接：<http://www.cookbook-r.com/Basics/Information_about_variables/>
