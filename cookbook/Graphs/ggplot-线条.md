# 线条 (ggplot2)

## 问题

你想要把线条加到图上

## 解决方案

### 使用一个连续轴和一个分类轴

```R
# 一些样本数据
dat <- read.table(header=TRUE, text='
     cond result
  control     10
treatment   11.5
')

library(ggplot2)
```

#### 一条线段

这些使用`geom_hline`，因为y轴是连续的，但如果x轴是连续的，也可以使用`geom_vline`（带有'xintercept`）。

```R
# 基本柱状条
bp <- ggplot(dat, aes(x=cond, y=result)) +
    geom_bar(position=position_dodge(), stat="identity")
bp

# 添加水平线
bp + geom_hline(aes(yintercept=12))

# 使线条变红并变为虚线
bp + geom_hline(aes(yintercept=12), colour="#990000", linetype="dashed")
```

![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-3-1.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-3-2.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-3-3.png)

#### 每个分类值的单独行

要为每个条形成单独的行，请使用`geom_errorbar`。 误差条没有高度 - “ymin”=“ymax”。 由于某种原因，似乎有必要指定`y`，即使它没有任何功能。

```R
# 为每个条形绘制单独的线条。 首先添加另一列到目前为止
dat$hline <- c(9,12)
dat
#>        cond result hline
#> 1   control   10.0     9
#> 2 treatment   11.5    12

# 需要重新指定bp，因为数据已经改变
bp <- ggplot(dat, aes(x=cond, y=result)) +
    geom_bar(position=position_dodge(), stat="identity")

# 为每个柱状图画分开的线条
bp + geom_errorbar(aes(ymax=hline, ymin=hline), colour="#AA0000")

# 让线条更细一点 
bp + geom_errorbar(width=0.5, aes(ymax=hline, ymin=hline), colour="#AA0000")


# 即使我们从第二个数据框获得hline值，也可以得到相同的结果
# 使用hline定义数据框
dat_hlines <- data.frame(cond=c("control","treatment"), hline=c(9,12))
dat_hlines
#>        cond hline
#> 1   control     9
#> 2 treatment    12

# 柱状图形来自dat，但是线条来自dat_hlines 
bp + geom_errorbar(data=dat_hlines, aes(y=NULL, ymax=hline, ymin=hline), colour="#AA0000")
#> 警告：忽略未知的美学 : y
```

![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-4-1.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-4-2.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-4-3.png)

#### 分组栏上的线条

可以在分组条上添加线条。 在这个例子中，实际上有四行（`hline`的每个条目一行），但它看起来像两个，因为它们是相互重叠的。 我不认为可以避免这种情况，但它不会导致任何问题。

```R
dat <- read.table(header=TRUE, text='
     cond group result hline
  control     A     10     9
treatment     A   11.5    12
  control     B     12     9
treatment     B     14    12
')
dat
#>        cond group result hline
#> 1   control     A   10.0     9
#> 2 treatment     A   11.5    12
#> 3   control     B   12.0     9
#> 4 treatment     B   14.0    12

# 定义基本柱状图
bp <- ggplot(dat, aes(x=cond, y=result, fill=group)) +
    geom_bar(position=position_dodge(), stat="identity")
bp

# 误差线相互绘制 - 有四个但看起来像两个
bp + geom_errorbar(aes(ymax=hline, ymin=hline), linetype="dashed")
```

![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-5-1.png)![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-5-2.png)

#### 各个组合柱状图上的线条

即使在分组时，也可以在每个单独的条上划线。

```R
dat <- read.table(header=TRUE, text='
     cond group result hline
  control     A     10    11
treatment     A   11.5    12
  control     B     12  12.5
treatment     B     14    15
')

# 定义基本条形图
bp <- ggplot(dat, aes(x=cond, y=result, fill=group)) +
    geom_bar(position=position_dodge(), stat="identity")
bp

bp + geom_errorbar(aes(ymax=hline, ymin=hline), linetype="dashed",
                   position=position_dodge())
```

![plot of chunk unnamed-chunk-6](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-6-1.png)![plot of chunk unnamed-chunk-6](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-6-2.png)

### 有两个连续轴

样本数据如下

```R
dat <- read.table(header=TRUE, text='
      cond xval yval
   control 11.5 10.8
   control  9.3 12.9
   control  8.0  9.9
   control 11.5 10.1
   control  8.6  8.3
   control  9.9  9.5
   control  8.8  8.7
   control 11.7 10.1
   control  9.7  9.3
   control  9.8 12.0
 treatment 10.4 10.6
 treatment 12.1  8.6
 treatment 11.2 11.0
 treatment 10.0  8.8
 treatment 12.9  9.5
 treatment  9.1 10.0
 treatment 13.4  9.6
 treatment 11.6  9.8
 treatment 11.5  9.8
 treatment 12.0 10.6
')

library(ggplot2)
```

#### 基础线条

```
# 基本的散点图
sp <- ggplot(dat, aes(x=xval, y=yval, colour=cond)) + geom_point()

# 添加一个水平线条
sp + geom_hline(aes(yintercept=10))

# 添加红色虚线垂直线
sp + geom_hline(aes(yintercept=10)) +
    geom_vline(aes(xintercept=11.5), colour="#BB0000", linetype="dashed")
```

![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-9-1.png)![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-9-2.png)

#### 画线为平均值

还可以计算每个数据子集的平均值，按一些变量分组。 组意味着必须计算并存储在单独的数据框中，最简单的方法是使用dplyr包。 请注意，该行的y范围由数据确定。

```R
library(dplyr)
lines <- dat %>%
  group_by(cond) %>%
  summarise(
    x = mean(xval),
    ymin = min(yval),
    ymax = max(yval)
  )

# 为每组的平均xval添加彩色线条
sp + geom_hline(aes(yintercept=10)) +
     geom_linerange(aes(x=x, y=NULL, ymin=ymin, ymax=ymax), data=lines)
#> 警告：忽略未知的美学 : y
```

![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-10-1.png)

#### 在分面使用线条

一般来说，如果你加一条线，它将出现在所有的分面上.

```R
# 分面，基于cond
spf <- sp + facet_grid(. ~ cond)
spf

# 用相同的值在所有的分面上画水平线
spf + geom_hline(aes(yintercept=10))
```

![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-11-1.png)![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-11-2.png)

如果您希望不同的线条出现在不同的方面，有两个选项。 一种是创建具有所需线条值的新数据框。 另一种选择（控制更有限）是在`geom_line（）`中使用`stat`和`xintercept`。

```R
dat_vlines <- data.frame(cond=levels(dat$cond), xval=c(10,11.5))
dat_vlines
#>        cond xval
#> 1   control 10.0
#> 2 treatment 11.5

spf + geom_hline(aes(yintercept=10)) +
      geom_vline(aes(xintercept=xval), data=dat_vlines,
                    colour="#990000", linetype="dashed")

spf + geom_hline(aes(yintercept=10)) +
     geom_linerange(aes(x=x, y=NULL, ymin=ymin, ymax=ymax), data=lines)
#> 警告：忽略未知的美学 : y
```

![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-12-1.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Lines_(ggplot2)/figure/unnamed-chunk-12-2.png)