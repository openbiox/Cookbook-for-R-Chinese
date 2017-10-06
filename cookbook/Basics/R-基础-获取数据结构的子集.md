---
title: "Basics-获取数据结构的子集"
date: 2017-09-07
status: publish
categories: 
- R
- R-Cookbook
tags:
- R
- subset
---




## 问题

你想得到一个由向量，矩阵或数据框里元素组成的子集。

<!-- more -->


## 解决

为了基于一些条件准则获得子集，可以使用`subset()`函数或者是方括号索引。 在这里的例子中，显示了两种方式。

```
v <- c(1,4,4,3,2,2,3)

subset(v, v<3)
#> [1] 1 2 2
v[v<3]
#> [1] 1 2 2


# 另一个向量
t <- c("small", "small", "large", "medium")

# 删除 "small" 这一项
subset(t, t!="small")
#> [1] "large"  "medium"
t[t!="small"]
#> [1] "large"  "medium"

```

这两种方法之间的一个重要区别在于方括号索引可以为元素赋值，而subset（）不可以。

```
v[v<3] <- 9

subset(v, v<3) <- 9
#> Error in subset(v, v < 3) <- 9: could not find function "subset<-"

```

## 数据框：

```
# 样本数据框
data <- read.table(header=T, text='
 subject sex size
       1   M    7
       2   F    6
       3   F    9
       4   M   11
 ')


subset(data, subject < 3)
#>   subject sex size
#> 1       1   M    7
#> 2       2   F    6
data[data$subject < 3, ]
#>   subject sex size
#> 1       1   M    7
#> 2       2   F    6


# 特定行和列的子集
subset(data, subject < 3, select = -subject)
#>   sex size
#> 1   M    7
#> 2   F    6
subset(data, subject < 3, select = c(sex,size))
#>   sex size
#> 1   M    7
#> 2   F    6
subset(data, subject < 3, select = sex:size)
#>   sex size
#> 1   M    7
#> 2   F    6
data[data$subject < 3, c("sex","size")]
#>   sex size
#> 1   M    7
#> 2   F    6


# 逻辑AND的两个条件
subset(data, subject < 3  &  sex=="M")
#>   subject sex size
#> 1       1   M    7
data[data$subject < 3  &  data$sex=="M", ]
#>   subject sex size
#> 1       1   M    7


# 逻辑或的两个条件
subset(data, subject < 3  |  sex=="M")
#>   subject sex size
#> 1       1   M    7
#> 2       2   F    6
#> 4       4   M   11
data[data$subject < 3  |  data$sex=="M", ]
#>   subject sex size
#> 1       1   M    7
#> 2       2   F    6
#> 4       4   M   11


# 基于转换数据的条件
subset(data, log2(size) > 3 )
#>   subject sex size
#> 3       3   F    9
#> 4       4   M   11
data[log2(data$size) > 3, ]
#>   subject sex size
#> 3       3   F    9
#> 4       4   M   11


# 当元素在另一个向量里时的子集
subset(data, subject %in% c(1,3))
#>   subject sex size
#> 1       1   M    7
#> 3       3   F    9
data[data$subject %in% c(1,3), ]
#>   subject sex size
#> 1       1   M    7
#> 3       3   F    9

```

## 注意

也可参考[数据结构索引](http://www.jianshu.com/p/3bb2489f7c6f)。
