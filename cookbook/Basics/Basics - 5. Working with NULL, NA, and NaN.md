# Basics - 处理`NULL`, `NA`, `NaN`

## 问题

你想正确处理`NULL`、`NA` （Not Available）、`NaN`（Not a Number）。

## 方案

你的数据有时将会存在`NULL`、`NA` 、`NaN`。处理这些数据有些不同于”正常”值，并可能需要确定性测试。

以下是这些值相比较的例子：

```R
x <- NULL
x > 5
# logical(0)

y <- NA
y > 5
# NA

z <- NaN
z > 5
# NA
```

如何测试某个变量是否是其中的一个值：

```R
is.null(x)
# TRUE

is.na(y)
# TRUE

is.nan(z)
# TRUE
```

注意，`NULL`不同于其他两个。`NULL`意味着没有值，而`NA`和`NaN`表示有价，尽管也许是不可用的。下面有一个例子区分：

```R
# Is y null?
is.null(y)
# FALSE

# Is x NA?
is.na(x)
# logical(0)
# Warning message:
# In is.na(x) : is.na() applied to non-(list or vector) of type 'NULL'
```

第一个例子，检查`y`是否是`NULL`，结果`y`并不是；第二个例子，试图检查`x`是否是`NA`，但并没有值被检测。

### 忽视向量汇总函数中的“坏”值

如果你对包含`NA`或`NaN`的向量使用诸如`mean()`或`sum()`之类的函数，结果将返回`NA`和`NaN`，这通常没有任何意义，虽然这样的结果会提醒你有“坏”值的存在。许多函数都有`na.rm`可以将这些值忽略。

```R
vy <- c(1, 2, 3, NA, 5)
# 1  2  3 NA  5
mean(vy)
# NA
mean(vy, na.rm=TRUE)
# 2.75

vz <- c(1, 2, 3, NaN, 5)
# 1   2   3 NaN   5
sum(vz)
# NaN
sum(vz, na.rm=TRUE)
# 11

# NULL不是问题，因为它不存在
vx <- c(1, 2, 3, NULL, 5)
# 1 2 3 5
sum(vx)
# 11
```

### 从向量中移除”坏值“

使用`is.na()`或`is.nan()`的反向函数，可以将这些值移除。

```R
vy
# 1  2  3 NA  5
vy[!is.na(vy)]
# 1  2  3  5

vz
# 1   2   3 NaN   5
vz[!is.nan(vz)]
# 1  2  3  5
```

### 注意

也有无限值`Inf`和`-Inf`，及其相应的函数`is.finite()`和`is.infinite()`。

见[/Manipulating data/Comparing vectors or factors with NA](http://www.cookbook-r.com/Manipulating_data/Comparing_vectors_or_factors_with_NA)

***

原文链接：http://www.cookbook-r.com/Basics/Working_with_NULL_NA_and_NaN/ 