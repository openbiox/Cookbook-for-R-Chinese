# 字符串

## 使用grep,sub,gsub进行搜索和替换


### 问题

你想要搜索或替换字符串中特定的文本。

### 方案

有两个常用字符串搜索函数`grep()`和`grepl()`。有两个常用的字符串替换函数`sub()`和`gsub()`。它们都是向量化的操作，会应用到输入字符向量的每一个元素上。

#### 文本搜索

`grep()`和`grepl()`函数搜索的输入的第一个参数都是带有正则表达式的字符串或者固定的字符串（需要设定选项`fixed=TRUE`），它们的不同之处是前者返回匹配的索引或值向量，而后者返回一个逻辑向量。

下面通过简单的例子理解它们的用法和两个函数的区别：从小写字母向量中搜索`c`。

```
> grep("c", letters)
[1] 3
> grepl("c", letters)
 [1] FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[19] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
```

`grep()`函数设定选项`value=TRUE`可以返回匹配的值。

```
> grep("c", letters, value = TRUE)
[1] "c"
> grep("c", c("dog", "cat"), value = TRUE)
[1] "cat"
```

正则表达式提供了一种表达字符模式的强大方式（详情查看`?regex`），我们可以将它应用于文本的搜索中。例如，我们想搜索字符向量中有4个数字连续出现的字符：

```
> grep("\\d{4}", c("This will not match", "2018-04-11, This will match"))
[1] 2
```

#### 文本替换

大部分情况下我们不仅仅想搜索到文本，而且还想要在搜索的基础上进行替换，这可以通过`sub()`和`gsub()`函数实现。这两个函数参数是一样的，第一个参数是搜索的模式，第二个参数是替换的模式，第三个参数是要操作的字符向量。两个函数的区别是前者只会替换字符串中第一个匹配的模式，而`gsub()`（`g`是`global`的缩写）会替换字符串中所有匹配的模式。

例如，我们想要将字符向量中带年份的年全部替换为2019。

```
> sub(pattern = "\\d{4}",replacement = "2019", x = c("This will not match", "2018-04-11, 2017-04-11", "2018-04-12"))
[1] "This will not match"    "2019-04-11, 2017-04-11" "2019-04-12"            
> gsub(pattern = "\\d{4}",replacement = "2019", x = c("This will not match", "2018-04-11, 2017-04-11", "2018-04-12"))
[1] "This will not match"    "2019-04-11, 2019-04-11" "2019-04-12"   
```

要操作的对象第二个元素包含2个可以匹配的模式，使用`sub()`只会将第一个替换为2019，而使用`gsub()`会将所有能够匹配的模式都替换为2019。



## 通过变量创建字符串

### 问题

你想要通过变量创建一个字符串。

### 方案

两种从变量创建字符串的通用方法是使用`paste()`和`sprintf()`函数。对向量来说，`paste`更加有用；`sprintf`则常用于对输出实现精确的控制。

#### 使用paste()

```R
a <- "apple"
b <- "banana"

# 将a,b变量内容连到一起，并用空格隔开
paste(a, b)
#> [1] "apple banana"

# 如果不想要空格，可以设定参数sep="",或使用函数 paste0():
paste(a, b, sep="")
#> [1] "applebanana"
paste0(a, b)
#> [1] "applebanana"

# 用逗号加空格分开:
paste(a, b, sep=", ")
#> [1] "apple, banana"


# 设定一个字符向量
d <- c("fig", "grapefruit", "honeydew")

# 如果输入是一个向量，输出会将其每个元素堆叠到一起：
paste(d, collapse=", ")
#> [1] "fig, grapefruit, honeydew"

# 如果输入是一个标量和一个向量， 结果会将标量与向量里每个元素放到一起
# 并返回一个向量（这是R向量化操作的循环对齐原则）：
paste(a, d)
#> [1] "apple fig"        "apple grapefruit" "apple honeydew"

# 使用 sep 和 collapse参数:
paste(a, d, sep="-", collapse=", ")
#> [1] "apple-fig, apple-grapefruit, apple-honeydew"
```

#### 使用sprintf()

另一种方式是使用`sprintf`函数，它来自于C语言。

想要在字符串或字符变量中进行取代操作，使用`%s`：

```R
a <- "string"
sprintf("This is where a %s goes.", a)
#> [1] "This is where a string goes."
```

如果是整数，可以使用`%d`或它的变体：

```R
x <- 8
sprintf("Regular:%d", x)
#> [1] "Regular:8"

# 可以输出到字符串，以空格开头。
sprintf("Leading spaces:%4d", x)
#> [1] "Leading spaces:   8"

# 也可以使用0替代
sprintf("Leading zeros:%04d", x)
#> [1] "Leading zeros:0008"
```

对浮点数，使用`%f`进行标准释义，而`%e`活着`%E`则代表指数。你也可以使用`%g`或者`%G`让程序自动帮你进行两种格式的转换，这取决于你的有效位数。下面是R help页面中关于sprintf的例子：

```R
sprintf("%f", pi)         # "3.141593"
sprintf("%.3f", pi)       # "3.142"
sprintf("%1.0f", pi)      # "3"
sprintf("%5.1f", pi)      # "  3.1"
sprintf("%05.1f", pi)     # "003.1"
sprintf("%+f", pi)        # "+3.141593"
sprintf("% f", pi)        # " 3.141593"
sprintf("%-10f", pi)      # "3.141593  "   (左对齐)
sprintf("%e", pi)         #"3.141593e+00"
sprintf("%E", pi)         # "3.141593E+00"
sprintf("%g", pi)         # "3.14159"
sprintf("%g",   1e6 * pi) # "3.14159e+06"  (指数化)
sprintf("%.9g", 1e6 * pi) # "3141592.65"   ("修正")
sprintf("%G", 1e-6 * pi)  # "3.14159E-06"
```

在`%m.nf`格式规范中：`m`代表域宽，它是输出字符串中字符的最小位数，可以以空格或0开头。`n`代表精度，它指小数点后的数字位数。

其他混合操作：

```R
x <- "string"
sprintf("Substitute in multiple strings: %s %s", x, "string2")
#> [1] "Substitute in multiple strings: string string2"

# To print a percent sign, use "%%"
sprintf("A single percent sign here %%")
#> [1] "A single percent sign here %"
```

#### 注意

关于更多脚本输出的信息可以查看[this page](http://www.cookbook-r.com/Data_input_and_output/Writing_text_and_output_from_analyses_to_a_file)。