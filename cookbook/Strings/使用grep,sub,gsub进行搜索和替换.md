# 在字符串中进行文本搜索和替换

## 问题

你想要搜索或替换字符串中特定的文本。

## 方案

有两个常用字符串搜索函数`grep()`和`grepl()`。有两个常用的字符串替换函数`sub()`和`gsub()`。它们都是向量化的操作，会应用到输入字符向量的每一个元素上。

### 文本搜索

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

### 文本替换

大部分情况下我们不仅仅想搜索到文本，而且还想要在搜索的基础上进行替换，这可以通过`sub()`和`gsub()`函数实现。这两个函数参数是一样的，第一个参数是搜索的模式，第二个参数是替换的模式，第三个参数是要操作的字符向量。两个函数的区别是前者只会替换字符串中第一个匹配的模式，而`gsub()`（`g`是`global`的缩写）会替换字符串中所有匹配的模式。

例如，我们想要将字符向量中带年份的年全部替换为2019。

```
> sub(pattern = "\\d{4}",replacement = "2019", x = c("This will not match", "2018-04-11, 2017-04-11", "2018-04-12"))
[1] "This will not match"    "2019-04-11, 2017-04-11" "2019-04-12"            
> gsub(pattern = "\\d{4}",replacement = "2019", x = c("This will not match", "2018-04-11, 2017-04-11", "2018-04-12"))
[1] "This will not match"    "2019-04-11, 2019-04-11" "2019-04-12"   
```

要操作的对象第二个元素包含2个可以匹配的模式，使用`sub()`只会将第一个替换为2019，而使用`gsub()`会将所有能够匹配的模式都替换为2019。


## 测量经过的时间

### 问题

您想要测量运行特定代码块所需的时间。

### 解决

该```system.time()```函数将测量在R中运行某些东西所需的时间。

```R
system.time({
    # Do something that takes time
    x <- 1:100000
    for (i in seq_along(x))  x[i] <- x[i]+1
})
#>    user  system elapsed 
#>   0.144   0.002   0.153

```
输出意味着运行代码块需要0.153秒。


