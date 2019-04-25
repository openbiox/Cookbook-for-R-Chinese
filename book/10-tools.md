# 工具

## 生成拉丁方

### 问题

你想要生成平衡序列用于实验。

### 方案

函数 `latinsquare()` (在下方定义) 可以被用来生成[拉丁方](https://baike.baidu.com/item/%E6%8B%89%E4%B8%81%E6%96%B9%E8%AE%BE%E8%AE%A1/8707472)。

```R
latinsquare(4)
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    2    4    3
#> [2,]    2    1    3    4
#> [3,]    3    4    1    2
#> [4,]    4    3    2    1


# 生成两个大小为 4 的拉丁方(按顺序排列)
latinsquare(4, reps=2)
#>      [,1] [,2] [,3] [,4]
#> [1,]    3    4    1    2
#> [2,]    4    3    2    1
#> [3,]    1    2    4    3
#> [4,]    2    1    3    4
#> [5,]    4    2    1    3
#> [6,]    2    3    4    1
#> [7,]    1    4    3    2
#> [8,]    3    1    2    4


# 在调用该函数时最好加入一个随机种子 (random seed)，这样可以使得生成的拉丁方具有可重复性。 
# 如下所示，这样做每次都会得到同一序列的拉丁方。
latinsquare(4, reps=2, seed=5873)
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    4    2    3
#> [2,]    4    1    3    2
#> [3,]    2    3    4    1
#> [4,]    3    2    1    4
#> [5,]    3    2    4    1
#> [6,]    1    4    2    3
#> [7,]    4    3    1    2
#> [8,]    2    1    3    4

```

存在大小为 4 的 576 个拉丁方。函数 `latinsquare` 会随机选择其中 `n` 个并以序列形式返回它们。这被称为**重复拉丁方设计** 。

一旦你生成了自己的拉丁方，你需要进行检查确保不存在许多重复的序列，因为这中情况在小型拉丁方中非常普遍 (3x3 or 4x4)。

#### 生成拉丁方的函数

这个函数一定程度上使用了[暴力算法(brute-force algorithm)](http://www-igm.univ-mlv.fr/~lecroq/string/node3.html)来生成每个拉丁方，有时候它会因为没有可用的数字放入给定的位置而失败。这种情况下，它会再做尝试。可能存在一种更好的办法吧，但我并不清楚。

```R
## - len 指定的是拉丁方的大小
## - reps 是拉丁方的重复数-即给出多少个拉丁方
## - seed 指的是给定一个随机种子，这样可以保证生成的拉丁方是可重复的。
## - returnstrings 告诉函数为每个拉丁方返回一个字符串向量而不是返回一个巨大的矩阵，这个参数是用来检查生成拉丁方随机性的一个可选项。  
latinsquare <- function(len, reps=1, seed=NA, returnstrings=FALSE) {

    # 保存旧的随机种子并使用新的（如果有）
    if (!is.na(seed)) {
        if (exists(".Random.seed"))  { saved.seed <- .Random.seed }
        else                         { saved.seed <- NA }
        set.seed(seed)
    }
    
    # 这个矩阵包含了全部独立的拉丁方
    allsq <- matrix(nrow=reps*len, ncol=len)
    
    # 如果需要，为每个拉丁方阵储存一个字符串 id 
    if (returnstrings) {  squareid <- vector(mode = "character", length = reps) }

    # Get a random element from a vector (the built-in sample function annoyingly
    #   has different behavior if there's only one element in x)
    sample1 <- function(x) {
        if (length(x)==1) { return(x) }
        else              { return(sample(x,1)) }
    }
    
    # 生成 n 个独立的拉丁方阵
    for (n in 1:reps) {

        # Generate an empty square
        sq <- matrix(nrow=len, ncol=len) 

        # If we fill the square sequentially from top left, some latin squares
        # are more probable than others.  So we have to do it random order,
        # all over the square.
        # The rough procedure is:
        # - randomly select a cell that is currently NA (call it the target cell)
        # - find all the NA cells sharing the same row or column as the target
        # - fill the target cell
        # - fill the other cells sharing the row/col
        # - If it ever is impossible to fill a cell because all the numbers
        #    are already used, then quit and start over with a new square.
        # In short, it picks a random empty cell, fills it, then fills in the 
        # other empty cells in the "cross" in random order. If we went totally randomly
        # (without the cross), the failure rate is much higher.
        while (any(is.na(sq))) {

            # 随机选择一个当前值为 NA （缺失值）的单元格
            k <- sample1(which(is.na(sq)))
            
            i <- (k-1) %% len +1       # Get the row num
            j <- floor((k-1) / len) +1 # Get the col num
            
            # 在以 i,j 为中心的“交叉点”中找到其他为 NA 的单元格
            sqrow <- sq[i,]
            sqcol <- sq[,j]

            # 一个包含了所有 NA 单元格坐标的矩阵
            openCell <-rbind( cbind(which(is.na(sqcol)), j),
                              cbind(i, which(is.na(sqrow))))
            # 随机化填充顺序
            openCell <- openCell[sample(nrow(openCell)),]
            
            # Put center cell at top of list, so that it gets filled first
            openCell <- rbind(c(i,j), openCell)
            # There will now be three entries for the center cell, so remove duplicated entries
            # Need to make sure it's a matrix -- otherwise, if there's just 
            # one row, it turns into a vector, which causes problems
            openCell <- matrix(openCell[!duplicated(openCell),], ncol=2)

            # Fill in the center of the cross, then the other open spaces in the cross
            for (c in 1:nrow(openCell)) {
                # The current cell to fill
                ci <- openCell[c,1]
                cj <- openCell[c,2]
                # Get the numbers that are unused in the "cross" centered on i,j
                freeNum <- which(!(1:len %in% c(sq[ci,], sq[,cj])))

                # Fill in this location on the square
                if (length(freeNum)>0) { sq[ci,cj] <- sample1(freeNum) }
                else  {
                    # Failed attempt - no available numbers
                    # Re-generate empty square
                    sq <- matrix(nrow=len, ncol=len)

                    # Break out of loop
                    break;
                }
            }
        }
        
        # Store the individual square into the matrix containing all squares
        allsqrows <- ((n-1)*len) + 1:len
        allsq[allsqrows,] <- sq
        
        # Store a string representation of the square if requested. Each unique
        # square has a unique string.
        if (returnstrings) { squareid[n] <- paste(sq, collapse="") }

    }

    # Restore the old random seed, if present
    if (!is.na(seed) && !is.na(saved.seed)) { .Random.seed <- saved.seed }

    if (returnstrings) { return(squareid) }
    else               { return(allsq) }
}

```

#### 检查函数的随机性

一些生成拉丁方的算法并不是非常的随机。`4x4` 的拉丁方有 576 种，它们每一种都应该有相等的概率被生成，但一些算法没有做到。可能我们没有必要检查上面的函数，但这里确实有办法可以做到这一点。前面我使用的算法并没有好的随机分布，我们运行下面的代码可以发现这一点。

这个代码创建 10,000 个 `4x4` 的拉丁方，然后计算这 576 个唯一拉丁方出现的频数。计数结果应该形成一个不是特别宽的正态分布；否则这个分布就不是很随机了。我相信期望的标准差是根号(10000/576)（假设随机生成拉丁方）。

```R
# Set up the size and number of squares to generate
squaresize    <- 4
numsquares    <- 10000

# Get number of unique squares of a given size.
# There is not a general solution to finding the number of unique nxn squares
# so we just hard-code the values here. (From http://oeis.org/A002860)
uniquesquares <- c(1, 2, 12, 576, 161280, 812851200)[squaresize]

# Generate the squares
s <- latinsquare(squaresize, numsquares, seed=122, returnstrings=TRUE)

# Get the list of all squares and counts for each
slist   <- rle(sort(s))
scounts <- slist[[1]]

hist(scounts, breaks=(min(scounts):(max(scounts)+1)-.5))
cat(sprintf("Expected and actual standard deviation: %.4f, %.4f\n",
              sqrt(numsquares/uniquesquares), sd(scounts) ))
#> Expected and actual standard deviation: 4.1667, 4.0883
```

![img](http://upload-images.jianshu.io/upload_images/3884693-b79269fb8d324316.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
