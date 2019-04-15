# 用最后的非NA值填充NA值

## 问题

你想要将非NA值代替向量或者因子中的NA值

## 方案

这段代码展示了如何填充向量中的空白。如果需要重复执行此操作，请参阅下面的函数。该函数还可以用第一个确定的值填充领头`NA`，并正确处理因子。

```
# 示例数据
x <- c(NA,NA, "A","A", "B","B","B", NA,NA, "C", NA,NA,NA, "A","A","B", NA,NA)

goodIdx <- !is.na(x)
goodIdx
#>  [1] FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE
#> [15]  TRUE  TRUE FALSE FALSE

# 这些是来自x的非NA数值
# 加入领头的NA，后边会使用。用来进行索引
goodVals <- c(NA, x[goodIdx])
goodVals
#>  [1] NA  "A" "A" "B" "B" "B" "C" "A" "A" "B"

# 用来自输出向量的索引填充输出向量的索引
# 这些补偿了goodVals。加1是为了避免索引为0
fillIdx <- cumsum(goodIdx)+1
fillIdx
#>  [1]  1  1  2  3  4  5  6  6  6  7  7  7  7  8  9 10 10 10

# 原本向量的值被填充了
#>  [1] NA  NA  "A" "A" "B" "B" "B" "B" "B" "C" "C" "C" "C" "A" "A" "B" "B" "B"
```

### 填充空隙的函数

此函数执行与上面代码相同的操作。它还可以用第一个良好的值填充领头`NA`，并正确处理因子。

```R
fillNAgaps <- function(x, firstBack=FALSE) {
    ## 向量或因子中的NA被之前一个非NA值代替
    ## 如果firstBack为TRUE，将会对领头的NA填充第一个非NA值，否则不会
    # 如果是一个因子，保存因子的水平，并转换为整数
    lvls <- NULL
    if (is.factor(x)) {
        lvls <- levels(x)
        x    <- as.integer(x)
    }
 
    goodIdx <- !is.na(x)
 
    # 这些是来自于x的非NA值 
    # 加入领头NA或者以第一个值代替，取决于firstBack参数
    if (firstBack)   goodVals <- c(x[goodIdx][1], x[goodIdx])
    else             goodVals <- c(NA,            x[goodIdx])

	# 用来自输出向量的索引填充输出向量的索引
	# 这些补偿了goodVals。加1是为了避免索引为0
    fillIdx <- cumsum(goodIdx)+1
    
    x <- goodVals[fillIdx]

    # 如果它最初是一个因子，那么将它转换回来
    if (!is.null(lvls)) {
        x <- factor(x, levels=seq_along(lvls), labels=lvls)
    }

    x
}



# 示例数据
x <- c(NA,NA, "A","A", "B","B","B", NA,NA, "C", NA,NA,NA, "A","A","B", NA,NA)
x
#>  [1] NA  NA  "A" "A" "B" "B" "B" NA  NA  "C" NA  NA  NA  "A" "A" "B" NA  NA

fillNAgaps(x)
#>  [1] NA  NA  "A" "A" "B" "B" "B" "B" "B" "C" "C" "C" "C" "A" "A" "B" "B" "B"

# 对领头的NA以第一个非NA值进行填充
fillNAgaps(x, firstBack=TRUE)
#>  [1] "A" "A" "A" "A" "B" "B" "B" "B" "B" "C" "C" "C" "C" "A" "A" "B" "B" "B"

# 因子数据也能使用
y <- factor(x)
y
#>  [1] <NA> <NA> A    A    B    B    B    <NA> <NA> C    <NA> <NA> <NA> A    A    B    <NA>
#> [18] <NA>
#> Levels: A B C

fillNAgaps(y)
#>  [1] <NA> <NA> A    A    B    B    B    B    B    C    C    C    C    A    A    B    B   
#> [18] B   
#> Levels: A B C
```

### 注释

改编自来自于**zoo** library的`na.locf()` 函数
