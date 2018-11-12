# ggplot|坐标轴

## 问题

你想要改变轴的顺序或方向。

## 方案

> 注意：下面的例子中提到的`scale_y_continuous`、`ylim`等，`y`都可以替换为`x`。

下面使用内置的`PlantGrowth`数据集绘制一个基本的箱线图。

```r
library(ggplot2)

bp <- ggplot(PlantGrowth, aes(x=group, y=weight)) +
    geom_boxplot()
bp
```

![plot of chunk unnamed-chunk-2](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-2-1.png)

### 交换x和y轴

交换x和y轴（让x垂直、y水平）

```r
bp + coord_flip()
```

![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-3-1.png)

### 离散轴

#### 改变条目的顺序

```r
# 手动设定离散轴条目的顺序
bp + scale_x_discrete(limits=c("trt1","trt2","ctrl"))

## 逆转轴条目顺序
# 获取因子水平
flevels <- levels(PlantGrowth$group)
flevels
#> [1] "ctrl" "trt1" "trt2"

# 逆转顺序
flevels <- rev(flevels)
flevels
#> [1] "trt2" "trt1" "ctrl"

bp + scale_x_discrete(limits=flevels)

# 或者一行搞定
bp + scale_x_discrete(limits = rev(levels(PlantGrowth$group)))
```

![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-4-1.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-4-2.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-4-3.png)

#### 设定标签

对于离散变量，标签来自于因子水平。然而，有时候短的因子水平名字并不适合展示。

```r
bp + scale_x_discrete(breaks=c("ctrl", "trt1", "trt2"),
                      labels=c("Control", "Treat 1", "Treat 2"))
```

![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-5-1.png)

```r
# 隐藏x刻度、标签和网格线
bp + scale_x_discrete(breaks=NULL)

# 隐藏所有的刻度和标签（X轴），保留网格线
bp + theme(axis.ticks = element_blank(), axis.text.x = element_blank())
```

![plot of chunk unnamed-chunk-6](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-6-1.png)![plot of chunk unnamed-chunk-6](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-6-2.png)

### 连续轴

#### 设定范围和反转轴方向

如果你仅想简单地让轴包含某个值，可以使用`expand_limits()`，它会进行拓展而不是拉伸。

```r
# 确保y轴包含0
bp + expand_limits(y=0)

# 确保y轴包含0和8
bp + expand_limits(y=c(0,8))
```

![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-7-1.png)![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-7-2.png)

当然你也可以通过y刻度显式地指定。注意如果使用**任何**`scale_y_continuous` 命令，它会覆盖任何`ylim`命令，而且`ylim`会被忽略。

```r
## 设定连续值轴的范围
# 下面是相等的操作
bp + ylim(0, 8)
# bp + scale_y_continuous(limits=c(0, 8))
```

![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-8-1.png)

如果使用上述方法让y轴的范围变小，任何超出范围的数据都会被忽略。有时候这会产生一些问题，读者需要注意。

为了避免产生问题，你可以使用 `coord_cartesian` ，相比于设定轴的范围，它设定数据可视化的区域。

```r
## 这两个操作一致，超出范围的数据被删除了，导致产生一个误导的箱线图 
bp + ylim(5, 7.5)
#> Warning: Removed 13 rows containing non-finite values (stat_boxplot).
# bp + scale_y_continuous(limits=c(5, 7.5))

# 使用coord_cartesian "zooms"区域
bp + coord_cartesian(ylim=c(5, 7.5))

# 直接指定刻度
bp + coord_cartesian(ylim=c(5, 7.5)) + 
    scale_y_continuous(breaks=seq(0, 10, 0.25))  # Ticks from 0-10, every .25
```

![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-9-1.png)![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-9-2.png)![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-9-3.png)

#### 反转轴方向

```r
# 反转一个连续值轴的方向
bp + scale_y_reverse()
```

![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-10-1.png)

#### 设置和隐藏刻度标记

```r
# Setting the tick marks on an axis
# This will show tick marks on every 0.25 from 1 to 10
# The scale will show only the ones that are within range (3.50-6.25 in this case)
bp + scale_y_continuous(breaks=seq(1,10,1/4))

# 刻度不平等变化
bp + scale_y_continuous(breaks=c(4, 4.25, 4.5, 5, 6,8))

# 抑制标签和网格线
bp + scale_y_continuous(breaks=NULL)

# Hide tick marks and labels (on Y axis), but keep the gridlines
bp + theme(axis.ticks = element_blank(), axis.text.y = element_blank())
```

![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-11-1.png)![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-11-2.png)![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-11-3.png)![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-11-4.png)

#### 轴转log、sqrt等

By default, the axes are linearly scaled. It is possible to transform the axes with log, power, roots, and so on.

There are two ways of transforming an axis. One is to use a *scale* transform, and the other is to use a *coordinate* transform. With a scale transform, the data is transformed before properties such as breaks (the tick locations) and range of the axis are decided. With a coordinate transform, the transformation happens *after* the breaks and scale range are decided. This results in different appearances, as shown below.

```
# Create some noisy exponentially-distributed data
set.seed(201)
n <- 100
dat <- data.frame(
    xval = (1:n+rnorm(n,sd=5))/20,
    yval = 2*2^((1:n+rnorm(n,sd=5))/20)
)

# A scatterplot with regular (linear) axis scaling
sp <- ggplot(dat, aes(xval, yval)) + geom_point()
sp

# log2 scaling of the y axis (with visually-equal spacing)
library(scales)     # Need the scales package
sp + scale_y_continuous(trans=log2_trans())

# log2 coordinate transformation (with visually-diminishing spacing)
sp + coord_trans(y="log2")
```

![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-12-1.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-12-2.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-12-3.png)

With a scale transformation, you can also set the axis tick marks to show exponents.

```
sp + scale_y_continuous(trans = log2_trans(),
                        breaks = trans_breaks("log2", function(x) 2^x),
                        labels = trans_format("log2", math_format(2^.x)))
```

![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-13-1.png)

Many transformations are available. See `?trans_new` for a full list. If the transformation you need isn’t on the list, it is possible to write your own transformation function.

A couple scale transformations have convenience functions: `scale_y_log10` and `scale_y_sqrt` (with corresponding versions for x).

```
set.seed(205)
n <- 100
dat10 <- data.frame(
    xval = (1:n+rnorm(n,sd=5))/20,
    yval = 10*10^((1:n+rnorm(n,sd=5))/20)
)

sp10 <- ggplot(dat10, aes(xval, yval)) + geom_point()

# log10
sp10 + scale_y_log10()

# log10 with exponents on tick labels
sp10 + scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
                     labels = trans_format("log10", math_format(10^.x)))
```

![plot of chunk unnamed-chunk-14](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-14-1.png)![plot of chunk unnamed-chunk-14](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-14-2.png)

#### Fixed ratio between x and y axes

It is possible to set the scaling of the axes to an equal ratio, with one visual unit being representing the same numeric unit on both axes. It is also possible to set them to ratios other than 1:1.

```
# Data where x ranges from 0-10, y ranges from 0-30
set.seed(202)
dat <- data.frame(
    xval = runif(40,0,10),
    yval = runif(40,0,30)
)
sp <- ggplot(dat, aes(xval, yval)) + geom_point()

# Force equal scaling
sp + coord_fixed()

# Equal scaling, with each 1 on the x axis the same length as y on x axis
sp + coord_fixed(ratio=1/3)
```

![plot of chunk unnamed-chunk-15](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-15-1.png)![plot of chunk unnamed-chunk-15](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-15-2.png)

### Axis labels and text formatting

To set and hide the axis labels:

```
bp + theme(axis.title.x = element_blank()) +   # Remove x-axis label
     ylab("Weight (Kg)")                       # Set y-axis label

# Also possible to set the axis label with the scale
# Note that vertical space is still reserved for x's label
bp + scale_x_discrete(name="") +
     scale_y_continuous(name="Weight (Kg)")
```

![plot of chunk unnamed-chunk-16](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-16-1.png)![plot of chunk unnamed-chunk-16](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-16-2.png)

To change the fonts, and rotate tick mark labels:

```
# Change font options:
# X-axis label: bold, red, and 20 points
# X-axis tick marks: rotate 90 degrees CCW, move to the left a bit (using vjust,
#   since the labels are rotated), and 16 points
bp + theme(axis.title.x = element_text(face="bold", colour="#990000", size=20),
           axis.text.x  = element_text(angle=90, vjust=0.5, size=16))
```

![plot of chunk unnamed-chunk-17](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-17-1.png)

### Tick mark label text formatters

You may want to display your values as percents, or dollars, or in scientific notation. To do this you can use a **formatter**, which is a function that changes the text:

```
# Label formatters
library(scales)   # Need the scales package
bp + scale_y_continuous(labels=percent) +
     scale_x_discrete(labels=abbreviate)  # In this particular case, it has no effect
```

![plot of chunk unnamed-chunk-18](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-18-1.png)

Other useful formatters for continuous scales include `comma`, `percent`, `dollar`, and `scientific`. For discrete scales, `abbreviate` will remove vowels and spaces and shorten to four characters. For dates, use `date_format`.

Sometimes you may need to create your own formatting function. This one will display numeric minutes in HH:MM:SS format.

```
# Self-defined formatting function for times.
timeHMS_formatter <- function(x) {
    h <- floor(x/60)
    m <- floor(x %% 60)
    s <- round(60*(x %% 1))                   # Round to nearest second
    lab <- sprintf('%02d:%02d:%02d', h, m, s) # Format the strings as HH:MM:SS
    lab <- gsub('^00:', '', lab)              # Remove leading 00: if present
    lab <- gsub('^0', '', lab)                # Remove leading 0 if present
}

bp + scale_y_continuous(label=timeHMS_formatter)
```

![plot of chunk unnamed-chunk-19](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-19-1.png)

### Hiding gridlines

To hide all gridlines, both vertical and horizontal:

```
# Hide all the gridlines
bp + theme(panel.grid.minor=element_blank(),
           panel.grid.major=element_blank())

# Hide just the minor gridlines
bp + theme(panel.grid.minor=element_blank())
```

![plot of chunk unnamed-chunk-20](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-20-1.png)![plot of chunk unnamed-chunk-20](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-20-2.png)

It’s also possible to hide just the vertical or horizontal gridlines:

```
# Hide all the vertical gridlines
bp + theme(panel.grid.minor.x=element_blank(),
           panel.grid.major.x=element_blank())

# Hide all the horizontal gridlines
bp + theme(panel.grid.minor.y=element_blank(),
           panel.grid.major.y=element_blank())
```

![plot of chunk unnamed-chunk-21](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-21-1.png)![plot of chunk unnamed-chunk-21](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-21-2.png)