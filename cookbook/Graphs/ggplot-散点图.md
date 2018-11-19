# ggplot|散点图

## 问题	

你想要绘制一幅散点图。

## 方案

假设这是你的数据：

```r
set.seed(955)
#创建一些噪声数据
dat <- data.frame(cond = rep(c("A", "B"), each=10),
                  xvar = 1:20 + rnorm(20,sd=3),
                  yvar = 1:20 + rnorm(20,sd=3))
head(dat)
#>   cond      xvar         yvar
#> 1    A -4.252354  3.473157275
#> 2    A  1.702318  0.005939612
#> 3    A  4.323054 -0.094252427
#> 4    A  1.780628  2.072808278
#> 5    A 11.537348  1.215440358
#> 6    A  6.672130  3.608111411

library(ggplot2)
```

### 带回归线的基本散点图

```r
ggplot(dat, aes(x=xvar, y=yvar)) +
    geom_point(shape=1)      # 使用空心圆

ggplot(dat, aes(x=xvar, y=yvar)) +
    geom_point(shape=1) +    # 使用空心圆
    geom_smooth(method=lm)   # 添加回归线
                             # (默认包含95%置信区间)

ggplot(dat, aes(x=xvar, y=yvar)) +
    geom_point(shape=1) +    # 使用空心圆
    geom_smooth(method=lm,   # 添加回归线
                se=FALSE)    # 不加置信区域


ggplot(dat, aes(x=xvar, y=yvar)) +
    geom_point(shape=1) +    # 使用空心圆
    geom_smooth()            # 添加带置信区间的平滑拟合曲线
#> `geom_smooth()` using method = 'loess'
```

![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-3-1.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-3-2.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-3-3.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-3-4.png)

### 通过其他变量设置颜色和形状

```r
# 根据cond设置颜色
ggplot(dat, aes(x=xvar, y=yvar, color=cond)) + geom_point(shape=1)

# 同上，但这里带了回归线
ggplot(dat, aes(x=xvar, y=yvar, color=cond)) +
    geom_point(shape=1) +
    scale_colour_hue(l=50) + # 使用稍暗的调色板
    geom_smooth(method=lm,   
                se=FALSE)    

# 拓展回归线到数据区域之外（带预测效果）
ggplot(dat, aes(x=xvar, y=yvar, color=cond)) + geom_point(shape=1) +
    scale_colour_hue(l=50) + 
    geom_smooth(method=lm,   
                se=FALSE,    
                fullrange=TRUE) 


# 根据cond设置形状
ggplot(dat, aes(x=xvar, y=yvar, shape=cond)) + geom_point()

# 同上，但形状不同
ggplot(dat, aes(x=xvar, y=yvar, shape=cond)) + geom_point() +
    scale_shape_manual(values=c(1,2))  # 使用圆和三角形
```

![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-4-1.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-4-2.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-4-3.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-4-4.png)![plot of chunk unnamed-chunk-4](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-4-5.png)

阅读 [Colors (ggplot2)](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)) 和Shapes and line types](http://www.cookbook-r.com/Graphs/Shapes_and_line_types) 获取更多信息

### 处理图像元素叠加

如果你有很多数据点，或者你的数据是离散的，那么数据可能会覆盖到一起，这样就看不清楚同一个位置有多少数据了。

```r
# 取近似值
dat$xrnd <- round(dat$xvar/5)*5
dat$yrnd <- round(dat$yvar/5)*5

# 让每个点都部分透明
# 如果情况严重，可以使用更小的值
ggplot(dat, aes(x=xrnd, y=yrnd)) +
    geom_point(shape=19,      
               alpha=1/4)     


# 抖动点
# 抖动范围在x轴上是1，y轴上是0.5
ggplot(dat, aes(x=xrnd, y=yrnd)) +
    geom_point(shape=1,      
               position=position_jitter(width=1,height=.5))
```

![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-5-1.png)![plot of chunk unnamed-chunk-5](http://www.cookbook-r.com/Graphs/Scatterplots_(ggplot2)/figure/unnamed-chunk-5-2.png)

