---
title: "Basics-创造填满值的向量"
date: 2017-09-03
status: publish
output: html_notebook
categories: 
- R
- R-Cookbook
tags:
- R
- vector
---
 
# 问题
 
你想要创建一个填满值的列表。
 
<!-- more -->
 
# 方案
 
```R
rep(1, 50)
#  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# [39] 1 1 1 1 1 1 1 1 1 1 1 1
 
rep(F, 20)
#  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
# [13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
 
 
rep(1:5, 4)
# 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5
 
rep(1:5, each=4)
# 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5
 
 
 
# 用在因子变量上
rep(factor(LETTERS[1:3]), 5)
# A B C A B C A B C A B C A B C
# Levels: A B C
 
```
 
***
 
原文链接：<http://www.cookbook-r.com/Basics/Making_a_vector_filled_with_values/>
