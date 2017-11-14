## 问题

你想要为一个数据集绘制均值的误差棒。

## 方案

想要用ggplot2绘制图形，数据必须是数据框形式，而且是长格式（相对于宽格式）。 如果你的数据需要重构，请参考 [this page](http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format) 获取更多信息。

### 示例数据

下面的示例将使用 `ToothGrowth` 数据集。注意 `dose` 在这里是一个数值列， 一些情况下我们将它转换为因子变量将会更加有用。

```R
tg <- ToothGrowth
head(tg)
#>    len supp dose
#> 1  4.2   VC  0.5
#> 2 11.5   VC  0.5
#> 3  7.3   VC  0.5
#> 4  5.8   VC  0.5
#> 5  6.4   VC  0.5
#> 6 10.0   VC  0.5

library(ggplot2)
```

首先，我们必须对数据进行统计汇总。 这可以通过多种方式实现，参考[this page](http://www.cookbook-r.com/Manipulating_data/Summarizing_data). 在这个案例中，我们将使用 `summarySE()` 函数，该函数代码在本页面的最下方 ( `summarySE` 函数的代码在使用前必须已经键入)。

```R
# summarySE 函数提供了标准差、标准误以及95%的置信区间
tgc <- summarySE(tg, measurevar="len", groupvars=c("supp","dose"))
tgc
#>   supp dose  N   len       sd        se       ci
#> 1   OJ  0.5 10 13.23 4.459709 1.4102837 3.190283
#> 2   OJ  1.0 10 22.70 3.910953 1.2367520 2.797727
#> 3   OJ  2.0 10 26.06 2.655058 0.8396031 1.899314
#> 4   VC  0.5 10  7.98 2.746634 0.8685620 1.964824
#> 5   VC  1.0 10 16.77 2.515309 0.7954104 1.799343
#> 6   VC  2.0 10 26.14 4.797731 1.5171757 3.432090
```

### 线图

数据统计总结后，我们就可以开始绘制图形了。这里是一些带误差棒的线图和点图，误差棒代表标准差、标准误或者是95%的置信区间。

```R
# 均值的标准误
ggplot(tgc, aes(x=dose, y=len, colour=supp)) + 
    geom_errorbar(aes(ymin=len-se, ymax=len+se), width=.1) +
    geom_line() +
    geom_point()


# 发现误差棒重叠（dose=2.0），我们使用 position_dodge 将它们进行水平移动
pd <- position_dodge(0.1) # move them .05 to the left and right

ggplot(tgc, aes(x=dose, y=len, colour=supp)) + 
    geom_errorbar(aes(ymin=len-se, ymax=len+se), width=.1, position=pd) +
    geom_line(position=pd) +
    geom_point(position=pd)


# 使用95%置信区间替换标准误
ggplot(tgc, aes(x=dose, y=len, colour=supp)) + 
    geom_errorbar(aes(ymin=len-ci, ymax=len+ci), width=.1, position=pd) +
    geom_line(position=pd) +
    geom_point(position=pd)

# 黑色的误差棒 - 注意'group=supp'的映射 -- 没有它，误差棒将不会避开（就是会重叠）。
ggplot(tgc, aes(x=dose, y=len, colour=supp, group=supp)) + 
    geom_errorbar(aes(ymin=len-ci, ymax=len+ci), colour="black", width=.1, position=pd) +
    geom_line(position=pd) +
    geom_point(position=pd, size=3)
```

plot of chunk unnamed-chunk-4

plot of chunk unnamed-chunk-4

plot of chunk unnamed-chunk-4

plot of chunk unnamed-chunk-4

一张完成的带误差棒（代表均值的标准误）的图形可能像下面显示的那样。最会画点，这样白色将会在线和误差棒的上面（这个需要理解图层概念，顺序不同展示的效果是不一样的）。

```R
ggplot(tgc, aes(x=dose, y=len, colour=supp, group=supp)) + 
    geom_errorbar(aes(ymin=len-se, ymax=len+se), colour="black", width=.1, position=pd) +
    geom_line(position=pd) +
    geom_point(position=pd, size=3, shape=21, fill="white") + # 21的填充的圆
    xlab("Dose (mg)") +
    ylab("Tooth length") +
    scale_colour_hue(name="Supplement type",    # 图例标签使用暗色
                     breaks=c("OJ", "VC"),
                     labels=c("Orange juice", "Ascorbic acid"),
                     l=40) +                    # 使用暗色，亮度为40
    ggtitle("The Effect of Vitamin C on\nTooth Growth in Guinea Pigs") +
    expand_limits(y=0) +                        # 扩展范围
    scale_y_continuous(breaks=0:20*4) +         # 每4个单位设置标记（y轴）
    theme_bw() +
    theme(legend.justification=c(1,0),
          legend.position=c(1,0))               # 右下方放置图例
```

plot of chunk unnamed-chunk-5

### 直方图

直方图绘制误差棒也非常相似。 注意 `tgc$dose` 必须是一个因子。如果它是一个数值向量，将会不起作用。

```R
# 将dose转换为因子变量
tgc2 <- tgc
tgc2$dose <- factor(tgc2$dose)

# 误差棒代表了均值的标准误
ggplot(tgc2, aes(x=dose, y=len, fill=supp)) + 
    geom_bar(position=position_dodge(), stat="identity") +
    geom_errorbar(aes(ymin=len-se, ymax=len+se),
                  width=.2,                    # 误差棒的宽度
                  position=position_dodge(.9))


# 使用95%的置信区间替换标准误
ggplot(tgc2, aes(x=dose, y=len, fill=supp)) + 
    geom_bar(position=position_dodge(), stat="identity") +
    geom_errorbar(aes(ymin=len-ci, ymax=len+ci),
                  width=.2,                    # 误差棒的宽度
                  position=position_dodge(.9))
```

plot of chunk unnamed-chunk-6

plot of chunk unnamed-chunk-6

一张绘制完成的图片像下面这样：

```R
ggplot(tgc2, aes(x=dose, y=len, fill=supp)) + 
    geom_bar(position=position_dodge(), stat="identity",
             colour="black", # 使用黑色边框,
             size=.3) +      # 将线变细
    geom_errorbar(aes(ymin=len-se, ymax=len+se),
                  size=.3,    # 将线变细
                  width=.2,
                  position=position_dodge(.9)) +
    xlab("Dose (mg)") +
    ylab("Tooth length") +
    scale_fill_hue(name="Supplement type", # Legend label, use darker colors
                   breaks=c("OJ", "VC"),
                   labels=c("Orange juice", "Ascorbic acid")) +
    ggtitle("The Effect of Vitamin C on\nTooth Growth in Guinea Pigs") +
    scale_y_continuous(breaks=0:20*4) +
    theme_bw()
```

plot of chunk unnamed-chunk-7

### 为组内变量添加误差棒

当所有的变量都属于不同组别时，我们画标准误或者置信区间会显得非常简单直观。然而，当我们描绘的是组内变量（重复测量），那么添加标准误或者通常的置信区间可能会对不同条件下差异的推断产生误导作用。

下面的方法来自 [Morey (2008)](http://tqmp.org/Content/vol04-2/p061/p061.html)，它是对 [Cousineau (2005)](http://tqmp.org/Content/vol01-1/p042/p042.html)的矫正，而它所做的就是 提供比 [Loftus and Masson (1994)](http://www.springerlink.com/content/n2r2t04244246k68/)更简单的方法。 你可以查看这些文章，以获得更多对组内变量误差棒问题的详细探讨和方案。

这里有一个组内变量的数据集 (from Morey 2008): pre/post-test。

```R
dfw <- read.table(header=TRUE, text='
 subject pretest posttest
       1    59.4     64.5
       2    46.4     52.4
       3    46.0     49.7
       4    49.0     48.7
       5    32.5     37.4
       6    45.2     49.5
       7    60.3     59.9
       8    54.3     54.1
       9    45.4     49.6
      10    38.9     48.5
 ')

# 将物体的ID作为因子变量对待
dfw$subject <- factor(dfw$subject)
```

第一步是将该数据集转换为长格式。See [this page](http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format) for more information about the conversion.

```R
# 转换为长格式
library(reshape2)
dfw_long <- melt(dfw,
                 id.vars = "subject",
                 measure.vars = c("pretest","posttest"),
                 variable.name = "condition")

dfw_long
#>    subject condition value
#> 1        1   pretest  59.4
#> 2        2   pretest  46.4
#> 3        3   pretest  46.0
#> 4        4   pretest  49.0
#> 5        5   pretest  32.5
#> 6        6   pretest  45.2
#> 7        7   pretest  60.3
#> 8        8   pretest  54.3
#> 9        9   pretest  45.4
#> 10      10   pretest  38.9
#> 11       1  posttest  64.5
#> 12       2  posttest  52.4
#> 13       3  posttest  49.7
#> 14       4  posttest  48.7
#> 15       5  posttest  37.4
#> 16       6  posttest  49.5
#> 17       7  posttest  59.9
#> 18       8  posttest  54.1
#> 19       9  posttest  49.6
#> 20      10  posttest  48.5
```

使用 `summarySEwithin`函数瓦解数据 (defined at the [bottom](<http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/#Helper> functions) of this page; both of the helper functions below must be entered before the function is called here).

```R
dfwc <- summarySEwithin(dfw_long, measurevar="value", withinvars="condition",
                        idvar="subject", na.rm=FALSE, conf.interval=.95)

dfwc
#>   condition  N value value_norm       sd        se       ci
#> 1  posttest 10 51.43      51.43 2.262361 0.7154214 1.618396
#> 2   pretest 10 47.74      47.74 2.262361 0.7154214 1.618396

library(ggplot2)
# Make the graph with the 95% confidence interval
ggplot(dfwc, aes(x=condition, y=value, group=1)) +
    geom_line() +
    geom_errorbar(width=.1, aes(ymin=value-ci, ymax=value+ci)) +
    geom_point(shape=21, size=3, fill="white") +
    ylim(40,60)
```

plot of chunk unnamed-chunk-10

`value`和`value_norm` 列代表了未标准化和标准化后的值。See the section below on normed means for more information.

#### 理解组内变量的误差棒

这部分解释组内的误差棒值是如何计算出来的。这些步骤仅作解释目的；它们对于绘制误差棒是**非必需**的。

下面独立数据的图形结果展示了组内变量`condition`存在连续一致的趋势，但使用常规的标准误（或者置信区间）则不能充分地展示这一点。Morey (2008) 和Cousineau (2005)的方法本质是标准化数据去移除组间的变化，计算出这个标准化数据的变异程度。

```R
# Use a consistent y range
ymax <- max(dfw_long$value)
ymin <- min(dfw_long$value)

# Plot the individuals
ggplot(dfw_long, aes(x=condition, y=value, colour=subject, group=subject)) +
    geom_line() + geom_point(shape=21, fill="white") + 
    ylim(ymin,ymax)


# 创造标准化的版本
dfwNorm.long <- normDataWithin(data=dfw_long, idvar="subject", measurevar="value")

# Plot the normed individuals
ggplot(dfwNorm.long, aes(x=condition, y=value_norm, colour=subject, group=subject)) +
    geom_line() + geom_point(shape=21, fill="white") + 
    ylim(ymin,ymax)
```

plot of chunk unnamed-chunk-11

plot of chunk unnamed-chunk-11

针对正常（组间）方法和组内方法的误差棒差异在下面呈现。正常的方法计算出的误差棒用红色表示，组内方法的误差棒用黑色表示。

```R
# Instead of summarySEwithin, use summarySE, which treats condition as though it were a between-subjects variable
dfwc_between <- summarySE(data=dfw_long, measurevar="value", groupvars="condition", na.rm=FALSE, conf.interval=.95)
dfwc_between
#>   condition  N value       sd       se       ci
#> 1   pretest 10 47.74 8.598992 2.719240 6.151348
#> 2  posttest 10 51.43 7.253972 2.293907 5.189179

# 用红色显示组间的置信区间，用黑色展示组内的置信区间
ggplot(dfwc_between, aes(x=condition, y=value, group=1)) +
    geom_line() +
    geom_errorbar(width=.1, aes(ymin=value-ci, ymax=value+ci), colour="red") +
    geom_errorbar(width=.1, aes(ymin=value-ci, ymax=value+ci), data=dfwc) +
    geom_point(shape=21, size=3, fill="white") +
    ylim(ymin,ymax)
```

plot of chunk unnamed-chunk-12

#### 两个组内变量

如果存在超过一个的组内变量，我们可以使用相同的函数`summarySEwithin`。下面的数据集来自[Hays (1994)](http://books.google.com/books?id=zSi2AAAAIAAJ)，在 [Rouder and Morey (2005)](http://www.jstor.org/pss/40064075)中用来绘制这类的组内误差棒。

```R
data <- read.table(header=TRUE, text='
 Subject RoundMono SquareMono RoundColor SquareColor
       1        41         40         41          37
       2        57         56         56          53
       3        52         53         53          50
       4        49         47         47          47
       5        47         48         48          47
       6        37         34         35          36
       7        47         50         47          46
       8        41         40         38          40
       9        48         47         49          45
      10        37         35         36          35
      11        32         31         31          33
      12        47         42         42          42
')

```

数据集首先必须转换为长格式，列名显示了两个变量： shape (round/square) and color scheme (monochromatic/colored).

```R
# 转换为长格式
library(reshape2)
data_long <- melt(data=data, id.var="Subject",
                  measure.vars=c("RoundMono", "SquareMono", "RoundColor", "SquareColor"),
                  variable.name="Condition")
names(data_long)[names(data_long)=="value"] <- "Time"

# 拆分 Condition 列为 Shape and ColorScheme
data_long$Shape <- NA
data_long$Shape[grepl("^Round",  data_long$Condition)] <- "Round"
data_long$Shape[grepl("^Square", data_long$Condition)] <- "Square"
data_long$Shape <- factor(data_long$Shape)

data_long$ColorScheme <- NA
data_long$ColorScheme[grepl("Mono$",  data_long$Condition)] <- "Monochromatic"
data_long$ColorScheme[grepl("Color$", data_long$Condition)] <- "Colored"
data_long$ColorScheme <- factor(data_long$ColorScheme, levels=c("Monochromatic","Colored"))

# 现在移除 Condition column 
data_long$Condition <- NULL

# 检查数据
head(data_long)
#>   Subject Time Shape   ColorScheme
#> 1       1   41 Round Monochromatic
#> 2       2   57 Round Monochromatic
#> 3       3   52 Round Monochromatic
#> 4       4   49 Round Monochromatic
#> 5       5   47 Round Monochromatic
#> 6       6   37 Round Monochromatic
```

现在可以进行统计汇总和绘图了。

```R
datac <- summarySEwithin(data_long, measurevar="Time", withinvars=c("Shape","ColorScheme"), idvar="Subject")
datac
#>    Shape   ColorScheme  N     Time Time_norm       sd        se        ci
#> 1  Round       Colored 12 43.58333  43.58333 1.212311 0.3499639 0.7702654
#> 2  Round Monochromatic 12 44.58333  44.58333 1.331438 0.3843531 0.8459554
#> 3 Square       Colored 12 42.58333  42.58333 1.461630 0.4219364 0.9286757
#> 4 Square Monochromatic 12 43.58333  43.58333 1.261312 0.3641095 0.8013997

library(ggplot2)
ggplot(datac, aes(x=Shape, y=Time, fill=ColorScheme)) +
    geom_bar(position=position_dodge(.9), colour="black", stat="identity") +
    geom_errorbar(position=position_dodge(.9), width=.25, aes(ymin=Time-ci, ymax=Time+ci)) +
    coord_cartesian(ylim=c(40,46)) +
    scale_fill_manual(values=c("#CCCCCC","#FFFFFF")) +
    scale_y_continuous(breaks=seq(1:100)) +
    theme_bw() +
    geom_hline(yintercept=38) 
```

plot of chunk unnamed-chunk-15

### 注意标准化的均值

函数 `summarySEWithin` 返回标准化和未标准化的均值。未标准化的均值只是简单地表示每组的均值。标准化的均值计算出来保证组间的均值是一样的。 These values can diverge when there are between-subject variables.

比如：

```R
dat <- read.table(header=TRUE, text='
id trial gender dv
 A     0   male  2
 A     1   male  4
 B     0   male  6
 B     1   male  8
 C     0 female 22
 C     1 female 24
 D     0 female 26
 D     1 female 28
')

# 标准化和未标准化的均值是不同的
summarySEwithin(dat, measurevar="dv", withinvars="trial", betweenvars="gender",
                idvar="id")
#> Automatically converting the following non-factors to factors: trial
#>   gender trial N dv dv_norm sd se ci
#> 1 female     0 2 24      14  0  0  0
#> 2 female     1 2 26      16  0  0  0
#> 3   male     0 2  4      14  0  0  0
#> 4   male     1 2  6      16  0  0  0
```

### 助手函数

如果你处理的仅仅是组间变量，那么`summarySE`是你代码中唯一需要使用的函数。如果你的数据里有组内变量，**并且**你想要矫正误差棒使得组间的变异被移除，就像 Loftus and Masson (1994)里的那样，那么`normDataWithin` 和 `summarySEwithin`这两个函数必须加入你的代码中，然后调用`summarySEwithin` 函数进行计算。

```R
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
    library(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This does the summary. For each group's data frame, return a vector with
    # N, mean, and sd
    datac <- ddply(data, groupvars, .drop=.drop,
      .fun = function(xx, col) {
        c(N    = length2(xx[[col]], na.rm=na.rm),
          mean = mean   (xx[[col]], na.rm=na.rm),
          sd   = sd     (xx[[col]], na.rm=na.rm)
        )
      },
      measurevar
    )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean" = measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult

    return(datac)
}

## Norms the data within specified groups in a data frame; it normalizes each
## subject (identified by idvar) so that they have the same mean, within each group
## specified by betweenvars.
##   data: a data frame.
##   idvar: the name of a column that identifies each subject (or matched subjects)
##   measurevar: the name of a column that contains the variable to be summariezed
##   betweenvars: a vector containing names of columns that are between-subjects variables
##   na.rm: a boolean that indicates whether to ignore NA's
normDataWithin <- function(data=NULL, idvar, measurevar, betweenvars=NULL,
                           na.rm=FALSE, .drop=TRUE) {
    library(plyr)

    # Measure var on left, idvar + between vars on right of formula.
    data.subjMean <- ddply(data, c(idvar, betweenvars), .drop=.drop,
     .fun = function(xx, col, na.rm) {
        c(subjMean = mean(xx[,col], na.rm=na.rm))
      },
      measurevar,
      na.rm
    )

    # Put the subject means with original data
    data <- merge(data, data.subjMean)

    # Get the normalized data in a new column
    measureNormedVar <- paste(measurevar, "_norm", sep="")
    data[,measureNormedVar] <- data[,measurevar] - data[,"subjMean"] +
                               mean(data[,measurevar], na.rm=na.rm)

    # Remove this subject mean column
    data$subjMean <- NULL

    return(data)
}

## Summarizes data, handling within-subjects variables by removing inter-subject variability.
## It will still work if there are no within-S variables.
## Gives count, un-normed mean, normed mean (with same between-group mean),
##   standard deviation, standard error of the mean, and confidence interval.
## If there are within-subject variables, calculate adjusted values using method from Morey (2008).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   betweenvars: a vector containing names of columns that are between-subjects variables
##   withinvars: a vector containing names of columns that are within-subjects variables
##   idvar: the name of a column that identifies each subject (or matched subjects)
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySEwithin <- function(data=NULL, measurevar, betweenvars=NULL, withinvars=NULL,
                            idvar=NULL, na.rm=FALSE, conf.interval=.95, .drop=TRUE) {

  # Ensure that the betweenvars and withinvars are factors
  factorvars <- vapply(data[, c(betweenvars, withinvars), drop=FALSE],
    FUN=is.factor, FUN.VALUE=logical(1))

  if (!all(factorvars)) {
    nonfactorvars <- names(factorvars)[!factorvars]
    message("Automatically converting the following non-factors to factors: ",
            paste(nonfactorvars, collapse = ", "))
    data[nonfactorvars] <- lapply(data[nonfactorvars], factor)
  }

  # Get the means from the un-normed data
  datac <- summarySE(data, measurevar, groupvars=c(betweenvars, withinvars),
                     na.rm=na.rm, conf.interval=conf.interval, .drop=.drop)

  # Drop all the unused columns (these will be calculated with normed data)
  datac$sd <- NULL
  datac$se <- NULL
  datac$ci <- NULL

  # Norm each subject's data
  ndata <- normDataWithin(data, idvar, measurevar, betweenvars, na.rm, .drop=.drop)

  # This is the name of the new column
  measurevar_n <- paste(measurevar, "_norm", sep="")

  # Collapse the normed data - now we can treat between and within vars the same
  ndatac <- summarySE(ndata, measurevar_n, groupvars=c(betweenvars, withinvars),
                      na.rm=na.rm, conf.interval=conf.interval, .drop=.drop)

  # Apply correction from Morey (2008) to the standard error and confidence interval
  #  Get the product of the number of conditions of within-S variables
  nWithinGroups    <- prod(vapply(ndatac[,withinvars, drop=FALSE], FUN=nlevels,
                           FUN.VALUE=numeric(1)))
  correctionFactor <- sqrt( nWithinGroups / (nWithinGroups-1) )

  # Apply the correction factor
  ndatac$sd <- ndatac$sd * correctionFactor
  ndatac$se <- ndatac$se * correctionFactor
  ndatac$ci <- ndatac$ci * correctionFactor

  # Combine the un-normed means with the normed results
  merge(datac, ndatac)
}
```

------

原文链接：< <http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/>>

## 其他

解决问题的方法不止作者提供的这一种，为了理解ggplot2是如何进行误差棒的计算和添加，我在stackoverflow上提交了一个关于[ggplot2使用SE还是SD作为默认误差棒的问题](https://stackoverflow.com/questions/46192556/errorbar-in-ggplot-is-using-sd-or-se-as-default)。有人就提出了快速简易的解答。回答者的共同观点是必须先进行数据的统计计算。我之前在其他博客上看到的使用`stat_boxplot(geom="errorbar", width=.3)`直接计算误差棒可能就有问题（难以解释它算的是SD还是SE，我没有在帮助文档找到解释，我也不知道函数内部是如何计算的）。

by 诗翔