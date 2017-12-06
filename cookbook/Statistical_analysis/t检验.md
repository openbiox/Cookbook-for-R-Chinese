# t检验

## 问题

你想要检验来自两个总体的样本是否有不同的均值（显著性差异），或者检验从一个总体抽取的样本均值和理论均值有显著性差异。

## 方案

### 样本数据

我们将使用内置的`sleep`数据集。

```R
sleep
#>    extra group ID
#> 1    0.7     1  1
#> 2   -1.6     1  2
#> 3   -0.2     1  3
#> 4   -1.2     1  4
#> 5   -0.1     1  5
#> 6    3.4     1  6
#> 7    3.7     1  7
#> 8    0.8     1  8
#> 9    0.0     1  9
#> 10   2.0     1 10
#> 11   1.9     2  1
#> 12   0.8     2  2
#> 13   1.1     2  3
#> 14   0.1     2  4
#> 15  -0.1     2  5
#> 16   4.4     2  6
#> 17   5.5     2  7
#> 18   1.6     2  8
#> 19   4.6     2  9
#> 20   3.4     2 10
```

我们将制造`sleep`数据的宽格式版本；下面我们将看看如何处理长格式和宽格式的数据。

```R
sleep_wide <- data.frame(
    ID=1:10,
    group1=sleep$extra[1:10],
    group2=sleep$extra[11:20]
)
sleep_wide
#>    ID group1 group2
#> 1   1    0.7    1.9
#> 2   2   -1.6    0.8
#> 3   3   -0.2    1.1
#> 4   4   -1.2    0.1
#> 5   5   -0.1   -0.1
#> 6   6    3.4    4.4
#> 7   7    3.7    5.5
#> 8   8    0.8    1.6
#> 9   9    0.0    4.6
#> 10 10    2.0    3.4
```

### 比较两组：独立双样本t检验

假设有两组独立样本（我们这里忽略ID变量）。

`t.test`函数能够操作像`sleep`这样的长格式数据——一列记录测量值，一列指定组别；或者操作两个单独的向量。

```R
# Welch t-test 
t.test(extra ~ group, sleep)
#> 
#>  Welch Two Sample t-test
#> 
#> data:  extra by group
#> t = -1.8608, df = 17.776, p-value = 0.07939
#> alternative hypothesis: true difference in means is not equal to 0
#> 95 percent confidence interval:
#>  -3.3654832  0.2054832
#> sample estimates:
#> mean in group 1 mean in group 2 
#>            0.75            2.33

# Same for wide data (two separate vectors)
# t.test(sleep_wide$group1, sleep_wide$group2)
```

默认，`t.test`不假设有方差齐性（或称作方差同质）。默认的不是Student t检验而是使用了Welch t检验。注意Welch t-test结果中df=17.776，这是因为对不同质方差进行了校正。要使用Student t检验的话，设置`var.equal=TRUE`。

```R
# Student t-test
t.test(extra ~ group, sleep, var.equal=TRUE)
#> 
#>  Two Sample t-test
#> 
#> data:  extra by group
#> t = -1.8608, df = 18, p-value = 0.07919
#> alternative hypothesis: true difference in means is not equal to 0
#> 95 percent confidence interval:
#>  -3.363874  0.203874
#> sample estimates:
#> mean in group 1 mean in group 2 
#>            0.75            2.33

# Same for wide data (two separate vectors)
# t.test(sleep_wide$group1, sleep_wide$group2, var.equal=TRUE)
```

### 配对样本t检验

你也可以使用配对样本t检验比较配对的数据。数据配对是指你可能有对某种药物治疗前后有观测值或者不同治疗有配对的研究对象。

再次说明，`t-test`函数可以用于有分组变量的数据框或者两个向量。它依赖相对位置来决定配对。如果你使用有分组变量的长格式数据，group=1的第一行与group2的第一行配对。确保数据排序好并且不存在缺失值是非常重要的；否则配对可以丢弃。这种情况中，我们能通过`group`和`ID`变量进行排序来确保顺序是一样的。关于排序更多信息参见[Sorting](https://link.jianshu.com/?t=http://www.cookbook-r.com/Manipulating_data/Sorting)。

```R
# Sort by group then ID
sleep <- sleep[order(sleep$group, sleep$ID), ]

# Paired t-test
t.test(extra ~ group, sleep, paired=TRUE)
#> 
#>  Paired t-test
#> 
#> data:  extra by group
#> t = -4.0621, df = 9, p-value = 0.002833
#> alternative hypothesis: true difference in means is not equal to 0
#> 95 percent confidence interval:
#>  -2.4598858 -0.7001142
#> sample estimates:
#> mean of the differences 
#>                   -1.58

# Same for wide data (two separate vectors)
# t.test(sleep.wide$group1, sleep.wide$group2, paired=TRUE)
```

配对t检验等价于检测是否配对的观察值的总体均值是否为0。

```R
t.test(sleep.wide$group1 - sleep.wide$group2, mu=0, var.equal=TRUE)
#> Error in t.test(sleep.wide$group1 - sleep.wide$group2, mu = 0, var.equal = TRUE): object 'sleep.wide' not found
```

### 与期望的总体均值进行比较：单样本t检验

假设你想要检测是否`extra`列的数据抽取自总体均值为0的总体。（这里忽略`group`与`ID`列）

```R
t.test(sleep$extra, mu=0)
#> 
#>  One Sample t-test
#> 
#> data:  sleep$extra
#> t = 3.413, df = 19, p-value = 0.002918
#> alternative hypothesis: true mean is not equal to 0
#> 95 percent confidence interval:
#>  0.5955845 2.4844155
#> sample estimates:
#> mean of x 
#>      1.54
```

想要可视化结果，参见 [../../Graphs/Plotting distributions (ggplot2)](https://link.jianshu.com/?t=http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)), [../../Graphs/Histogram and density plot](https://link.jianshu.com/?t=http://www.cookbook-r.com/Graphs/Histogram_and_density_plot)，以及 [../../Graphs/Box plot](https://link.jianshu.com/?t=http://www.cookbook-r.com/Graphs/Box_plot)。