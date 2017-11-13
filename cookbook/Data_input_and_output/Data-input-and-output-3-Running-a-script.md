# 运行R脚本

## 问题

你想从文本文件运行R代码

## 解决

使用`source()`函数。

```R
# 首先，选择合适的目录
setwd('/home/username/desktop/rcode')

source('analyze.r')
```

请注意，如果你想让你的脚本生成文本输出，你必须使用`print()`或`cat()`函数。

```R
x <- 1:10

# 在脚本中，这什么都不做
x

# 使用print()函数:
print(x)
#> [1]  1  2  3  4  5  6  7  8  9 10


# 更简单的输出: 没有行/列，没有文本
cat(x)
#> 1  2  3  4  5  6  7  8  9 10
```

另一种代替方法是：运行`source()`并加上`print.eval=TRUE`选项。

***

原文链接：http://www.cookbook-r.com/Data_input_and_output/Running_a_script/
