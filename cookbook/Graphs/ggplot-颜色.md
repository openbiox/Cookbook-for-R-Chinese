# 颜色（ggplot2)

##  问题

你想在图表中用ggplot2添加颜色

## 解决方案

在ggplot2中设置颜色，对相互区分不同变量会有些困难，因为这些颜色有一样的亮度，且对色盲者不太友好。一个比较好的通用解决方案是使用对色盲友好的调色。

### 样本数据

这两个数据集将用来产生下面的图表

```R
 # 两个变量
df <- read.table(header=TRUE, text='
 cond yval
    A 2
    B 2.5
    C 1.6
')

# 三个变量
df2 <- read.table(header=TRUE, text='
 cond1 cond2 yval
    A      I 2
    A      J 2.5
    A      K 1.6
    B      I 2.2
    B      J 2.4
    B      K 1.2
    C      I 1.7
    C      J 2.3
    C      K 1.9
')
```

### 简单的颜色设置

有颜色的线条和点可以直接用'colour = "red" ', 用颜色名称代替”red"。填充的对象的颜色，例如柱状条，可以用 'fill="red" 来进行设置。

如果你想用任何其他非常规颜色，用十六进位码来设置颜色更容易，比如"#FF6699"。（看下面的十六进位码颜色图）

```R
library(ggplot2)
# 设置：黑色柱状条
ggplot(df, aes(x=cond, y=yval)) + geom_bar(stat="identity")
# 柱状条外用红色边线
ggplot(df, aes(x=cond, y=yval)) + geom_bar(stat="identity", colour="#FF9999") 
# 红色填充，黑色边线
ggplot(df, aes(x=cond, y=yval)) + geom_bar(stat="identity", fill="#FF9999", colour="black")


# 标准黑色线条和点
ggplot(df, aes(x=cond, y=yval)) + 
    geom_line(aes(group=1)) +     
    geom_point(size=3)
# 蓝黑色线条，红色点
ggplot(df, aes(x=cond, y=yval)) + 
    geom_line(aes(group=1), colour="#000099") +  # 蓝线
    geom_point(size=3, colour="#CC0000")         # 红点
```

![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-3-1.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-3-2.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-3-3.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-3-4.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-3-5.png)

### 将变量值映射到颜色

不用全局改变颜色，你可以将变量映射到颜色——换言之，通过把颜色放到aes()说明中，可以设置条件性变量。

```R
# 柱状条: x 和填充都依赖于cond2
ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity")

# 其他数据集的柱状条；填充依赖于cond2
ggplot(df2, aes(x=cond1, y=yval)) + 
    geom_bar(aes(fill=cond2),   # 填充依赖于cond2
             stat="identity",
             colour="black",    # 所有都是黑色轮廓线
             position=position_dodge()) # 把线条并排放置而非堆叠

# 线和点；颜色依赖于cond2
ggplot(df2, aes(x=cond1, y=yval)) + 
    geom_line(aes(colour=cond2, group=cond2)) + # 颜色分组都依赖于cond2
    geom_point(aes(colour=cond2),               # 颜色依赖于cond2
               size=3)                          # 更大的点，不同的形状
## 以上操作等价; 但把 "colour=cond2" 移到全局的映射用aes() 
# ggplot(df2, aes(x=cond1, y=yval, colour=cond2)) + 
#    geom_line(aes(group=cond2)) +
#    geom_point(size=3)
```

![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-4-1.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-4-2.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-4-3.png)

### 对色盲友好的颜色

这些是对色盲友好的颜色色板，一个用灰色，一个用黑色

![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-5-1.png)![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-5-2.png)

为了用ggplot2, 我们在一个变量里储存颜色色板，然后之后调用。

```
# 灰色的颜色色板:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# 黑色的颜色色板k:
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# 为了填充颜色，加
  scale_fill_manual(values=cbPalette)

# 为了在点线中使用颜色，加
  scale_colour_manual(values=cbPalette)
```

这个颜色集来源于网站： <http://jfly.iam.u-tokyo.ac.jp/color/>:

![Colorblind palette](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/colorblind_palette.jpg)

### 颜色选择

默认情况下，离散比例的颜色围绕HSL色环均匀分布。 例如，如果有两种颜色，那么它们将从圆圈上的相对点中选择; 如果有三种颜色，它们在色环上将相隔120°; 等等。 用于不同级别的颜色如下所示：

![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-7-1.png)

默认颜色选择使用`scale_fill_hue（）`和`scale_colour_hue（）`。 例如，在这些情况下添加这些命令是多余的：

```
# 这两个是等价的; 默认使用scale_fill_hue（）
ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity")
# ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity") + scale_fill_hue()

#  这两个是等价的; 默认使用scale_colour_hue（）
ggplot(df, aes(x=cond, y=yval, colour=cond)) + geom_point(size=2)
# ggplot(df, aes(x=cond, y=yval, colour=cond)) + geom_point(size=2) + scale_colour_hue()
```

![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-8-1.png)![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-8-2.png)

### 设置亮度和饱和度（色度）

虽然`scale_fill_hue（）`和`scale_colour_hue（）`在上面是多余的，但是当你想要改变默认值时，可以使用它们，比如改变亮度或色度。

```
# 使用 luminance=45, 而不是默认 65
ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity") +
    scale_fill_hue(l=40)

# 从100到50减少饱和度（亮度）, 增加亮度
ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity") +
    scale_fill_hue(c=45, l=80)

# 注意：使用scale_colour_hue() 设置线和点
```

![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-9-1.png)![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-9-2.png)

This is a chart of colors with luminance=45:

![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-10-1.png)

### 调色板：Color Brewer

您还可以使用其他色标，例如从RColorBrewer包中获取的色标。 请参阅下面的RColorBrewer调色板图表。

```R
ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity") +
    scale_fill_brewer()

ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity") +
    scale_fill_brewer(palette="Set1")

ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity") +
    scale_fill_brewer(palette="Spectral")

# 注意: 使用 scale_colour_brewer() 设置点和线条
```

![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-11-1.png)![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-11-2.png)![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-11-3.png)

### 调色板：手动定义

最后，您可以使用`scale_fill_manual（）`定义自己的颜色集。 有关选择特定颜色的帮助，请参阅下面的十六进制代码表。

```R
ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity") + 
    scale_fill_manual(values=c("red", "blue", "green"))

ggplot(df, aes(x=cond, y=yval, fill=cond)) + geom_bar(stat="identity") + 
    scale_fill_manual(values=c("#CC6666", "#9999CC", "#66CC99"))

# 注意：使用 scale_colour_manual() 设置线条和点
```

![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-12-1.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-12-2.png)

### 连续的颜色

```
# 产生一些数据
set.seed(133)
df <- data.frame(xval=rnorm(50), yval=rnorm(50))

# 依赖 yval设置颜色
ggplot(df, aes(x=xval, y=yval, colour=yval)) + geom_point()

# 使用不同的渐变
ggplot(df, aes(x=xval, y=yval, colour=yval)) + geom_point() + 
    scale_colour_gradientn(colours=rainbow(4))
```

![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-13-1.png)![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-13-2.png)

### 比色图表

### 十六进制色码图

颜色可以指定为十六进制RGB三元组合，例如“＃0066CC”。 前两位数字是红色，接下来的两位是绿色，最后两位是蓝色。 每个值的范围从00到FF，以十六进制（base-16）表示，在base-10中等于0和255。 例如，在下表中，“＃FFFFFF”为白色，“＃990000”为深红色。

![img](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/hextable.png)

(色码图来源于 [http://www.visibone.com](http://www.visibone.com/))

### RColorBrewer调色板图表

![plot of chunk unnamed-chunk-14](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/figure/unnamed-chunk-14-1.png)