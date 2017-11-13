# 用R查找并移除重复的记录

## 问题

你想查找和（或）移除向量或列表里重复的条目。

## 方案

向量：

```R
# 生成一个向量
set.seed(158)
x <- round(rnorm(20, 10, 5))
x
#>  [1] 14 11  8  4 12  5 10 10  3  3 11  6  0 16  8 10  8  5  6  6

# 对于每一个元素：它是否重复（第一个值不算）
duplicated(x)
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE
#> [15]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE

# 重复的条目的值
# 注意“6”出现了三次，所以它有俩
x[duplicated(x)]
#> [1] 10  3 11  8 10  8  5  6  6

# 重复的条目，没有重复
unique(x[duplicated(x)])
#> [1] 10  3 11  8  5  6

# 移除重复的数据，他们效果一样:
unique(x)
#>  [1] 14 11  8  4 12  5 10  3  6  0 16
x[!duplicated(x)]
#>  [1] 14 11  8  4 12  5 10  3  6  0 16
```

列表：

```R
# 一个样本列表:
df <- read.table(header=TRUE, text='
 label value
     A     4
     B     3
     C     6
     B     3
     B     1
     A     2
     A     4
     A     4
')


# 每一行是否有重复？
duplicated(df)
#> [1] FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE

# 显示重复的条目
df[duplicated(df),]
#>   label value
#> 4     B     3
#> 7     A     4
#> 8     A     4

# 显示没有重复的条目 (行名可能不同，但值相同)
unique(df[duplicated(df),])
#>   label value
#> 4     B     3
#> 7     A     4

# 移除重复的数据，他们效果一样:
unique(df)
#>   label value
#> 1     A     4
#> 2     B     3
#> 3     C     6
#> 5     B     1
#> 6     A     2
df[!duplicated(df),]
#>   label value
#> 1     A     4
#> 2     B     3
#> 3     C     6
#> 5     B     1
#> 6     A     2
```

---

原文链接：http://www.cookbook-r.com/Manipulating_data/Finding_and_removing_duplicate_records/
