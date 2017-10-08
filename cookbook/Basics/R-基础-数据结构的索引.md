# 数据结构的索引


## 问题

你想获得数据结构的一部分。

<!-- more -->

## 解决

可以使用数字索引或通过使用适当长度的布尔向量来提取向量，矩阵或数据框中的元素。
以下这些例子中有多种方式来解决这一问题。

### 用数字和名称进行索引

对于向量

```
# 样本向量
v <- c(1,4,4,3,2,2,3)

v[c(2,3,4)]
#> [1] 4 4 3
v[2:4]
#> [1] 4 4 3

v[c(2,4,3)]
#> [1] 4 3 4

```

对于数据框

```
# 创建样本数据框
data <- read.table(header=T, text='
 subject sex size
       1   M    7
       2   F    6
       3   F    9
       4   M   11
 ')

# 获取位于第一行第三列的元素
data[1,3]
#> [1] 7
data[1,"size"]
#> [1] 7


# 获取第1行和第2行所有列上的元素
data[1:2, ]   
#>   subject sex size
#> 1       1   M    7
#> 2       2   F    6
data[c(1,2), ]
#>   subject sex size
#> 1       1   M    7
#> 2       2   F    6


# 获取一，二两行第二列上的元素
data[1:2, 2]
#> [1] M F
#> Levels: F M
data[c(1,2), 2]
#> [1] M F
#> Levels: F M

# 获取行1和2，名为“sex”和 "size"的列
data[1:2, c("sex","size")]
#>   sex size
#> 1   M    7
#> 2   F    6
data[c(1,2), c(2,3)]
#>   sex size
#> 1   M    7
#> 2   F    6

```

### 使用布尔向量进行索引

向量V同上

```
v > 2
#> [1] FALSE  TRUE  TRUE  TRUE FALSE FALSE  TRUE

v[v>2]
#> [1] 4 4 3 3
v[ c(F,T,T,T,F,F,T)]
#> [1] 4 4 3 3

```

数据框同上

```
# 一个布尔向量 
data$subject < 3
#> [1]  TRUE  TRUE FALSE FALSE
    
data[data$subject < 3, ]
#>   subject sex size
#> 1       1   M    7
#> 2       2   F    6
data[c(TRUE,TRUE,FALSE,FALSE), ]
#>   subject sex size
#> 1       1   M    7
#> 2       2   F    6

# 也可以获取TRUE的数字索引
which(data$subject < 3)
#> [1] 1 2

```

### 负索引

与其他一些编程语言不同，当您在R中使用负数进行索引时，并不意味着从后向前索引。 相反，它意味着按照通常的从前往后顺序删除索引中的元素。

```
# 还是这个向量
v
#> [1] 1 4 4 3 2 2 3

# 删除第一个
v[-1]
#> [1] 4 4 3 2 2 3

#删除前三个
v[-1:-3]
#> [1] 3 2 2 3

# 只删除最后一个
v[-length(v)]
#> [1] 1 4 4 3 2 2

```

## 注意

也可参考 [获取数据结构的子集](http://www.jianshu.com/p/89485084c62c)
