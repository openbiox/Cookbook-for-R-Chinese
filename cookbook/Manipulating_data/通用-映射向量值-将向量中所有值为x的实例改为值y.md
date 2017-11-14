## 问题

你想将向量中所有值为x的实例改为值y。

## 方案

```R
# 创建一些样本数据
str <- c("alpha", "beta", "gamma")
num <- c(1, 2, 3)
```

最简单的方法是使用`plyr`包里的`revalue()`或`mapvalues()`。

```R
library(plyr)
revalue(str, c("beta"="two", "gamma"="three"))
#> [1] "alpha" "two"   "three"

mapvalues(str, from = c("beta", "gamma"), to = c("two", "three"))
#> [1] "alpha" "two"   "three"


# 对于数值型向量，revalue()没作用，由于它使用一个命名了的向量，向量名一般是字符串而不是数值，但mapvalues()仍然有作用
mapvalues(num, from = c(2, 3), to = c(5, 6))
#> [1] 1 5 6
```

如果你不想依赖`plyr`，你可以使用R内置函数。注意，这些方法将直接修改向量；也就是说，你不需要把结果保存回变量。

```R
# 把"beta" 替换为 "two"
str[str=="beta"] <- "two"
str
#> [1] "alpha" "two"   "gamma"

num[num==2] <- 5
num
#> [1] 1 5 3
```

也可以使用R的字符串的查找和替换函数来重新映射字符串向量的值。注意，`alpha`前后的^`和`$`确保整个字符串匹配。没有它们，如果有一个值为`alphabet`，它也会被匹配，替代`onebet`。

```R
str <- c("alpha", "beta", "gamma")

sub("^alpha$", "one", str)
#> [1] "one"   "beta"  "gamma"

# 把所有列的 "a" 替代为 "X"
gsub("a", "X", str)
#> [1] "XlphX" "betX"  "gXmmX"

# gsub() 替代所有匹配的元素
# sub() 只替代每一个元素首先匹配到的内容
```

## 另见

详见[**重命名因子水平**](http://www.jianshu.com/p/fbbdb180b39e)

------

原文链接：<http://www.cookbook-r.com/Manipulating_data/Mapping_vector_values/>