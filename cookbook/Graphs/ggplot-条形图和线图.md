# 条形图与线图

## 问题

你想要创建基本的条形图与线图

## 方案

想要使用ggplot2绘制图形，数据必须是一个数据框，而且必须是长格式。

### 基本图形，离散x-axis

使用条形图，条形的高度通常代表这种不同的东西：

* 每一组事件的**计数**，通过`stat_bin`指定，ggplot2默认使用该选项
* 数据集中某一列的**值**，通过`stat_identity`指定

| x axis   | 高度含义 | Common name |
| -------- | -------- | ----------- |
| **连续** | **计数** | 直方图      |
| **离散** | **计数** | 条形图      |
| **连续** | **数值** | 条形图      |
| **离散** | **数值** | 条形图      |



##### 有值的条形图

这里有一些样例数据 (抽自reshape2包的 `tips` 数据集):

```r
dat <- data.frame(
  time = factor(c("Lunch","Dinner"), levels=c("Lunch","Dinner")),
  total_bill = c(14.89, 17.23)
)
dat
#>     time total_bill
#> 1  Lunch      14.89
#> 2 Dinner      17.23

# Load the ggplot2 package
library(ggplot2)
```

在这些例子中，条形的高度代表数据框某一列的**值**，所以使用`stat="identity"` 而不是默认的`stat="bin"`。

这里使用的映射变量为：

- `time`: x-axis 和有时填充颜色
- `total_bill`: y-axis

```r
# 非常基本的条形图
ggplot(data=dat, aes(x=time, y=total_bill)) +
    geom_bar(stat="identity")


# 按时间填充颜色
ggplot(data=dat, aes(x=time, y=total_bill, fill=time)) +
    geom_bar(stat="identity")

## 这和上面是一样的结果
# ggplot(data=dat, aes(x=time, y=total_bill)) +
#    geom_bar(aes(fill=time), stat="identity")


# 添加黑色的边框线
ggplot(data=dat, aes(x=time, y=total_bill, fill=time)) +
    geom_bar(colour="black", stat="identity")


# 没有图例，因为这个信息是多余的
ggplot(data=dat, aes(x=time, y=total_bill, fill=time)) +
    geom_bar(colour="black", stat="identity") +
    guides(fill=FALSE)
```

![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-3-1.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-3-2.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-3-3.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-3-4.png)

一个理想的条形图可能是下面这样的：

```r
# 添加题目，缩小箱宽，填充颜色，改变轴标签
ggplot(data=dat, aes(x=time, y=total_bill, fill=time)) + 
    geom_bar(colour="black", fill="#DD8888", width=.8, stat="identity") + 
    guides(fill=FALSE) +
    xlab("Time of day") + ylab("Total bill") +
    ggtitle("Average bill for 2 people")
```

![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-4-1.png)

参见 [../Colors (ggplot2)](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)) 获取更多关于颜色的信息。

##### 计数的条形图

在下面例子中，条形高度代表事件的计数。

我们直接使用`reshape2`的`tips`数据集。

```r
library(reshape2)
# 查看头几行
head(tips)
#>   total_bill  tip    sex smoker day   time size
#> 1      16.99 1.01 Female     No Sun Dinner    2
#> 2      10.34 1.66   Male     No Sun Dinner    3
#> 3      21.01 3.50   Male     No Sun Dinner    3
#> 4      23.68 3.31   Male     No Sun Dinner    2
#> 5      24.59 3.61 Female     No Sun Dinner    4
#> 6      25.29 4.71   Male     No Sun Dinner    4
```

想要得到一个计数的条形图，不要映射变量到`y`，使用 `stat="bin"` (默认就是这个) 而不是`stat="identity"`:

```r
# 计数的条形图
ggplot(data=tips, aes(x=day)) +
    geom_bar(stat="count")
## 和上面等同, 因为stat="bin"是默认
# ggplot(data=tips, aes(x=day)) +
#    geom_bar()
```

![plot of chunk unnamed-chunk-6](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-6-1.png)

#### 线图

对于线图，数据点必须分组从而R知道怎么连接这些点。如果只有一组的话，非常简单，设定`group=1`即可，如果是多组，需要设定分组变量。

下面是使用的映射变量

- `time`: x-axis
- `total_bill`: y-axis

```r
# 基本的线图
ggplot(data=dat, aes(x=time, y=total_bill, group=1)) +
    geom_line()
## This would have the same result as above
# ggplot(data=dat, aes(x=time, y=total_bill)) +
#     geom_line(aes(group=1))

# 添加点
ggplot(data=dat, aes(x=time, y=total_bill, group=1)) +
    geom_line() +
    geom_point()

# 改变线和点的颜色
# 改变线的类型和点的类型，用更粗的线、更大的点
# 用红色填充点
ggplot(data=dat, aes(x=time, y=total_bill, group=1)) + 
    geom_line(colour="red", linetype="dashed", size=1.5) + 
    geom_point(colour="red", size=4, shape=21, fill="white")
```

![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-7-1.png)![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-7-2.png)![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-7-3.png)

理想的线图可能像下面这样：

```r
# 设定y轴的范围
# 改变轴标签
ggplot(data=dat, aes(x=time, y=total_bill, group=1)) +
    geom_line() +
    geom_point() +
    expand_limits(y=0) +
    xlab("Time of day") + ylab("Total bill") +
    ggtitle("Average bill for 2 people")
```

![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-8-1.png)



### 有更多变量的图

下面这个数据将用于接下来的例子

```r
dat1 <- data.frame(
    sex = factor(c("Female","Female","Male","Male")),
    time = factor(c("Lunch","Dinner","Lunch","Dinner"), levels=c("Lunch","Dinner")),
    total_bill = c(13.53, 16.81, 16.24, 17.42)
)
dat1
#>      sex   time total_bill
#> 1 Female  Lunch      13.53
#> 2 Female Dinner      16.81
#> 3   Male  Lunch      16.24
#> 4   Male Dinner      17.42
```

#### 条形图

变量映射：

- `time`: x-axis
- `sex`: color fill
- `total_bill`: y-axis.

```r
# 堆积条形图 -- 不常用
ggplot(data=dat1, aes(x=time, y=total_bill, fill=sex)) +
    geom_bar(stat="identity")

# 条形图，x轴是time,颜色填充是sex 
ggplot(data=dat1, aes(x=time, y=total_bill, fill=sex)) +
    geom_bar(stat="identity", position=position_dodge())

ggplot(data=dat1, aes(x=time, y=total_bill, fill=sex)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")

# 改变颜色
ggplot(data=dat1, aes(x=time, y=total_bill, fill=sex)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black") +
    scale_fill_manual(values=c("#999999", "#E69F00"))
```

![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-10-1.png)![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-10-2.png)![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-10-3.png)![plot of chunk unnamed-chunk-10](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-10-4.png)

改变映射是非常容易的

```r
# 条形图，x轴是性别，颜色是时间
ggplot(data=dat1, aes(x=sex, y=total_bill, fill=time)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
```

![plot of chunk unnamed-chunk-11](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-11-1.png)

#### 线图

变量映射：

- `time`: x-axis
- `sex`: line color
- `total_bill`: y-axis.

想要绘制多条线，必须指定分组变量。

```r
# 基本的带点线图
ggplot(data=dat1, aes(x=time, y=total_bill, group=sex)) +
    geom_line() +
    geom_point()

# 将性别映射到颜色
ggplot(data=dat1, aes(x=time, y=total_bill, group=sex, colour=sex)) +
    geom_line() +
    geom_point()

# 映射性别到不同的点类型
ggplot(data=dat1, aes(x=time, y=total_bill, group=sex, shape=sex)) +
    geom_line() +
    geom_point()


# 使用更粗的线、更大的点
ggplot(data=dat1, aes(x=time, y=total_bill, group=sex, shape=sex)) + 
    geom_line(size=1.5) + 
    geom_point(size=3, fill="white") +
    scale_shape_manual(values=c(22,21))
```

![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-12-1.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-12-2.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-12-3.png)![plot of chunk unnamed-chunk-12](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-12-4.png)

更改颜色和线型变量的映射非常容易：

```r
ggplot(data=dat1, aes(x=sex, y=total_bill, group=time, shape=time, color=time)) +
    geom_line() +
    geom_point()
```

![plot of chunk unnamed-chunk-13](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-13-1.png)



#### 完成的例子

完成的例子可能像下面这样

```r
# 一个条形图
ggplot(data=dat1, aes(x=time, y=total_bill, fill=sex)) + 
    geom_bar(colour="black", stat="identity",
             position=position_dodge(),
             size=.3) +                        # 更粗的线
    scale_fill_hue(name="Sex of payer") +      # 设定图例标题
    xlab("Time of day") + ylab("Total bill") + # 设定轴标签
    ggtitle("Average bill for 2 people") +     # 设定题目
    theme_bw()


# 一个线图
ggplot(data=dat1, aes(x=time, y=total_bill, group=sex, shape=sex, colour=sex)) + 
    geom_line(aes(linetype=sex), size=1) +     # 按性别设定线型
    geom_point(size=3, fill="white") +         # 使用更大的点，并用颜色填充
    expand_limits(y=0) +                       # 将0包含仅y轴
    scale_colour_hue(name="Sex of payer",      # 设定图例标题
                     l=30)  +                  # 使用更深的颜色 (lightness=30)
    scale_shape_manual(name="Sex of payer",
                       values=c(22,21)) +      # 
    scale_linetype_discrete(name="Sex of payer") +
    xlab("Time of day") + ylab("Total bill") + # 设定轴标签
    ggtitle("Average bill for 2 people") +     # 设定标题
    theme_bw() +
    theme(legend.position=c(.7, .4))           # 图例的位置
                                              
```

![plot of chunk unnamed-chunk-14](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-14-1.png)![plot of chunk unnamed-chunk-14](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-14-2.png)

为了保证上图的图例一致，必须指定3次。至于为何如此，点击 [这里](http://www.cookbook-r.com/Graphs/Legends_(ggplot2)#With_lines_and_points)。

### 使用数值 x-axis

```r
datn <- read.table(header=TRUE, text='
supp dose length
  OJ  0.5  13.23
  OJ  1.0  22.70
  OJ  2.0  26.06
  VC  0.5   7.98
  VC  1.0  16.77
  VC  2.0  26.14
')
```

来自`ToothGrowth` 数据集。

#### 当x-axis作为连续变量时

我们可以用它绘制一个线图

```r
ggplot(data=datn, aes(x=dose, y=length, group=supp, colour=supp)) +
    geom_line() +
    geom_point()
```

![plot of chunk unnamed-chunk-16](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-16-1.png)

#### 当x-axis作为分类变量时

首先，我们要将该变量转换为因子。

```r
# 拷贝数据框并将它转换为因子
datn2 <- datn
datn2$dose <- factor(datn2$dose)
ggplot(data=datn2, aes(x=dose, y=length, group=supp, colour=supp)) +
    geom_line() +
    geom_point()

# 使用原始的数据框，但使用factor函数在绘图时转换
ggplot(data=datn, aes(x=factor(dose), y=length, group=supp, colour=supp)) +
    geom_line() +
    geom_point()
```

![plot of chunk unnamed-chunk-17](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-17-1.png)![plot of chunk unnamed-chunk-17](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-17-2.png)

当连续值作为分类变量使用时，也可以绘制条形图。

```r
ggplot(data=datn2, aes(x=dose, y=length, fill=supp)) +
    geom_bar(stat="identity", position=position_dodge())

ggplot(data=datn, aes(x=factor(dose), y=length, fill=supp)) +
    geom_bar(stat="identity", position=position_dodge())
```

![plot of chunk unnamed-chunk-18](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-18-1.png)![plot of chunk unnamed-chunk-18](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/figure/unnamed-chunk-18-2.png)