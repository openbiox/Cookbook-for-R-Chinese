# ggplot |多图

## 问题

你想把多个图形放到同一个页面中。

## 方案
最简单的方法就是使用 `multiplot` 函数，本页末尾处附有该函数的具体定义。如果它不能满足你的需求，你可以将其复制下来然后作出适当的修改。
首先，构建并保存图像但不需要对它们进行渲染，这些图像的细节并不重要。你只需要将这些图像对象储存为变量。

```r
# 以下例子使用的是ggplot2包中自带的 Chickweight数据集
#第一幅图像
p1 <- ggplot(ChickWeight, aes(x=Time, y=weight, colour=Diet, group=Chick)) +
    geom_line() +
    ggtitle("Growth curve for individual chicks")

#第二幅图像
p2 <- ggplot(ChickWeight, aes(x=Time, y=weight, colour=Diet)) +
    geom_point(alpha=.3) +
    geom_smooth(alpha=.2, size=1) +
    ggtitle("Fitted growth curve per diet")

#第三幅图像
p3 <- ggplot(subset(ChickWeight, Time==21), aes(x=weight, colour=Diet)) +
    geom_density() +
    ggtitle("Final weight, by diet")

#第四幅图像
p4 <- ggplot(subset(ChickWeight, Time==21), aes(x=weight, fill=Diet)) +
    geom_histogram(colour="black", binwidth=50) +
    facet_grid(Diet ~ .) +
    ggtitle("Final weight, by diet") +
    theme(legend.position="none")    #为了避免冗余，这里不添加图例
```

这些图像都构建好了后，我们可以用 `multiplot` 对它们进行渲染。下面将这些图形分成两列进行展示：

```r
multiplot(p1, p2, p3, p4, cols=2)
#> `geom_smooth()`  函数设置成 method = 'loess'
```
![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/figure/unnamed-chunk-3-1.png)

## multiplot 函数
定义：`multiplot ` 函数可以将任意数量的图像对象作为参数，或者可以构建一个图像对象列表传递到该函数的 `plotlist` 参数中。
```r
# 多图功能
#
# ggplot 对象可以直接放入 `…` 中，也可以传递到 `plotlist` 里（这里的 ggplot 对象以列表形式存在）
# - cols: 图像的列数
# - layout: 用来指定布局的一组矩阵。当其存在时，可以忽略 `cols` 参数。
#
# 假设 layout 参数是 matrix(c(1,2,3,3), nrow=2, byrow = TRUE),
# 那么第一幅图像会位于左上方，第二幅图会在右上方，而
#第三幅图会占据整个下方。
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

#从参数 `…`中建立一个列表然后 plotlist
plots <- c(list(...), plotlist)

numPlots = length(plots)
# 假如 layout 是 NULL, 那么可以用 `cols` 来定义布局
  if (is.null(layout)) {
    # 创建面板
    # ncol: 图像的列数
    # nrow: 根据上述给定的列数，计算所需要的行数   
   layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }
if (numPlots==1) {
    print(plots[[1]])
} else {
    # 创建页面
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
# 让每一幅图像排列在正确的位置
    for (i in 1:numPlots) {
      # 获取包含这一子图所在区域的坐标 matrix i,j
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
```
