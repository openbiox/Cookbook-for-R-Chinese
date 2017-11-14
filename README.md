# Cookbook for R Chinese
更新日期：2017-10-31

## 缘起

最近在网上搜寻一些分析的解决方案时，发现了<http://www.cookbook-r.com/>这个网站。作者非常的Nice，免费提供了R的基础知识和较为高级的数据处理、统计分析方法。最对我口味的是，它对于知识点的讲解是从问题出发的，提供了可执行的解决方案。它不仅像一本技术书籍，满足对R的学习和进阶需求；又像是一本字典，可以按章查询解决方案，有独立的示范代码，可操作性很强。

作者在网站上介绍：

> Welcome to the Cookbook for R. The goal of the cookbook is to provide **solutions to common tasks and problems in analyzing data**.

有兴趣的朋友可以通过搜索引擎下载或到相关网站购买**R Cookbook**这本书。

![R Cookbook](http://upload-images.jianshu.io/upload_images/3884693-07fda8b56a858e86.gif?imageMogr2/auto-orient/strip)

我是从《R实战》这本书入门的R，书中的要点我基本都看过并键入过代码，虽然是一本非常不错的R书籍，内容也是从入门到进阶循序渐进，但是其内容不够系统（对R的讲解不够细致），有的内容颇显累赘（因为要照顾不同学科背景人士的任务和实战需求）。

在百度上略微查过，**Cookbook for R**的中文相关资料和介绍很少，貌似有中文版，但是只闻其声，未见其面。为了传播和分享好的知识，我计划对网站<http://www.cookbook-r.com/>进行翻译。

翻译整理后将统一收录在Github资源目录<https://github.com/ShixiangWang/Cookbook-for-R-Chinese>中，欢迎大家查看、编辑与分享。

### 文内跳转

[文档结构](#结构)

[版权](#版权与参与编辑)

[参与](#版权与参与编辑)

[贡献列表](#贡献列表)

## 结构

**章节目录如下**：

1. [基础](http://www.cookbook-r.com/Basics/)
   1. R环境
      1. [**安装和使用R包**](http://www.jianshu.com/p/51d9a18117ee)
   2. R语言基础
      1. [**数据结构的索引**](http://www.jianshu.com/p/3bb2489f7c6f)
      2. [**获取数据结构的子集**](http://www.jianshu.com/p/89485084c62c)
      3. [**创造填满值的向量**](http://www.jianshu.com/p/b55f8083763c)
      4. [**变量信息**](http://www.jianshu.com/p/3b7cb74c03e8)
      5. [**NULL, NA, NaN的处理**](http://www.jianshu.com/p/e8f72888f48c)
2. [数值](http://www.cookbook-r.com/Numbers)
   1. [**生成随机数**](http://www.jianshu.com/p/5fe992779356)
   2. [**生成可重复的随机序列**](http://www.jianshu.com/p/25a12a5a6e45)
   3. [**保存随机数生成器的状态**](http://www.jianshu.com/p/5883212224f5)
   4. [**对数值取整**](http://www.jianshu.com/p/83b002347abc)
   5. [**比较浮点数**](http://www.jianshu.com/p/7967e32e987a)
3. [字符串](http://www.cookbook-r.com/Strings)
   1. 使用grep,sub,gsub进行搜索和替换
   2. [**通过变量创建字符串**](http://www.jianshu.com/p/b61ec4ee1d2a)
4. [公式](http://www.cookbook-r.com/Formulas)
   1. [**通过字符串创建公式**](http://www.jianshu.com/p/4ddfe1e60057)
   2. [**从公式中提取组分**](http://www.jianshu.com/p/0c059cd1b472)
5. [数据输入和输出](http://www.cookbook-r.com/Data_input_and_output)
   1. [**从文件中载入数据**](http://www.jianshu.com/p/2a3f55ef4188)
   2. [**从键盘和剪贴板载入和保存数据**](http://www.jianshu.com/p/c2c7bfd7166f)
   3. [**运行脚本**](http://www.jianshu.com/p/89e22d34cf16)
   4. [**将数据写入文件**](http://www.jianshu.com/p/56c292898f57)
   5. [**将分析结果写入文件**](http://www.jianshu.com/p/f8d2f173cadc)
6. [数据操作](http://www.cookbook-r.com/Manipulating_data)
   1. 通用
      1. [**排序**](http://www.jianshu.com/p/e2055007b767)
      2. [**随机化顺序**](http://www.jianshu.com/p/5c48351d0f20)
      3. [**转换向量类型——数值向量，字符串向量和因子向量**](http://www.jianshu.com/p/8add5dc6d9ae)
      4. [**寻找和移除重复记录**](http://www.jianshu.com/p/82ed2e4dac58)
      5. [**比较带NA值的向量或因子**](http://www.jianshu.com/p/48488400dcaf)
      6. [**重编码数据**](http://www.jianshu.com/p/949e31708f6b)
      7. [**映射向量值——将向量中所有值为x的实例改为值y**](http://www.jianshu.com/p/9bbf71e524b5)
   2. 因子
      1. [**重命名因子水平**](http://www.jianshu.com/p/fbbdb180b39e)
      2. [**重计算因子水平**](http://www.jianshu.com/p/2a92f8e3af2d)
      3. [**改变因子水平的次序**](http://www.jianshu.com/p/87ae057ae557)
   3. 数据框
      1. 重命令数据框的列
      2. 添加和移除数据框的列
      3. 对数据框的列重新排序
      4. 融合数据框
      5. 比较数据框——在多个数据框中搜索重复或者唯一行
   4. 重新结构化数据
      1. [**长格式和宽格式数据转换**](http://www.jianshu.com/p/4c73f3950cdb)
      2. 归纳总结数据——计算数据框一或多个变量的均值、计数、标准差、标准误和置信区间
      3. 数据框和列联表转换
   5. 序列（连续）数据
      1. 计算移动平均数
      2. 窗口平滑
      3. 寻找唯一值序列
      4. 用最后的非NA值填充NA值
7. [统计分析](http://www.cookbook-r.com/Statistical_analysis)
   1. 回归和相关
   2. t检验
   3. 频数检验—— Chi-square, Fisher’s exact, exact Binomial, McNemar’s test
   4. ANOVA
   5. 逻辑回归
   6. 变量同质性——Levene’s, Bartlett’s, Fligner-Killeen test
   7. 评分人信度——Cohen’s Kappa, weighted Kappa, Fleiss’s Kappa, Conger’s Kappa, intraclass correlation coefficient
8. [绘图](http://www.cookbook-r.com/Graphs)
   1. 用ggplot2绘图
      1. 直方图和线图
      2. [**绘制均值和误差棒**](http://www.jianshu.com/p/003138ac593b)
      3. 绘制分布——Histograms, density curves, boxplots
      4. 散点图
      5. 题目
      6. 坐标轴——控制坐标轴文字、标签和网格线
      7. 图例
      8. 线条
      9. 分面
      10. 多图
      11. 颜色
   2. 图形混杂
      1. 输出到文件——PDF, PNG, TIFF, SVG
      2. 形状和线形
      3. 字体
      4. 抗混淆位图输出
   3. 用标准绘图函数绘制图形
      1. 直方图和密度图
      2. 散点图
      3. 箱线图
      4. Q-Q图
   4. 其他有趣图形
      1. 相关矩阵
   5. 有用链接
      1. [ggplot2在线文档](http://docs.ggplot2.org/current/)
9. [脚本和函数](http://www.cookbook-r.com/Scripts_and_functions)
   1. 创建和运行一个脚本
   2. 调试脚本或函数
   3. 测量运行时间
   4. 获取一个包的函数和对象列表
10. [实验工具](http://www.cookbook-r.com/Tools_for_experiments)
   1. [**生成拉丁方（counterbalanced orders）**](http://www.jianshu.com/p/13b41738e1e5)
   2. 待补充

**注意**：一级章节提供英文链接，翻译中文文章点击具体的文章标题（一般加粗并提供跳转链接表示已翻译）。

## 版权与参与编辑

该文档自由共享，翻译是因为学习和兴趣。**未得到原作者与该翻译文档贡献者认可，禁止任何以商业目的进行获益行为**。

有兴趣的朋友可以**用Github参与**对该文档的编辑或者**翻译后提供文档或链接**（Markdown书写），或者向[简书](http://www.jianshu.com/)的[Cook R专题](http://www.jianshu.com/c/7a295a2306de)投稿，测试参照<http://www.jianshu.com/p/51d9a18117ee>。

## 问题反馈与交流

笔者知识与能力有限，难免出现问题或者错误。如果发现错误或者有疑问，可以在发布该文档的地址评论或留言，也可以在<https://github.com/ShixiangWang/Cookbook-for-R-Chinese/issues>发布一个`New issue`，我会尽量及时更正或者回答。

## 贡献列表

非常感谢大家对该文档做出的贡献。

### 编辑

**简书**

@[王诗翔](http://www.jianshu.com/u/b6608e27dc74)

@[马柑铃](http://www.jianshu.com/u/db3c93db1ca1)

@[你说我对钱一往情深](http://www.jianshu.com/u/3e916f9d8167)



### 校正



