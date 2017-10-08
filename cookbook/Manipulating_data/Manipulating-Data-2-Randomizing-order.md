# Manipulating Data-用R生成随机的顺序

## 问题

你想事一个数据结构随机化。

## 方案

```R
# 创建一个向量
v <- 11:20

# 随机化向量的顺序
v <- sample(v)

# 创建一个列表
data <- data.frame(label=letters[1:5], number=11:15)
data
#>   label number
#> 1     a     11
#> 2     b     12
#> 3     c     13
#> 4     d     14
#> 5     e     15

# 随机化列表的顺序
data <- data[sample(1:nrow(data)), ]
data
#>   label number
#> 5     e     15
#> 2     b     12
#> 4     d     14
#> 3     c     13
#> 1     a     11
```

### 注意

为了使随机化可重复，你应该设置随机数生成器。详见：[Numbers-生成随机数](http://www.jianshu.com/p/5fe992779356)、[Numbers-生成可重复的随机数序列](http://www.jianshu.com/p/25a12a5a6e45)

***

原文链接：http://www.cookbook-r.com/Manipulating_data/Randomizing_order/