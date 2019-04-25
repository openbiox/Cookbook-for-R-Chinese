## 生成随机数

### 问题

你想要生成随机数。

### 方案

要生成均匀分布的随机数，可以使用`runif()`函数。默认，它的范围是从0到1.

```R
runif(1)
#> [1] 0.09006613

# 得到4个数字的向量
runif(4)
#> [1] 0.6972299 0.9505426 0.8297167 0.9779939

# 得到3个从0到100变化的向量
runif(3, min=0, max=100)
#> [1] 83.702278  3.062253  5.388360

# 得到从0到100变化的整数
# 使用max=101 因为它永远不可能等于101。 这里利用的floor函数是用来向下取整数的
floor(runif(3, min=0, max=101))
#> [1] 11 67  1

# 这个方式的结果一样
sample(1:100, 3, replace=TRUE)
#> [1]  8 63 64

# 生成不可替换（就是不能再取）的整数
sample(1:100, 3, replace=FALSE)
#> [1] 76 25 52
```

要生成服从正态分布的数字，使用`rnorm()`。默认均值是0，标准差是1。

```R
rnorm(4)
#> [1] -2.3308287 -0.9073857 -0.7638332 -0.2193786

# 使用不同的均值和标准差
rnorm(4, mean=50, sd=10)
#> [1] 59.20927 40.12440 44.58840 41.97056

# 为了检查这个分布是否正确，给随机数画直方图
x <- rnorm(400, mean=50, sd=10)
hist(x)
```

### 注意

如果你想要你生成随机数的结果可重复，参看[../Generating repeatable sequences of random numbers](http://www.cookbook-r.com/Numbers/Generating_repeatable_sequences_of_random_numbers)。

## 生成可重复的随机序列

### 问题

你想要生成可重复的随机数序列。

### 方案

使用 `set.seed()`函数，并在括号内放入数字作为种子数。

```R
set.seed(423)
runif(3)
#> [1] 0.1089715 0.5973455 0.9726307

set.seed(423)
runif(3)
#> [1] 0.1089715 0.5973455 0.9726307
```

## 保持随机数生成器的状态

### 问题

你想要保存和回复随机数生成器的状态。

### 方案

将`.Random.seed`保存到其他变量，之后将变量值赋给`.Random.seed`从而恢复原来的值。

```R
# 这个例子中，先设定随机数种子
set.seed(423)
runif(3)
#> [1] 0.1089715 0.5973455 0.9726307

# 保存种子
oldseed <- .Random.seed

runif(3)
#> [1] 0.7973768 0.2278427 0.5189830

# 做其他随机数生成相关的事情，比如:
# runif(30)
# ...
```

```R
# 回复种子
.Random.seed <- oldseed

# 保存种子之后，像之前那样得到相同的随机数
runif(3)
#> [1] 0.7973768 0.2278427 0.5189830
```

如果你之前还没有在R线程中用过随机数生成器，变量`.Random.seed`将会不存在。如果你对此不确定，应当在保存和恢复之前进行检查：

```R
oldseed <- NULL
if (exists(".Random.seed"))
    oldseed <- .Random.seed

# 做一些随机数生成操作，比如：
# runif(30)
# ...

if (!is.null(oldseed))
    .Random.seed <- oldseed
```

#### 在函数中保存和恢复随机数生成器的状态

如果你试图在函数中通过使用 `.Random.seed <- x`来恢复随机数生成器的状态，结果是行不通的，因为这个操作改变的是名为`.Random.seed`的本地变量，而不是全局环境中的这个变量。

这里有两个例子。这些函数想要做的是生成一些随机数，并使得随机数生成器保留未改变的状态。

```R
# 这是个坏的版本
bad_rand_restore <- function() {
    if (exists(".Random.seed"))
        oldseed <- .Random.seed
    else
        oldseed <- NULL

    print(runif(3))

    if (!is.null(oldseed))
        .Random.seed <- oldseed
    else
        rm(".Random.seed")
}


# 这是个好的版本
rand_restore <- function() {
    if (exists(".Random.seed", .GlobalEnv))
        oldseed <- .GlobalEnv$.Random.seed
    else
        oldseed <- NULL

    print(runif(3))

    if (!is.null(oldseed)) 
        .GlobalEnv$.Random.seed <- oldseed
    else
        rm(".Random.seed", envir = .GlobalEnv)
}


# 坏的版本没有合适地重置随机数生成器状态，因此随机数一直在改变
set.seed(423)
bad_rand_restore()
#> [1] 0.1089715 0.5973455 0.9726307
bad_rand_restore()
#> [1] 0.7973768 0.2278427 0.5189830
bad_rand_restore()
#> [1] 0.6929255 0.8104453 0.1019465

# 好的版本每次都正确地重置了随机数生成器的状态，因此随机数可以保持一致
# stay the same.
set.seed(423)
rand_restore()
#> [1] 0.1089715 0.5973455 0.9726307
rand_restore()
#> [1] 0.1089715 0.5973455 0.9726307
rand_restore()
#> [1] 0.1089715 0.5973455 0.9726307
```

#### 注意

使用者最好不要修改`.Random.seed` 变量。

## 对数值取整

### 问题

你想要对数值取整。

### 方案

存在许多中取整的方式：向最近的整数取整、向上或向下取整、或者向0取整。

```R
x <- seq(-2.5, 2.5, by=.5)

# Round to nearest, with .5 values rounded to even number.
round(x)
#>  [1] -2 -2 -2 -1  0  0  0  1  2  2  2

# Round up
ceiling(x)
#>  [1] -2 -2 -1 -1  0  0  1  1  2  2  3

# Round down
floor(x)
#>  [1] -3 -2 -2 -1 -1  0  0  1  1  2  2

# Round toward zero
trunc(x)
#>  [1] -2 -2 -1 -1  0  0  0  1  1  2  2

```

也可以取整到小数位：

```R
x <- c(.001, .07, 1.2, 44.02, 738, 9927) 

# 一位小数取整
round(x, digits=1)
#> [1]    0.0    0.1    1.2   44.0  738.0 9927.0

# 10位取整
round(x, digits=-1)
#> [1]    0    0    0   40  740 9930

# 向最近的5取整
round(x/5)*5
#> [1]    0    0    0   45  740 9925

# 取整到最近的.02
round(x/.02)*.02
#> [1]    0.00    0.08    1.20   44.02  738.00 9927.00
```

## 比较浮点数

### 问题

比较浮点数通常未能如你所想。比如：

```R
0.3 == 3*.1
#> [1] FALSE

(0.1 + 0.1 + 0.1) - 0.3
#> [1] 5.551115e-17

x <- seq(0, 1, by=.1)
x
#>  [1] 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0

10*x - round(10*x)
#>  [1] 0.000000e+00 0.000000e+00 0.000000e+00 4.440892e-16 0.000000e+00 0.000000e+00
#>  [7] 8.881784e-16 8.881784e-16 0.000000e+00 0.000000e+00 0.000000e+00

```

### 方案

不存在通用的解决方案，因为这个问题通常是由于非整数（浮点数）在计算机和R中的存储方式所导致的（数据都是以二进制存储在计算机的数据单元中，整数与浮点数的方式应该是存在差异的，整数好像一般是以反码的形式存储，浮点数机制略有不同吧，忘记了～有兴趣的小伙伴下方解释一下哇）。

可以通过网址<http://www.mathworks.com/support/tech-notes/1100/1108.html>查阅更多信息。 虽然里面使用Matlab代码写的，但是基本与R是一致的。