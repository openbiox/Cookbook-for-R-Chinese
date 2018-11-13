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

默认轴是线性坐标，我们也可以将它转换为log、幂、根等等。

有两种办法可以转换一个轴，一是使用*scale*进行转换，另外是使用*coordinate*进行转换。使用前者需要在先弄好刻度和轴的范围之前转换，而使用后者则相反，需要在弄好刻度和轴范围之后转换。这将产生不太一样的显示效果，如下所示。

```r
# 创建指数分布数据
set.seed(201)
n <- 100
dat <- data.frame(
    xval = (1:n+rnorm(n,sd=5))/20,
    yval = 2*2^((1:n+rnorm(n,sd=5))/20)
)

# 创建常规的散点图
sp <- ggplot(dat, aes(xval, yval)) + geom_point()
sp

# log2比例化（间隔相等）
library(scales)     # 需要scales包
sp + scale_y_continuous(trans=log2_trans())

# log2坐标转换，空间间隔不同
sp + coord_trans(y="log2")
```

![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-12-1.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-12-2.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-12-3.png)

在标度转换中，我们还可以指定刻度值，让它们显示指数。
```r
sp + scale_y_continuous(trans = log2_trans(),
                        breaks = trans_breaks("log2", function(x) 2^x),
                        labels = trans_format("log2", math_format(2^.x)))
```

![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-13-1.png)

可以使用非常多的转换，参见 `?trans_new` 查看所有可用转换的列表。如果你所需要的转换不在该列表上，可以自己写一个转换函数。

有一些非常便捷的函数：`scale_y_log10`和`scale_y_sqrt` （有对应的x版本）。

```r
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

#### x与y轴固定的比例

设置x与y轴比例宽度也是可以的。

```r
# x范围0-10, y范围0-30
set.seed(202)
dat <- data.frame(
    xval = runif(40,0,10),
    yval = runif(40,0,30)
)
sp <- ggplot(dat, aes(xval, yval)) + geom_point()

# 强制比例相等
sp + coord_fixed()

# 相等的标度变化，让x的1个单位等同y的3个单位
sp + coord_fixed(ratio=1/3)
```

![plot of chunk unnamed-chunk-15](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-15-1.png)![plot of chunk unnamed-chunk-15](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-15-2.png)

### 轴标签和文字格式化

设置和隐藏轴标签：

```r
bp + theme(axis.title.x = element_blank()) +   # 移除x轴标签
     ylab("Weight (Kg)")                       # 设置y轴标签

# 也可以通过标度设置
# 注意这里x轴标签的空间仍然保留
bp + scale_x_discrete(name="") +
     scale_y_continuous(name="Weight (Kg)")
```

![plot of chunk unnamed-chunk-16](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-16-1.png)![plot of chunk unnamed-chunk-16](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-16-2.png)

改变字体、颜色、旋转刻度标签：

```r
# Change font options:
# X-axis label: bold, red, and 20 points
# X-axis tick marks: rotate 90 degrees CCW, move to the left a bit (using vjust,
#   since the labels are rotated), and 16 points
bp + theme(axis.title.x = element_text(face="bold", colour="#990000", size=20),
           axis.text.x  = element_text(angle=90, vjust=0.5, size=16))
```

![plot of chunk unnamed-chunk-17](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-17-1.png)

### 刻度标签

你可能想将值显示为百分比、或美元、或科学计数法。这里可以使用**格式器**，它是一个可以改变文本的函数。

```r
# 标签格式器
library(scales)   # 需要scales包
bp + scale_y_continuous(labels=percent) +
     scale_x_discrete(labels=abbreviate)  # 在这个例子中它没作用
```

![plot of chunk unnamed-chunk-18](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-18-1.png)

连续标度格式器有`comma`、`percent`、`dollar`以及`scientific`。离散标度格式器有`abbreviate`、`date_format`等。

有时你需要自己创建格式化函数。下面的函数可以显示时间格式为HH:MM:SS。

```r
# 自定义时间格式化函数
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

### 隐藏网格线

隐藏网格线：

```r
# 隐藏所有网格线
bp + theme(panel.grid.minor=element_blank(),
           panel.grid.major=element_blank())

# 仅隐藏次级网格线
bp + theme(panel.grid.minor=element_blank())
```

![plot of chunk unnamed-chunk-20](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-20-1.png)![plot of chunk unnamed-chunk-20](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-20-2.png)

也可以仅隐藏水平或垂直网格线：

```r
# 隐藏所有垂直网格线
bp + theme(panel.grid.minor.x=element_blank(),
           panel.grid.major.x=element_blank())

# 隐藏所有水平网格线
bp + theme(panel.grid.minor.y=element_blank(),
           panel.grid.major.y=element_blank())
```

![plot of chunk unnamed-chunk-21](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-21-1.png)![plot of chunk unnamed-chunk-21](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/figure/unnamed-chunk-21-2.png)