# R载入文件中的数据

## 问题

你想从文件中载入数据。

## 方案

### 带分隔符的文本文件

最简单的输入数据的方式就是将其保存为带分隔符（如：制表位或逗号）的文本文件。

```R
data <- read.csv("datafile.csv")

# 导入一个没有表头的CSV文件
data <- read.csv("datafile-noheader.csv", header=FALSE)
```

函数`read.table()`是一个更为普遍的函数，允许你设置分隔符，不管是否有表头，不管字符串是否有引号，等等。使用`?read.table`查看更多详细信息。

```R
data <- read.table("datafile-noheader.csv",
                   header=FALSE,
                   sep=","         # 制表位分隔的文件用"\t"
)
```

### 打开文件的文件选择器

某些平台，使用`file.choose()`可以打开文件选择的对话窗口；其他平台则会提示用户输入一个文件名。

```R
data <- read.csv(file.choose())
```

### 把字符串看作因子（factor）或字符（character）

默认条件下，数据中的字符串都被转换为因子。如果你用`read.csv()`载入数据，所有的文本列都会被视为因子，即便它被处理为字符串更有意义。要这么做，使用 `stringsAsFactors=FALSE`:

```R
data <- read.csv("datafile.csv", stringsAsFactors=FALSE)

# 将某一列转化为因子
data$Sex <- factor(data$Sex)
```

另一种将他们加载为因子，把某一列转换为字符的方法：

```R
data <- read.csv("datafile.csv")

data$First <- as.character(data$First)
data$Last  <- as.character(data$Last)

# 另一种方法：转化名为“First”和“Last”的两列
stringcols <- c("First","Last")
data[stringcols] <- lapply(data[stringcols], as.character)
```

### 从网上导入文件

也可以从URL加载数据。这些(很长的)URL可以加载相关文件。

```R
data <- read.csv("http://www.cookbook-r.com/Data_input_and_output/Loading_data_from_a_file/datafile.csv")


# 读取没有表头的CSV文件
data <- read.csv("http://www.cookbook-r.com/Data_input_and_output/Loading_data_from_a_file/datafile-noheader.csv", header=FALSE)

# 手动添加表头
names(data) <- c("First","Last","Sex","Number")
```

上述所使用的数据文件：

[datafile.csv](http://www.cookbook-r.com/Data_input_and_output/Loading_data_from_a_file/datafile.csv)：

```R
"First","Last","Sex","Number"
"Currer","Bell","F",2
"Dr.","Seuss","M",49
"","Student",NA,21
```

[datafile-noheader.csv](http://www.cookbook-r.com/Data_input_and_output/Loading_data_from_a_file/datafile-noheader.csv):

```R
"Currer","Bell","F",2
"Dr.","Seuss","M",49
"","Student",NA,21
```

### 定宽文本文件

假如你的数据列宽固定，如下例：

```R
  First     Last  Sex Number
 Currer     Bell    F      2
    Dr.    Seuss    M     49
    ""   Student   NA     21
```

读取这种数据的一种方式是简单地使用`read.table()`函数`strip.white=TRUE`，可以清除额外的空格。

```R
read.table("clipboard", header=TRUE, strip.white=TRUE)
```

然而，你的数据文件可能包含空间列，或列没有空格分开，这样，scores列表示六个不同的测量值，每一个从0到3。

```R
subject  sex  scores
   N  1    M  113311
   NE 2    F  112231
   S  3    F  111221
   W  4    M  011002
```

这种情况，你可能需要使用`read.fwf()`函数。如果你读的列名来自于文件，它要求他们用分隔符（如：制表位，空格，逗号）分开。如果有多个空格分开将他们分开，如下例，你需要直接指定列的名称。

```R
# 指定列的名称
read.fwf("myfile.txt", 
         c(7,5,-2,1,1,1,1,1,1), # 列的宽度，-2意味着放弃这些列
         skip=1,                # 跳过第一行（包括表头）
         col.names=c("subject","sex","s1","s2","s3","s4","s5","s6"),
         strip.white=TRUE)      # 跳过每个数据的前导和尾随
#>   subject sex s1 s2 s3 s4 s5 s6
#> 1    N  1   M  1  1  3  3  1  1
#> 2    NE 2   F  1  1  2  2  3  1
#> 3    S  3   F  1  1  1  2  2  1
#> 4    W  4   M  0  1  1  0  0  2
# subject sex s1 s2 s3 s4 s5 s6
#    N  1   M  1  1  3  3  1  1
#    NE 2   F  1  1  2  2  3  1
#    S  3   F  1  1  1  2  2  1
#    W  4   M  0  1  1  0  0  2

# 如果第一行如下：
# subject,sex,scores
# 我们可以使用header=TRUE
read.fwf("myfile.txt", c(7,5,-2,1,1,1,1,1,1), header=TRUE, strip.white=TRUE)
#> Error in read.table(file = FILE, header = header, sep = sep, row.names = row.names, : more columns than column names
# 错误：列比例名多
```

### Excel文件

`gdata`包里的`read.xls`函数可以读取Excel文件。

```R
library(gdata)
data <- read.xls("data.xls")
```

`gdata`包，见<http://cran.r-project.org/doc/manuals/R-data.html#Reading-Excel-spreadsheets>.

包的安装，见[Basics-安装和使用R包](http://www.jianshu.com/p/51d9a18117ee)

### SPSS数据

`foreign`包里的`read.spss`函数可以读取SPSS文件。

```R
library(foreign)
data <- read.spss("data.sav", to.data.frame=TRUE)
```

***

原文链接：http://www.cookbook-r.com/Data_input_and_output/Loading_data_from_a_file/
