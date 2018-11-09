# 标准绘图|QQ图

## 问题

你想要对你自己的数据分布与其他的分布进行比较。这常用语检查是否一个样本是否服从正态分布，以及两个样本是抽取自同一分布。

## 方案

假设这是你的数据：

```R
set.seed(183)
# 正态分布的数值
x <- rnorm(80, mean=50, sd=5)

# 均匀分布的数值
z <- runif(80)
# 比较用rnorm()抽样的数据分布与正态分布的差异
qqnorm(x)
qqline(x)

# 比较数据的4次幂分布与正态分布的差异
qqnorm(x^4)
qqline(x^4)


# 比较均匀分布抽取的数据与正态分布的差异
qqnorm(z)
qqline(z)
```

![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Q-Q_plot/figure/unnamed-chunk-3-1.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Q-Q_plot/figure/unnamed-chunk-3-2.png)![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Q-Q_plot/figure/unnamed-chunk-3-3.png)