# Data input and output-键盘和剪贴板把数据载入并保存到R

## 问题

你想用键盘输入数据，而不是从文件中载入。

## 方案

### 数据输入

假如您的数据如下：

```R
size weight cost
  small      5    6
 medium      8   10
  large     11    9
```

#### 键盘输入或从剪贴板载入数据

从键盘上输入的方法之一是从标准输入读取（`stdin()`）。

```R
# 使用read.table和stdin()剪切和粘贴
data <- read.table(stdin(), header=TRUE) 
# 系统将提示您输入:在这复制和粘贴文本

# 或者：
# data <- read.csv(stdin())
```

你也可以直接从剪贴板载入：

```R
# 首先将数据复制到剪贴板
data <- read.table('clipboard', header=TRUE)

# 或者：
# data <- read.csv('clipboard')
```

#### 在脚本中载入数据

前面的方法不能用来加载脚本文件中的数据，因为输入必须被键入(或粘贴)在运行该命令之后。

```R
# 使用read.table()
data <- read.table(header=TRUE, text='
    size weight cost
   small      5    6
  medium      8   10
   large     11    9
 ')
```

不同的数据格式(如：以逗号分隔，没有表头，等等)，选择`read.table()`可以设置。

见../ [Data input and output-R载入文件中的数据](http://www.jianshu.com/p/2a3f55ef4188)查看更多信息。

### 数据输出

默认情况下，R打印行名称。如果你想打印表的格式，可以复制粘贴，可能很有用。

```R
print(data, row.names=FALSE)
#>    size weight cost
#>   small      5    6
#>  medium      8   10
#>   large     11    9
```

#### 写入可以复制粘贴或粘贴到剪贴板的数据

可以写带分隔符数据终端（`stdout()`），这样它就可以被复制粘贴到其他地方，也可以直接写入到剪贴板。

```R
write.csv(data, stdout(), row.names=FALSE)
# "size","weight","cost"
# "small",5,6
# "medium",8,10
# "large",11,9


# 写到剪贴板(不支持Mac或Unix)
write.csv(data, 'clipboard', row.names=FALSE)
```

#### 输出R的载入

如果数据已经加载到R，可以使用`dput()`保存数据。从`dput()`的输出是创建数据结构的一个命令。这种方法的优点是，它可以保持任何数据类型的修改。举个例子，如果有一列数据，包含数字和你已经转换好的因子，这种方法将保留该类型，而简单地加载文本表格（如上所示）将把它处理为数字。

```R
# 假如你已经载入数据

dput(data)
#> structure(list(size = structure(c(3L, 2L, 1L), .Label = c("large", 
#> "medium", "small"), class = "factor"), weight = c(5L, 8L, 11L
#> ), cost = c(6L, 10L, 9L)), .Names = c("size", "weight", "cost"
#> ), class = "data.frame", row.names = c(NA, -3L))

# 之后，我们可以使用dput输出，重新创建数据结构
newdata <- structure(list(size = structure(c(3L, 2L, 1L), .Label = c("large", 
  "medium", "small"), class = "factor"), weight = c(5L, 8L, 11L
  ), cost = c(6L, 10L, 9L)), .Names = c("size", "weight", "cost"
  ), class = "data.frame", row.names = c(NA, -3L))
```

***

原文链接：http://www.cookbook-r.com/Data_input_and_output/Loading_and_storing_data_with_the_keyboard_and_clipboard/