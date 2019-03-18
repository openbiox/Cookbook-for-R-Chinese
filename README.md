# Cookbook for R 中文翻译

> [Cookbook for R 中文版](https://github.com/openbiox/Cookbook-for-R-Chinese/) 是由[Openbiox小组](https://github.com/openbiox)实时维护的[Cookbook for R](http://www.cookbook-r.com/)中文版。
>
> - 阅读文档请到 👉 

## 如何翻译和修改

目前参考以下两个文档进行翻译的提交与校对以及该仓库所有内容的修改。

* [关于如何提交翻译以及后续更新的教程](https://github.com/xitu/gold-miner/wiki/%E5%85%B3%E4%BA%8E%E5%A6%82%E4%BD%95%E6%8F%90%E4%BA%A4%E7%BF%BB%E8%AF%91%E4%BB%A5%E5%8F%8A%E5%90%8E%E7%BB%AD%E6%9B%B4%E6%96%B0%E7%9A%84%E6%95%99%E7%A8%8B)
* [参与校对的正确姿势](https://github.com/xitu/gold-miner/wiki/%E5%8F%82%E4%B8%8E%E6%A0%A1%E5%AF%B9%E7%9A%84%E6%AD%A3%E7%A1%AE%E5%A7%BF%E5%8A%BF)

基本流程比较简单：Fork仓库->修改->提交PR->审查并通过->下一轮

## 维护人员

* [@王诗翔]()
* [@杨芮]()
* [@熊逸]()
* [@张子颖]()
* [@赵飞]()
* [@王慧美]()
* [@时伟丽]()
* [@陈颖珊]()

## 许可

文档正在完善中，未经允许禁止任何形式的转载。

[Apache 许可 2.0](LICENSE)

## Table of Content

1. **基础**
   1. R环境
      1. [安装和使用R包](/cookbook/Basics/R-环境-安装和使用R包.md)
   2. R语言基础
      1. [数据结构的索引](/cookbook/Basics/R-基础-数据结构的索引.md)
      2. [获取数据结构的子集](/cookbook/Basics/R-基础-获取数据结构的子集.md)
      3. [创造填满值的向量](/cookbook/Basics/R-基础-创建填满值的向量.md)
      4. [变量信息](/cookbook/Basics/R-基础-获取变量信息.md)
      5. [NULL, NA, NaN的处理](/cookbook/Basics/R-基础-NULL-NA-NaN的处理.md)
2. **数值**
   1. [生成随机数](/cookbook/Numbers/生成随机数.md)
   2. [生成可重复的随机序列](/cookbook/Numbers/生成可重复的随机序列.md)
   3. [保存随机数生成器的状态](/cookbook/Numbers/保存随机数生成器的状态.md)
   4. [对数值取整](/cookbook/Numbers/对数值取整.md)
   5. [比较浮点数](/cookbook/Numbers/比较浮点数.md)
3. **字符串**
   1. 使用grep,sub,gsub进行搜索和替换
   2. [通过变量创建字符串](/cookbook/Strings/通过变量创建字符串.md)
4. **公式**
   1. [通过字符串创建公式](/cookbook/Formulas/通过字符串创建公式.md)
   2. [从公式中提取组分](/cookbook/Formulas/从公式中提取组分.md)
5. **数据输入和输出**
   1. [从文件中载入数据](/cookbook/Data_input_and_output/Data-input-and-output-1-Loading-data-from-a-file.md)
   2. [从键盘和剪贴板载入和保存数据](/cookbook/Data_input_and_output/Data-input-and-output-2-Loading-and-storing-data-with-the-keyboard-and-clipboard.md)
   3. [运行脚本](/cookbook/Data_input_and_output/Data-input-and-output-3-Running-a-script.md)
   4. [将数据写入文件](/cookbook/Data_input_and_output/Data-input-and-output-4-Writing-data-to-a-file.md)
   5. [将分析结果写入文件](/cookbook/Data_input_and_output/Data-input-and-output-5-Writing-text-and-output-from-analyses-to-a-file.md)
6. **数据操作**
   1. 通用
      1. [排序](/cookbook/Manipulating_data/Manipulating-Data-1-Sorting.md)
      2. [随机化顺序](/cookbook/Manipulating_data/Manipulating-Data-2-Randomizing-order.md)
      3. [转换向量类型——数值向量，字符串向量和因子向量](/cookbook/Manipulating_data/Manipulating-Data-3-Converting-between-vector-types-Numeric-vectors-Character-vectors-and-Factors.md)
      4. [寻找和移除重复记录](/cookbook/Manipulating_data/Manipulating-Data-4-Comparing-vectors-or-factors-with-NA.md)
      5. [比较带NA值的向量或因子](/cookbook/Manipulating_data/Manipulating-Data-5-Finding-and-removing-duplicate-records.md)
      6. [重编码数据](/cookbook/Manipulating_data/Manipulating-Data-6-Recoding-data.md)
      7. [映射向量值——将向量中所有值为x的实例改为值y](/cookbook/Manipulating_data/通用-映射向量值-将向量中所有值为x的实例改为值y.md)
   2. 因子
      1. [重命名因子水平](/cookbook/Manipulating_data/因子-重命名因子水平.md)
      2. [重计算因子水平](/cookbook/Manipulating_data/因子-重计算因子水平.md)
      3. [改变因子水平的次序](/cookbook/Manipulating_data/因子-重计算因子水平.md)
   3. 数据框
      1. 重命令数据框的列
      2. 添加和移除数据框的列
      3. 对数据框的列重新排序
      4. 融合数据框
      5. 比较数据框——在多个数据框中搜索重复或者唯一行
   4. 重构化数据
      1. 长格式和宽格式数据转换
      2. 归纳总结数据——计算数据框一或多个变量的均值、计数、标准差、标准误和置信区间
      3. 数据框和列联表转换
   5. 序列（连续）数据
      1. 计算移动平均数
      2. 窗口平滑
      3. 寻找唯一值序列
      4. 用最后的非NA值填充NA值
7. **统计分析**
   1. 回归和相关
   2. t检验
   3. 频数检验—— Chi-square, Fisher’s exact, exact Binomial, McNemar’s test
   4. ANOVA
   5. 逻辑回归
   6. 变量同质性——Levene’s, Bartlett’s, Fligner-Killeen test
   7. 评分人信度——Cohen’s Kappa, weighted Kappa, Fleiss’s Kappa, Conger’s Kappa, intraclass correlation coefficient
8. **绘图**
   1. 用ggplot2绘图
      1. 直方图和线图
      2. [绘制均值和误差棒](/cookbook/Graphs/ggplot-绘制均值和误差棒.md)
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
9. **脚本和函数**
   1. 创建和运行一个脚本
   2. 调试脚本或函数
   3. 测量运行时间
   4. 获取一个包的函数和对象列表
10. **实验工具**
  1. 生成拉丁方
  2. 待补充


