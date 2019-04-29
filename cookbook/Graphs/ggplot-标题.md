# ggplot | 标题

## 问题

你想给图形设定一个标题。

## 方案

一个不带标题的图形例子：

```r
library(ggplot2)
bp <- ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot()
bp
```
![plot of chunk unnamed-chunk-2](http://www.cookbook-r.com/Graphs/Titles_(ggplot2)/figure/unnamed-chunk-2-1.png)

添加标题
```r
bp + ggtitle("Plant growth")
## 等同于
# bp + labs(title="Plant growth")
# 如果标题比较长，可以用 \n 将它分成多行来显示
bp + ggtitle("Plant growth with\ndifferent treatments")
# 缩少行距并使用粗体
bp + ggtitle("Plant growth with\ndifferent treatments") + 
     theme(plot.title = element_text(lineheight=.8, face="bold"))
```
![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Titles_(ggplot2)/figure/unnamed-chunk-3-1.png)
![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Titles_(ggplot2)/figure/unnamed-chunk-3-2.png)
![plot of chunk unnamed-chunk-3](http://www.cookbook-r.com/Graphs/Titles_(ggplot2)/figure/unnamed-chunk-3-3.png)
