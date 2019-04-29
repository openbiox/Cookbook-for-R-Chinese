# 图例 (ggplot2)

## 问题

你想用ggplot2修改图表中的图例。

## 解决方案

从带有默认选项的示例图开始：

```
library(ggplot2)
bp <- ggplot(data=PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()
bp
```

![plot of chunk unnamed-chunk-2](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-2-1.png)

### 去除图例

使用 `guides(fill=FALSE)`, 用想要的颜色替代填充色.

你也可以用`theme` 移除图表中所有的图例。

```R
# 删除特定美学的图例（填充）
bp + guides(fill=FALSE)

# 在指定比例时也可以这样做
bp + scale_fill_discrete(guide=FALSE)

# 这将移除所有的图例
bp + theme(legend.position="none")
```

![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-4-1.png)

### 在图例中改变变量的顺序

这会将变量的顺序更改为trt1，ctrl，trt2:

```
bp + scale_fill_discrete(breaks=c("trt1","ctrl","trt2"))
```

![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-5-1.png)

根据指定颜色的方式，你可能必须使用不同的比例，例如 `scale_fill_manual`, `scale_colour_hue`, `scale_colour_manual`, `scale_shape_discrete`, `scale_linetype_discrete` 等等

### 反转图例中的条目顺序

反转图例顺序:

```R
# 这两种方式等同:
bp + guides(fill = guide_legend(reverse=TRUE))
bp + scale_fill_discrete(guide = guide_legend(reverse=TRUE))

# 你也可以直接修改比例尺：
bp + scale_fill_discrete(breaks = rev(levels(PlantGrowth$group)))
```

![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-7-1.png)

你可以使用不同的比例尺，例如 `scale_fill_manual`, `scale_colour_hue`, `scale_colour_manual`, `scale_shape_discrete`, `scale_linetype_discrete`等等，而不是`scale_fill_discrete`

### 隐藏图例标题

这将隐藏图例标题:

```R
# 为了填充的图例移除标题
bp + guides(fill=guide_legend(title=NULL))

# 为了所有的图例移除标题
bp + theme(legend.title=element_blank())
```

![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-9-1.png)

### 修改图例标题和标签的文字

有两种方法可以更改图例标题和标签。 第一种方法是告诉* scale *使用具有不同的标题和标签。 第二种方法是更改数据框，使因子具有所需的形式。

#### 使用比例尺

图例可能由 `fill`, `colour`, `linetype`, `shape`, 或其他因素所介导.

##### 使用填充和颜色

因为图例中的变量`group`被映射到颜色`fill`，所以必须使用`scale_fill_xxx`，其中`xxx`是将`group`的每个因子级别映射到不同颜色的方法。 默认设置是在每个因子级别的色轮上使用不同的色调，但也可以手动指定每个级别的颜色。

```
bp + scale_fill_discrete(name="Experimental\nCondition")

bp + scale_fill_discrete(name="Experimental\nCondition",
                         breaks=c("ctrl", "trt1", "trt2"),
                         labels=c("Control", "Treatment 1", "Treatment 2"))

# 使用手动刻度而不是色调
bp + scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"), 
                       name="Experimental\nCondition",
                       breaks=c("ctrl", "trt1", "trt2"),
                       labels=c("Control", "Treatment 1", "Treatment 2"))
```

![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-10-1.png)![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-10-2.png)![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-10-3.png)

请注意，这并未更改x轴标签。 有关如何修改轴标签的信息，请参见[Axes (ggplot2)](http://www.cookbook-r.com/Graphs/Axes_(ggplot2))。

如果使用折线图，则可能需要使用`scale_colour_xxx`和/或`scale_shape_xxx`而不是`scale_fill_xxx`。 **颜色**映射到线条和点的颜色，而**填充**映射到区域填充的颜色。 **形状**映射到点的形状。

我们将在这里为线图使用不同的数据集，因为PlantGrowth数据集不适用于折线图。

```R
# 一个不同的数据集
df1 <- data.frame(
    sex = factor(c("Female","Female","Male","Male")),
    time = factor(c("Lunch","Dinner","Lunch","Dinner"), levels=c("Lunch","Dinner")),
    total_bill = c(13.53, 16.81, 16.24, 17.42)
)

# 基本的图表
lp <- ggplot(data=df1, aes(x=time, y=total_bill, group=sex, shape=sex)) + geom_line() + geom_point()
lp

# 更改图例
lp + scale_shape_discrete(name  ="Payer",
                          breaks=c("Female", "Male"),
                          labels=c("Woman", "Man"))
```

![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-11-1.png)![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-11-2.png)

如果你同时使用`colour`和`shape`，它们都需要给出比例规格。 否则会有两个独立的图例。

```
# 指定颜色和形状
lp1 <- ggplot(data=df1, aes(x=time, y=total_bill, group=sex, shape=sex, colour=sex)) + geom_line() + geom_point()
lp1

# 如果你仅仅指定颜色，将会发生
lp1 + scale_colour_discrete(name  ="Payer",
                            breaks=c("Female", "Male"),
                            labels=c("Woman", "Man"))

# 指定的颜色和形状
lp1 + scale_colour_discrete(name  ="Payer",
                            breaks=c("Female", "Male"),
                            labels=c("Woman", "Man")) +
      scale_shape_discrete(name  ="Payer",
                           breaks=c("Female", "Male"),
                           labels=c("Woman", "Man"))
```

![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-12-1.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-12-2.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-12-3.png)

##### 比例尺的种类

比例尺有很多种。 它们采用“scale_xxx_yyy”的形式。 以下是一些常用的`xxx`和`yyy`值：

| **xxx**  | **描述**                      |
| -------- | ----------------------------- |
| colour   | Color of lines and points     |
| fill     | 填充区域的颜色 (比如：柱状图) |
| 线条类型 | Solid/dashed/dotted lines     |
| 形状     | Shape of points               |
| 大小     | Size of points                |
| alpha    | 不透明度/透明度               |

| **yyy**    | **描述**                                           |
| ---------- | -------------------------------------------------- |
| hue        | 色轮的颜色相同                                     |
| manual     | 手动指定的值（例如，颜色，点形状，线型）           |
| gradient   | 颜色渐变                                           |
| grey       | Shades of grey                                     |
| discrete   | 不连续的值 (比如颜色，点的形状，线条类型，点的大小 |
| continuous | 连续的值（透明度，颜色，点的大小）                 |

#### 更改数据框中的因子

更改图例标题和标签的另一种方法是直接修改数据框。

```R
pg <- PlantGrowth    # 把数据复制到新的数据框
# 重命名列中的列和值
levels(pg$group)[levels(pg$group)=="ctrl"] <- "Control"
levels(pg$group)[levels(pg$group)=="trt1"] <- "Treatment 1"
levels(pg$group)[levels(pg$group)=="trt2"] <- "Treatment 2"
names(pg)[names(pg)=="group"]  <- "Experimental Condition"

# 查看最终结果的几行
head(pg)
#>   衡量实验调节
#> 1   4.17                Control
#> 2   5.58                Control
#> 3   5.18                Control
#> 4   6.11                Control
#> 5   4.50                Control
#> 6   4.61                Control

# 画图 
ggplot(data=pg, aes(x=`Experimental Condition`, y=weight, fill=`Experimental Condition`)) +
    geom_boxplot()
```

![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-13-1.png)

图例标题“实验条件”很长，如果它被分成两行可能看起来更好，但是这种方法效果不好，因为你必须在列的名称中加上一个换行符。 另一种方法，有尺度，通常是更好的方法。

另请注意使用反引号而不是引号。 由于变量名中的空格，它们是必需的。

### 修改图例标题和标签的外观

```R
# 题目外观
bp + theme(legend.title = element_text(colour="blue", size=16, face="bold"))

# 标签外观
bp + theme(legend.text = element_text(colour="blue", size = 16, face = "bold"))
```

![plot of chunk unnamed-chunk-14](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-14-1.png)![plot of chunk unnamed-chunk-14](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-14-2.png)

### 修改图例框

默认情况下，图例周围没有框。 添加框并修改其属性:

```
bp + theme(legend.background = element_rect())
bp + theme(legend.background = element_rect(fill="gray90", size=.5, linetype="dotted"))
```

![plot of chunk unnamed-chunk-15](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-15-1.png)![plot of chunk unnamed-chunk-15](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-15-2.png)

### 改变图例位置

将图例位置放在绘图区域外（左/右/上/下）:

```
bp + theme(legend.position="top")
```

![plot of chunk unnamed-chunk-16](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-16-1.png)

也可以将图例定位在绘图区域内。 请注意，下面的数字位置是相对于整个区域的，包括标题和标签，而不仅仅是绘图区域。

```R
# 将图例放在图表中，其中x，y为0,0（左下角）到1,1（右上角）
bp + theme(legend.position=c(.5, .5))

# 设置图例的“锚点”（左下角为0,0;右上角为1,1）
# 将图例框的左下角放在图的左下角
bp + theme(legend.justification=c(0,0), legend.position=c(0,0))

# 将图例框的右下角放在图表的右下角
bp + theme(legend.justification=c(1,0), legend.position=c(1,0))
```

![plot of chunk unnamed-chunk-17](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-17-1.png)![plot of chunk unnamed-chunk-17](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-17-2.png)![plot of chunk unnamed-chunk-17](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-17-3.png)

### 隐藏在图例中的斜线

如果使用轮廓制作条形图（通过设置color =“black”），它将通过图例中的颜色绘制斜线。 没有内置的方法来删除斜杠，但可以覆盖它们。

```R
# 没有边缘线
ggplot(data=PlantGrowth, aes(x=group, fill=group)) +
    geom_bar()

# 添加轮廓，但图例中会出现斜线
ggplot(data=PlantGrowth, aes(x=group, fill=group)) +
    geom_bar(colour="black")

# 隐藏斜线：首先绘制没有轮廓的条形图并添加图例,
# 然后用轮廓再次绘制条形图，但带有空白图例.
ggplot(data=PlantGrowth, aes(x=group, fill=group)) +
    geom_bar() +
    geom_bar(colour="black", show.legend=FALSE)
```

![plot of chunk unnamed-chunk-18](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-18-1.png)![plot of chunk unnamed-chunk-18](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-18-2.png)![plot of chunk unnamed-chunk-18](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/figure/unnamed-chunk-18-3.png)

### 注意

更多信息，请看: <https://github.com/hadley/ggplot2/wiki/Legend-Attributes>