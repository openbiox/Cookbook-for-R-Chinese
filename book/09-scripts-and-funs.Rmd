# 脚本与函数

## 创建和运行一个脚本

计算细菌基因组核心蛋白相似性

- 应用场景：

细菌分类学研究中，需要借助基因组水平的相似度来界定是否属于新物种，是否是一个未发现的新属水平或者新科水平，乃至更高的分类学单元（界门纲目科属种）。

在基因组的核酸水平研究中，有诸如dDDH（数字化DNA分子杂交）、核苷酸平均相似度（Average Nucleotide Identity，ANI）等指标来界定是否属于新物种；而在基因组蛋白质水平相类似的指标较少，比如氨基酸平均相似度（Average Amino acid Identity，AAI）和保守蛋白比率（percentage of conserved proteins，POCP）等。

- 简要过程：

两两比对细菌基因组的蛋白序列，互为参考数据库进行 blastp 比对（A作数据库，B查询；B作数据库，A查询），数据筛选的标准是：一致度大于40%，查询片段的长度大于原片段长度的50%，e值小于1e-5。

### 参考文献：

[A Proposed Genus Boundary for the Prokaryotes Based on Genomic Insights](https://jb.asm.org/content/196/12/2210)

Qi-Long Qin *et al.*

```R
# 下载所分析的基因组数据（蛋白序列）
# 存放于 Rawdata 文件夹中
if (!dir.exists('Rawdata')) {
  dir.create('Rawdata')
}

# 示例-1: Pseudomonas aeruginosa
# ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/765/GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_protein.faa.gz

# 示例-2: Acinetobacter baumannii
# ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/746/645/GCF_000746645.1_ASM74664v1/GCF_000746645.1_ASM74664v1_protein.faa.gz

# 使用 R.utils 中的 gunzip 解压缩
library(R.utils)

download.file("ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/765/GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_protein.faa.gz",
              destfile = "Rawdata/Pseudomonas_aeruginosa.faa.gz")
gunzip("Rawdata/Pseudomonas_aeruginosa.faa.gz")

download.file("ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/746/645/GCF_000746645.1_ASM74664v1/GCF_000746645.1_ASM74664v1_protein.faa.gz",
              destfile = "Rawdata/Acinetobacter_baumannii.faa.gz")
gunzip("Rawdata/Acinetobacter_baumannii.faa.gz")
```

```R
# 使用 dbplyr 对数据框中的某列去重复
library(dbplyr)
# 使用 seqinr 格式化fasta格式的序列
library(seqinr)

# 检查存放中间过程文件的文件夹是否存在
if (!dir.exists('Database')) {
  dir.create('Database')
}

if (!dir.exists('Result')) {
  dir.create('Result')
}

# 获取所有待分析基因组文件名
genome.files <- list.files('Rawdata')

# 对所有的待分析基因组建库
for (gn in genome.files) {
  header.file <- strsplit(gn,'.',fixed = T)[[1]][1]
  commond.makedb <- paste0('diamond.exe makedb --in Rawdata/',
                           gn, ' --db Database/', header.file)
  system(commond.makedb)
}

# 获取多基因组的两两比对的组合数据集
genome.comn <- combn(genome.files,2)

# 计算核心蛋白相似性的骨架命令
blast.comm1 <- 'diamond.exe blastp -q Rawdata/'
blast.comm2 <- ' -d Database/'
blast.comm3 <- ' -e 1e-5 --id 40 -o Result/'

# 建立新变量，保存运算结果
pocp.vector <- c()

for (i in (1:dim(genome.comn)[2]) ) {
  a.genome <- genome.comn[,i][1]
  b.genome <- genome.comn[,i][2]

  a.header <- strsplit(a.genome,'.',fixed = T)[[1]][1]
  b.header <- strsplit(b.genome,'.',fixed = T)[[1]][1]

  a.genome.seq <- read.fasta(paste0('Rawdata/', a.genome),'AA')
  b.genome.seq <- read.fasta(paste0('Rawdata/', b.genome),'AA')

  a.total <- length(a.genome.seq)
  b.total <- length(b.genome.seq)

  str(a.genome.seq)
  str(b.genome.seq)

  a.seq.list <- names(a.genome.seq)
  b.seq.list <- names(b.genome.seq)
  a.seq.length <- c()

  for (nm in a.seq.list) {
    tmp.len <- length(a.genome.seq[[which(a.seq.list == nm)]])
    a.seq.length <- append(a.seq.length, tmp.len)
  }
  b.seq.length <- c()

  for (nm in b.seq.list) {
    tmp.len <- length(b.genome.seq[[which(b.seq.list == nm)]])
    b.seq.length <- append(b.seq.length, tmp.len)
  }

  a.seq.df <- data.frame(a.seq.list, a.seq.length)
  colnames(a.seq.df) <- c('V1','length')
  b.seq.df <- data.frame(b.seq.list, b.seq.length)
  colnames(b.seq.df) <- c('V1','length')

  print(paste0('-- Blasting: ',a.header,' - VS - ',b.header))

  # “正向”--A为查询，B为参考数据库
  result.forward <- paste0(a.header,'_VS_',b.header,'.tab')
  system(paste0(blast.comm1, a.genome,
                blast.comm2, b.header,
                blast.comm3, result.forward))
  df.forward <- read.table(paste0('Result/',result.forward),
                           header = F,sep = '\t',
                           stringsAsFactors = F)
  df.forward <- df.forward  %>%  distinct(V1,.keep_all = T)
  df.forward <- merge(df.forward, a.seq.df, by = 'V1', all.x = T)
  df.forward$align <- df.forward$V4 / df.forward$length
  df.forward <- df.forward[which(df.forward$V3 > 40 & df.forward$align > 0.5 & df.forward$V11 < 1e-5),]
  C1 <- dim(df.forward)[1]

  # “反向”--B为查询，A为参考数据库
  result.backward <- paste0(b.header,'_VS_',a.header,'.tab')
  system(paste0(blast.comm1, b.genome,
                blast.comm2, a.header,
                blast.comm3, result.backward))
  df.backward <- read.table(paste0('Result/',result.backward),
                           header = F,sep = '\t',
                           stringsAsFactors = F)
  df.backward <- df.backward %>% distinct(V1,.keep_all = T)
  df.backward <- merge(df.backward, b.seq.df, by = 'V1', all.x = T)
  df.backward$align <- df.backward$V4 / df.backward$length
  df.backward <- df.backward[which(df.backward$V3 > 40 & df.backward$align > 0.5 & df.backward$V11 < 1e-5),]
  C2 <- dim(df.backward)[1]

  pocp <- (C1 + C2)/(a.total + b.total)
  pocp.vector <- append(pocp.vector, paste0(a.header,'\t',b.header,'\t',pocp))

  print(paste0('-- Pair blast done: ',a.header,' - VS - ',b.header))
  print(paste0('-- The POCP : ', pocp))
  print('----------------------------------')
}

write(pocp.vector, 'resultPOCP.txt')

# 删除分析过程中的冗余文件
unlink("Database", recursive = TRUE)
unlink("Result", recursive = TRUE)

# 重新创建新文件夹
dir.create('Database')
dir.create('Result')

```

#### 提示：

更多关于POCP计算的相关tips，请点击[这里-跳转](https://github.com/2015qyliang/POCP)

## 调试脚本或函数

### 问题

您想要调试脚本或函数。

### 方案

将其插入您要开始调试的位置的代码中：

```R
browser()
```
当R解释器到达该行时，它将暂停您的代码，您将能够查看和更改变量。

在浏览器中，键入这些字母将执行以下操作
	
|c  | 继续 |
| :------------- | :------------- |
| **n (or Return)** |  **下一步** |
| **Q** | **放弃** |
| **Ctrl-C** | **回到顶级**|

在浏览器中，您可以看到当前范围中的变量。

```R
ls()
```
要为函数中的每一行暂停和启动浏览器

```R
debug(myfunction)
myfunction(x)
```
### **有用的选择**
默认情况下，每次在浏览器提示符下按Enter键，它都会运行下一步。这相当于按n，然后按Enter键。这可能很烦人。要禁用它，请使用：

```R
options(browserNLdisabled=TRUE)
```
要在抛出错误时开始调试，请在抛出错误的函数之前运行此命令

```R
options(error=recover)
```
如果您希望每次启动R时都设置这些选项，则可以将它们放在~/.Rprofile文件中。


## 测量经过的时间
### **问题**
您想要测量运行特定代码块所需的时间。
### 方案
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


## 获取包中的函数和对象列表

### 问题

你想知道包里有什么。

### 方案

此代码段将列出包中的函数和对象。

```R
# Using search() in a new R session says that these packages are 
# loaded by default:
# "package:stats"     "package:graphics" 
# "package:grDevices" "package:utils"     "package:datasets" 
# "package:methods"   "package:base"  

# Others that are useful:
# gplots
# ggplot2, reshape, plyr

showPackageContents <- function (packageName) {

    # Get a list of things contained in a particular package
    funlist <- objects(packageName)

    # Remove things that don't start with a letter
    idx <- grep('^[a-zA-Z][a-zA-Z0-9._]*', funlist)
    funlist <- funlist[idx]

    # Remove things that contain arrow <-
    idx <- grep('<-', funlist)
    if (length(idx)!=0)
        funlist <- funlist[-idx]

    # Make a data frame to keep track of status
    objectlist <- data.frame(name=funlist,
                             primitive=FALSE,
                             func=FALSE,
                             object=FALSE,
                             constant=FALSE,
                             stringsAsFactors=F)

    for (i in 1:nrow(objectlist)) {
        fname <- objectlist$name[i]
        if (exists(fname)) {
            obj <- get(fname)
            if (is.primitive(obj)) {
                objectlist$primitive[i] <- TRUE
            }
            if (is.function(obj)) {
                objectlist$func[i] <- TRUE
            }
            if (is.object(obj)) {
                objectlist$object[i] <- TRUE
            }
            
            # I think these are generally constants
            if (is.vector(obj)) {
                objectlist$constant[i] <- TRUE
            }
           
        
        }  
    }

    cat(packageName)
        
    cat("\n================================================\n")
    cat("Primitive functions: \n")
    cat(objectlist$name[objectlist$primitive])
    cat("\n")

    cat("\n================================================\n")
    cat("Non-primitive functions: \n")
    cat(objectlist$name[objectlist$func  &  !objectlist$primitive])
    cat("\n")

    cat("\n================================================\n")
    cat("Constants: \n")
    cat(objectlist$name[objectlist$constant])
    cat("\n")

    cat("\n================================================\n")
    cat("Objects: \n")
    cat(objectlist$name[objectlist$object])
    cat("\n")
}


# Run the function using base package
showPackageContents("package:base")
```

