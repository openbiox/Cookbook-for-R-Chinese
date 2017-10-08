#Manipulating Data-NA存在的情况下，向量或因子间的比较

## 问题

你想比较两个向量或因子，而且是在`NA`存在的情况下比较，并返回`TRUE`或`FALSE`（而不是`NA`）。

## 方案

假设你有一个两列（包含布尔值）的列表：

```R
df <- data.frame( a=c(TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,NA,NA,NA),
                  b=c(TRUE,FALSE,NA,TRUE,FALSE,NA,TRUE,FALSE,NA))
df
#>       a     b
#> 1  TRUE  TRUE
#> 2  TRUE FALSE
#> 3  TRUE    NA
#> 4 FALSE  TRUE
#> 5 FALSE FALSE
#> 6 FALSE    NA
#> 7    NA  TRUE
#> 8    NA FALSE
#> 9    NA    NA
```

通常情况下，当你比较两个包含`NA`值的向量或因子时，原始值是`NA`，结果也将有`NA`。根据你的目的，这（不）可能为你所需。

```R
df$a == df$b
#> [1]  TRUE FALSE    NA FALSE  TRUE    NA    NA    NA    NA

# 同样的比较，但是可以生成列表的另一列：
data.frame(df, isSame = (df$a==df$b))
#>       a     b isSame
#> 1  TRUE  TRUE   TRUE
#> 2  TRUE FALSE  FALSE
#> 3  TRUE    NA     NA
#> 4 FALSE  TRUE  FALSE
#> 5 FALSE FALSE   TRUE
#> 6 FALSE    NA     NA
#> 7    NA  TRUE     NA
#> 8    NA FALSE     NA
#> 9    NA    NA     NA
```

### 可以与`NA`相比的一个函数

这个比较函数会把`NA`赋予另一个值。如果一个向量的两项都是`NA`，则返回`TRUE`；如果其中一个是`NA`，则返回`FALSE`；所有其他比较(无`NA`之间)的方式是一样的。

```R
# 这个函数将会返回TRUE，当两个元素相同（包括两个NA），其他情况返回FALSE
compareNA <- function(v1,v2) {
    same <- (v1 == v2) | (is.na(v1) & is.na(v2))
    same[is.na(same)] <- FALSE
    return(same)
}
```

### 使用该函数的例子

比较两个布尔向量：

```R
compareNA(df$a, df$b)
#> [1]  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE

# 同样的比较，生成另一列
data.frame(df, isSame = compareNA(df$a,df$b))
#>       a     b isSame
#> 1  TRUE  TRUE   TRUE
#> 2  TRUE FALSE  FALSE
#> 3  TRUE    NA  FALSE
#> 4 FALSE  TRUE  FALSE
#> 5 FALSE FALSE   TRUE
#> 6 FALSE    NA  FALSE
#> 7    NA  TRUE  FALSE
#> 8    NA FALSE  FALSE
#> 9    NA    NA   TRUE
```

它也能用于因子，即使因子的水平处于不同的次序：

```R
# 创建一个含因子的列表
df1 <- data.frame(a = factor(c('x','x','x','y','y','y', NA, NA, NA)),
                  b = factor(c('x','y', NA,'x','y', NA,'x','y', NA)))

# 比较
data.frame(df1, isSame = compareNA(df1$a, df1$b))
#>      a    b isSame
#> 1    x    x   TRUE
#> 2    x    y  FALSE
#> 3    x <NA>  FALSE
#> 4    y    x  FALSE
#> 5    y    y   TRUE
#> 6    y <NA>  FALSE
#> 7 <NA>    x  FALSE
#> 8 <NA>    y  FALSE
#> 9 <NA> <NA>   TRUE


# 也能用于因子，即使因子的水平处于不同的次序
df1$b <- factor(df1$b, levels=c('y','x'))
data.frame(df1, isSame = compareNA(df1$a, df1$b))
#>      a    b isSame
#> 1    x    x   TRUE
#> 2    x    y  FALSE
#> 3    x <NA>  FALSE
#> 4    y    x  FALSE
#> 5    y    y   TRUE
#> 6    y <NA>  FALSE
#> 7 <NA>    x  FALSE
#> 8 <NA>    y  FALSE
#> 9 <NA> <NA>   TRUE
```

---

原文链接：http://www.cookbook-r.com/Manipulating_data/Comparing_vectors_or_factors_with_NA/