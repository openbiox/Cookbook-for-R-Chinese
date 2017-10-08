# Data input and output-用R把数据写入文件

## 问题

你想把数据写入一个文件。

## 方案

### 写到有分隔符的文本文件

最简单的方式是用`write.csv()`。默认情况下，`write.csv()`包含行名，但是这通常没必要，而且可能会导致混乱。

```R
# 一个简单的例子
data <- read.table(header=TRUE, text='
 subject sex size
       1   M    7
       2   F    NA
       3   F    9
       4   M   11
 ')

# 写入到文件，不显示行名
write.csv(data, "data.csv", row.names=FALSE)

# 替代“NA”，输出空格
write.csv(data, "data.csv", row.names=FALSE, na="")

# 用制表位可以不显示行&列名
write.table(data, "data.csv", sep="\t", row.names=FALSE, col.names=FALSE) 
```

### R保存的数据格式

`write.csv()`和`write.table()`是最适合与其他数据分析程序交互操作的函数。然而，他们不会保持数据结构的特殊属性，如：列是否是一个字符类型或因子，或因子的水平的顺序。为了做到这一点，它本该在R中被写成一个特殊的格式。

下面是三种主要的方法：

第一个方法是输出R源代码，运行时，将重新创建该对象。这应该对大多数数据对象有用，但它可能无法专一地重现一些较为复杂的数据对象。

```R
# 保存在一个能容易被R载入的文本文件中
dump("data", "data.Rdmpd")
# 能保存多个对象
dump(c("data", "data1"), "data.Rdmpd")

# 再次加载数据
source("data.Rdmpd")
# 载入时，原始的数据名称将被自动使用
```

另一个方法是，在RDS格式中写入的个人数据对象。这种格式可以是二进制或ASCII。二进制更紧凑，而ASCII将与版本控制系统更有效率，如Git。

```R
# 在二进制RDS格式中保存一个简单的对象
saveRDS(data, "data.rds")
# 或，使用ASCII格式
saveRDS(data, "data.rds", ascii=TRUE)

# 再次载入:
data <- readRDS("data.rds")
```

也可以将多个对象保存到一个单一的文件，使用RData格式。

```R
# 在二进制RData格式中保存多个对象
save(data, file="data.RData")
# 或，使用ASCII格式
save(data, file="data.RData", ascii=TRUE)
# 可以保存多个对象
save(data, data1, file="data.RData")

# 再次载入:
load("data.RData")
```

`saveRDS()`和`save()`一个重要的区别是，使用前者，当你用`readRDS()`读取数据，你指定对象的名称；使用后者，当你用`load()`载入数据，会自动使用原来的对象名称。自动使用原始对象名称有时可以简化工作流程，但如果数据对象在不同的环境中使用时，也会成为一个缺点。

***

原文链接：http://www.cookbook-r.com/Data_input_and_output/Writing_data_to_a_file/