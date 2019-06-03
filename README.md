# Cookbook for R 中文版

[Cookbook for R 中文版](https://github.com/openbiox/Cookbook-for-R-Chinese/) 是由 [Openbiox 小组](https://github.com/openbiox)第一批创建和维护的[Cookbook for R](http://www.cookbook-r.com/)中文翻译项目。

阅读请点击 👉 <https://openbiox.github.io/Cookbook-for-R-Chinese/>

## 问题与反馈

网站所有网页的源文件均用 R Markdown 撰写。如果你在网站发现了任何错误，恳请点击菜单栏上的 “编辑” 按钮，并在 Github 上向我们提交合并请求。如果读者有任何的疑问或者遇到以下提到的内容不当之处，请通过[创建 GitHub issue](https://github.com/openbiox/Cookbook-for-R-Chinese/issues)与我们联系。

- 翻译内容不通顺，影响阅读体验
- 中英文括号的错误使用，如 `()` 写成了 `（）`，`。`写成了 `.`
- 包名没有以加粗的方式标识，如 **ggplot2** 包应当显示成 **ggplot2**，而不是 ggplot2 或 `ggplot2`
- 函数名后没有伴随成对的英文括号，如表明 `summary` 是函数时应写为 `summary()`，而 `summary` 这种写法则应该表示的是对象、数据框的列名或选项等
- 网页链接点击跳转不正确
- 标题的层次结构不对，比如本来是 4 级标成了 3 级 或 5 级
- 排版不好或存在问题
- ...

另外，有小部分代码注释存在没有翻译的现象，如果不影响读者阅读，请忽略它们。如果你觉得它严重影响了你的理解，请反馈给我们或提交相关内容所有的翻译（而不是一行）。

如果你存在一些分析问题，而且认为它是大多数人可能都会遇到的，想要寻求通用的解决方案，也可以反馈，我们会想办法解决并更新到相应章节下。


### 更新

推荐使用 RStudio 编辑文档，修改后使用工具栏上的 **Preview** 按钮预览更新，它也会在 `_book` 目录下更新相应的网页文件。

然后在 R 中使用下面命令（保证工作目录是`book/`）将文档拷贝到网站实际显示的目录下。

```
system("cp -rf _book/* ../docs")
```

或 Shell 下使用：

```
cp -rf _book/* ../docs
```

## 贡献列表

* 陈颖珊
* 梁其云
* 王慧美
* 王诗翔
* 熊逸
* 杨芮
* 张浩浩
* 赵飞

## 许可

[Apache 许可 2.0](LICENSE)



