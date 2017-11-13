# R中的排序问题

## 问题

你想将一个向量，矩阵或列表排序

## 解决

### 向量

```R
# 生成一个随机向量
v <- sample(101:110)

# 排序
sort(v)
#>  [1] 101 102 103 104 105 106 107 108 109 110

# 反向排序
sort(v, decreasing=TRUE)
#>  [1] 110 109 108 107 106 105 104 103 102 101
```

### 列表

列表在一个或多个列进行排序，您可以使用`plyr`包里的`arrange`函数，或者使用R内置的功能。`arrange`函数更容易使用，但需要外部安装包。

```R
# 生成一个列表
df <- data.frame (id=1:4,
            weight=c(20,27,24,22),
            size=c("small", "large", "medium", "large"))
df

library(plyr)

# "weight"列排序，他们有相同的结果.
arrange(df, weight)       # 使用plyr包里的arrange函数
df[ order(df$weight), ]   # 使用R内置的功能
#>   id weight   size
#> 1  1     20  small
#> 2  4     22  large
#> 3  3     24 medium
#> 4  2     27  large

# 以size为第一关键词, weight为第二关键词排序
arrange(df, size, weight)         # 使用plyr包里的arrange函数
df[ order(df$size, df$weight), ]  # 使用R内置的功能
#>   id weight   size
#> 4  4     22  large
#> 2  2     27  large
#> 3  3     24 medium
#> 1  1     20  small

# 所有列从左到右排序
df[ do.call(order, as.list(df)), ] 
# 在这个特殊的例子中,顺序将保持不变
```

请注意，`size`列是一个把行排序的因子。在这种情况下，横向将自动按字母顺序排列（创建数据表格），所以**大**是第一和**小**是最后。

####反向排序

使用`decreasing=TRUE`可以反向排序。

反向排序的方法依赖于数据类型：

- 数字：变量名前加一个`-`。例如：`df[order(-df$weight)]`


- 因子：转换为整数，变量名前加一个`-`。例如：`df[ order(-xtfrm(df$size)), ]`


- 字符：没有简单的方法能做到这一点。一种方法是先转换为一个因子，然后如上所述。

```R
# 反向排序weight列，他们有相同的结果：
arrange(df, -weight)                      # 使用plyr包里的arrange函数
df[ order(df$weight, decreasing=TRUE), ]  # 使用R内置的功能
df[ order(-df$weight), ]                  # 使用R内置的功能
#>   id weight   size
#> 2  2     27  large
#> 3  3     24 medium
#> 4  4     22  large
#> 1  1     20  small

# 升序排列size,然后降序排列weight
arrange(df, size, -weight)         # 使用plyr包里的arrange函数
df[ order(df$size, -df$weight), ]  # 使用R内置的功能
#>   id weight   size
#> 2  2     27  large
#> 4  4     22  large
#> 3  3     24 medium
#> 1  1     20  small

# 升序排列size,然后降序排列weight
# 因子需要xtfrm()
arrange(df, -xtfrm(size), weight)         # 使用plyr包里的arrange函数
df[ order(-xtfrm(df$size), df$weight), ]  # 使用R内置的功能
#>   id weight   size
#> 1  1     20  small
#> 3  3     24 medium
#> 4  4     22  large
#> 2  2     27  large
```

***

原文链接：http://www.cookbook-r.com/Manipulating_data/Sorting/
