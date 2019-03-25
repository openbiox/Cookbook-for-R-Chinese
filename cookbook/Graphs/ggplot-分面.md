# ggplot | 分面

## 问题
你想要根据一个或多个变量对数据进行分割并且绘制出该数据所有的子图。

## 方案
### 样本数据
以下例子将使用 `reshape2` 包中的 `tips`数据集 
```r
library(reshape2)
# 查看头几行数据
head(tips)
#>   total_bill  tip    sex smoker day   time size
#> 1      16.99 1.01 Female     No Sun Dinner    2
#> 2      10.34 1.66   Male     No Sun Dinner    3
#> 3      21.01 3.50   Male     No Sun Dinner    3
#> 4      23.68 3.31   Male     No Sun Dinner    2
#> 5      24.59 3.61 Female     No Sun Dinner    4
#> 6      25.29 4.71   Male     No Sun Dinner    4
```

根据小费 (tip) 占总账单 (total_bill) 的百分比绘制散点图

```r
library(ggplot2)
sp <- ggplot(tips, aes(x=total_bill, y=tip/total_bill)) + geom_point(shape=1)
sp
```

![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-3-1.png)

### facet_grid

根据一个或多个变量对数据进行分割，生成的子图按照水平或垂直的方向进行排列。这一功能是通过赋予 `facet_grid()` 函数一个  `vertical ~ horizontal` 公式来实现的（这里所说的“公式”是R中的一种数据结构，而不是数学意义上的公式）。
```r
# 根据 "sex" 按垂直方向分割
sp + facet_grid(sex ~ .)
```

![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-4-1.png)

```r
# 根据 "sex" 按水平方向分割。
sp + facet_grid(. ~ sex)
```

![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-5-1.png)

```r
# 垂直方向以 "sex" 分割，水平方向以 "day" 分割。
sp + facet_grid(sex ~ day)
```

![plot of chunk unnamed-chunk-6](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-6-1.png)

### facet_wrap
除了能够根据**单个变量**在水平或垂直方向上对图进行分面，`facet_wrap()`函数可以通过设置特定的行数或列数，让子图排列到一起。此时每个图像的上方都会有标签。
```r
# 以变量 `day`进行水平分面，分面的行数为2。
sp + facet_wrap( ~ day, ncol=2)
```
![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-7-1.png)

### 修改分面标签的外观

```r
sp + facet_grid(sex ~ day) +
    theme(strip.text.x = element_text(size=8, angle=75),
          strip.text.y = element_text(size=12, face="bold"),
          strip.background = element_rect(colour="red", fill="#CCCCFF"))
```
![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-8-1.png)

### 修改分面标签的文本
修改分面标签内容有两种方法。最简单的方法是为原来的名字匹配一个新的名字向量。比方说对数据中 `sex` 的类别进行重新定义  Female==>Women, and Male==>Men:

```r
labels <- c(Female = "Women", Male = "Men")
sp + facet_grid(. ~ sex, labeller=labeller(sex = labels))
```
另一个方法就是直接在数据框中修改，将你想要显示的标签赋值给相应的数据:

```r
tips2 <- tips
levels(tips2$sex)[levels(tips2$sex)=="Female"] <- "Women"
levels(tips2$sex)[levels(tips2$sex)=="Male"]   <- "Men"
head(tips2, 3)
#>   total_bill  tip   sex smoker day   time size
#> 1      16.99 1.01 Women     No Sun Dinner    2
#> 2      10.34 1.66   Men     No Sun Dinner    3
#> 3      21.01 3.50   Men     No Sun Dinner    3
# Both of these will give the same output:
sp2 <- ggplot(tips2, aes(x=total_bill, y=tip/total_bill)) + geom_point(shape=1)
sp2 + facet_grid(. ~ sex)
```

两种方法都能得到相同的结果：

![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-11-1.png)

`labeller()` 可以通过设定不同的 `函数` 来处理输入的字符向量。比方说 `Hmisc` 包里的  `capitalize` 函数可以将字符串的首字母变成大写。我们也可以这样来自定义函数，如下所示，将字符串中的字母倒序：
```r
# 对每个字符向量进行倒序：
reverse <- function(strings) {
    strings <- strsplit(strings, "")
    vapply(strings, function(x) {
        paste(rev(x), collapse = "")
    }, FUN.VALUE = character(1))
}
sp + facet_grid(. ~ sex, labeller=labeller(sex = reverse))
```

![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-12-1.png)
### 设置标度
一般而言，每幅图的坐标轴范围都是**固定不变**的，也就是说每幅图都拥有相同的尺寸和范围。你可以通过将 `scales` 设置为 `free`，`free_x` 或 `free_y` 来改变坐标轴范围。

```r
# 描绘一个 total_bill的柱状图
hp <- ggplot(tips, aes(x=total_bill)) + geom_histogram(binwidth=2,colour="white")
# 根据性别和是否吸烟进行分面
hp + facet_grid(sex ~ smoker)
# 在同样的情况下设定 scales="free_y" (y轴自由标度）
hp + facet_grid(sex ~ smoker, scales="free_y")
# 画布的缩放比例不变，但各分面的范围有所改变，因此每个分面的物理大小都不一致
hp + facet_grid(sex ~ smoker, scales="free", space="free")
```

![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-13-1.png)

![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-13-2.png)

![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/figure/unnamed-chunk-13-3.png)




