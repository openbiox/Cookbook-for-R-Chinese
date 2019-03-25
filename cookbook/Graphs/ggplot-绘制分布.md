# ggplot | 绘制分布图

## 问题
你想要绘制一组数据的分布图。

## 方案
后面的例子中会使用以下这组简单的数据：
```r
set.seed(1234)
dat <- data.frame(cond = factor(rep(c("A","B"), each=200)), 
                   rating = c(rnorm(200),rnorm(200, mean=.8)))
# View first few rows
head(dat)
#>   cond     rating
#> 1    A -1.2070657
#> 2    A  0.2774292
#> 3    A  1.0844412
#> 4    A -2.3456977
#> 5    A  0.4291247
#> 6    A  0.5060559
library(ggplot2)
```

## 直方图和概率密度图
`qplot` 函数能够用更简单的语法绘制出与  `ggplot` 相同的图像。然而，在实践过程中你会发现 `ggplot`是更好的选择，因为 `qplot` 中很多参数的选项都会让人感到困惑。
```r
## 以 rating 为横轴绘制直方图，组距设为 0.5
## 两种函数都可以绘制出相同的图:
ggplot(dat, aes(x=rating)) + geom_histogram(binwidth=.5)
# qplot(dat$rating, binwidth=.5)
# 绘制黑色边线，白色填充的图
ggplot(dat, aes(x=rating)) +
    geom_histogram(binwidth=.5, colour="black", fill="white")
# 密度曲线
ggplot(dat, aes(x=rating)) + geom_density()
# 直方图与核密度曲线重叠
ggplot(dat, aes(x=rating)) + 
    geom_histogram(aes(y=..density..),      # 这里直方图以 density (密度)为y轴
                   binwidth=.5,
                   colour="black", fill="white") +
    geom_density(alpha=.2, fill="#FF6666")  # 重合部分透明填充
```

![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-3-1.png)
![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-3-2.png)
![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-3-3.png)
![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-3-4.png)

添加一条均值线
```r
ggplot(dat, aes(x=rating)) +
    geom_histogram(binwidth=.5, colour="black", fill="white") +
    geom_vline(aes(xintercept=mean(rating, na.rm=T)),   # 忽略缺失值
               color="red", linetype="dashed", size=1)
```
![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-4-1.png)

## 多组数据的直方图和概率密度图
```r
# 重叠直方图
ggplot(dat, aes(x=rating, fill=cond)) +
    geom_histogram(binwidth=.5, alpha=.5, position="identity") # identity 表示将每个对象直接显示在图中，条形会彼此重叠。
# 间隔直方图
ggplot(dat, aes(x=rating, fill=cond)) +
    geom_histogram(binwidth=.5, position="dodge") # dodge 表示将每组的条形依次并列放置。
# 密度图
ggplot(dat, aes(x=rating, colour=cond)) + geom_density()
# 半透明填充的密度图
ggplot(dat, aes(x=rating, fill=cond)) + geom_density(alpha=.3)
```

![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-5-1.png)
![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-5-2.png)
![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-5-3.png)
![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-5-4.png)

在给每组数据添加均值线前，需要将每组数据的平均值赋值到一个新的数据框。
```r
# 求均值
library(plyr)
cdat <- ddply(dat, "cond", summarise, rating.mean=mean(rating))
cdat
#>   cond rating.mean
#> 1    A -0.05775928
#> 2    B  0.87324927
# 给重叠直方图添加均值线
ggplot(dat, aes(x=rating, fill=cond)) +
    geom_histogram(binwidth=.5, alpha=.5, position="identity") +
    geom_vline(data=cdat, aes(xintercept=rating.mean,  colour=cond),
               linetype="dashed", size=1)
# 给密度图添加均值线
ggplot(dat, aes(x=rating, colour=cond)) +
    geom_density() +
    geom_vline(data=cdat, aes(xintercept=rating.mean,  colour=cond),
               linetype="dashed", size=1)
```

![plot of chunk unnamed-chunk-6](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-6-1.png)
![plot of chunk unnamed-chunk-6](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-6-2.png)

使用分面：
```r
ggplot(dat, aes(x=rating)) + geom_histogram(binwidth=.5, colour="black", fill="white") + 
    facet_grid(cond ~ .)
# 使用之前的 cdat 添加均值线
ggplot(dat, aes(x=rating)) + geom_histogram(binwidth=.5, colour="black", fill="white") + 
    facet_grid(cond ~ .) +
    geom_vline(data=cdat, aes(xintercept=rating.mean),
               linetype="dashed", size=1, colour="red")
```
![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-7-1.png)

![plot of chunk unnamed-chunk-7](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-7-2.png)

更多关于分面的细节可查看[Facets (ggplot2)](http://www.cookbook-r.com/Graphs/Facets_(ggplot2))

## 箱型图
```r
# 绘制箱型图
ggplot(dat, aes(x=cond, y=rating)) + geom_boxplot()
# 对分组填充颜色
ggplot(dat, aes(x=cond, y=rating, fill=cond)) + geom_boxplot()
# 将上图中冗余的图例删除掉：
ggplot(dat, aes(x=cond, y=rating, fill=cond)) + geom_boxplot() +
    guides(fill=FALSE)
# 坐标轴翻转
ggplot(dat, aes(x=cond, y=rating, fill=cond)) + geom_boxplot() + 
    guides(fill=FALSE) + coord_flip()
```
       
![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-8-1.png)
![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-8-2.png)
![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-8-3.png)
![plot of chunk unnamed-chunk-8](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-8-4.png)
  
同时可以通过 ` stat_summary` 来添加平均值。
```r
# 用菱形图标指征平均值，并调整参数使该图标变更大。
ggplot(dat, aes(x=cond, y=rating)) + geom_boxplot() +
    stat_summary(fun.y=mean, geom="point", shape=5, size=4)
```
![plot of chunk unnamed-chunk-9](http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/figure/unnamed-chunk-9-1.png)



