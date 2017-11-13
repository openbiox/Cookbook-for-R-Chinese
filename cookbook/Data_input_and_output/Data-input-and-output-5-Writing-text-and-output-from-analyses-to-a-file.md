# 用R写入文本，分析输出到文件

## 问题

如果你想写出到文件

## 方案

`sink()`函数将会不定向输出到一个文件，而不是R终端。请注意，如果您在脚本中使用`sink()`，它崩溃之前输出到终端，然后看不到任何对你命令的响应。`sink()`的调用不带任何参数将返回输出到终端。

```R
# 开始写入到文件
sink('analysis-output.txt')

set.seed(12345)
x <-rnorm(10,10,1)
y <-rnorm(10,11,1)
# 加些东西
cat(sprintf("x has %d elements:\n", length(x)))
print(x)
cat("y =", y, "\n")

cat("=============================\n")
cat("T-test between x and y\n")
cat("=============================\n")
t.test(x,y)

# 停止写入
sink()


# 附加到文件
sink('analysis-output.txt', append=TRUE)
cat("Some more stuff here...\n")
sink()
```

输出文件的内容：

```R
x has 10 elements:
 [1] 10.585529 10.709466  9.890697  9.546503 10.605887  8.182044 10.630099  9.723816
 [9]  9.715840  9.080678
y = 10.88375 12.81731 11.37063 11.52022 10.24947 11.8169 10.11364 10.66842 12.12071 11.29872 
=============================
T-test between x and y
=============================

    Welch Two Sample t-test

data:  x and y
t = -3.8326, df = 17.979, p-value = 0.001222
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -2.196802 -0.641042
sample estimates:
mean of x mean of y 
 9.867056 11.285978 

Some more stuff here...
```

***

原文链接：http://www.cookbook-r.com/Data_input_and_output/Writing_text_and_output_from_analyses_to_a_file/
