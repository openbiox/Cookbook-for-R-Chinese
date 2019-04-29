# 图形混杂-输出到文件-PDF-PNG-TIFF-SVG

## 问题
你想将图形保存到文件。

## 方案

R 中有好几种命令可以直接将图形导出为文件而不是打印到屏幕上。另外，你必须通过  `dev.off()` 命令告诉 R 你已经完成作图了，否则你的图形是不会显示出来的。

### PDF格式

PDF 是一种矢量文件格式。一般我们都更倾向于将图形输出为矢量图文件，因为这样的图无论怎样缩放都不会出现像素点。矢量图文件的大小通常要比位图文件要小，除非该文件里包含了过多的内容。（比如说一张散点图内包含了上千个点，这时候就会造成矢量图大而位图小。）

```r
pdf("plots.pdf")
plot(...)
plot(...)
dev.off()
```

PDF 默认是 7x7 英寸，并且每个图形都单独占一页。这个尺寸是可以更改的：

```r
# 6x3 inches
pdf("plots.pdf", width=6, height=3)
# 10x6 cm
pdf("plots.pdf", width=10/2.54, height=6/2.54)
```

如果你想在 Inkscape 或者 Illustrator 这样的矢量图编辑器中修改你的文件，图形中的一些绘制点有可能看上去更像是字母而并非原来的圆形或方形等。为了防止这种情况的发生可以输入：

```r
pdf("plots.pdf", useDingbats=FALSE)
```

### SVG格式
SVG是另一种矢量图。默认的  `svg()` 命令无法将多页图形输出到一个文件中，因为大部分的 SVG 浏览软件无法处理多页的 SVG 文件。后面的 PNG 内容中将涉及如何输出到多个文件。

```r
svg("plots.svg")
plot(...)
dev.off()
```

SVG 文件比 PDF 文件更适合矢量图编辑器。

### PNG/TIFF格式
PNG 和 TIFF 是位图（栅格图像），对它们进行缩放时可能会出现像素点。

```r
png("plot.png")
# 或者 tiff("plot.tiff")
plot(...)
dev.off()
```

输出的图像默认尺寸为 480X480 像素，分辨率为 72dpi （即 6.66x6.66 英寸）

当分辨率增加时文本与图像元素的大小也会（以像素为单位）增加。这是因为这些元素的大小只与图像的物理大小有关（比如 4x4英寸），而与图像的像素大小无关。例如，一个 12 磅的字符高度为 12/72 = 1/6 英寸，在分辨率为 72dpi 的情况下，它共包含 12 个像素点；而在分辨率放大到 120dpi 时，它就含有 20 个像素点了。

以下创建一个大小为 480x240 像素，分辨率为 120dpi 的图像,其实际大小相当于 4x2 英寸。

```r
png("plot.png", width=480, height=240, res=120)
plot(...)
dev.off()
```
如果你要创建不止一张图像，必须对每张图像执行一个新的 `png()` 命令，或者将 `%d` 放置到文件名中:

```r
png("plot-%d.png")
plot(...)
dev.off()
```
上述代码会生成 plot-1.png, plot-2.png 等系列文件。

### 对于不支持PDF格式的程序 （MS Office）
有些不支持 PDF文件导入的程序一般都需要高分辨率的PNG或TIFF文件。比如说微软 Office 无法导入 PDF 格式文件。而对于印刷出版物，则需要使用 300dpi 的图像。
```r
# 绘制一幅 6x6英寸，300dpi 的图像
ppi <- 300
png("plot.png", width=6*ppi, height=6*ppi, res=ppi)
plot(...)
dev.off()
```
### ggplot2
如果你在脚本或函数中使用 `ggplot2` 进行绘图，必须使用 `print()` 命令确保图像得到渲染。
```r
# 无效命令
pdf("plots.pdf")
qplot(...)
dev.off()
# 正确的做法
pdf("plots.pdf")
print(qplot(...))
dev.off()
```
从屏幕中保存一个 ggplot2 图像为文件，你可以使用 `ggsave()`。

```r
ggsave("plot.pdf")
ggsave("plot.pdf", width=4, height=4)
# 将图形保存为 400x400，100 ppi的文件
ggsave("plot.png", width=4, height=4, dpi=100)
```
### 保存屏幕中的图像
如果你的屏幕中已经有一张图像了，可以将其保存为位图。
这是一种将屏幕中的对象作出从像素到像素的拷贝，不过这种操作很大概率只能在 Linux 和 Mac 的 X11 系统下得以实现：
```r
# 在屏幕中绘制一张图形
plot(...)
savePlot("myplot.png")
```
这一步是保存屏幕当前图像，并且根据不同的设备对图像进行重新渲染，图像大小可能会因此发生变化。如果你需要图形大小固定，则需要以像素为单位对尺寸进行指定。

```r
# 在屏幕中绘制图像
plot(...)
dev.copy(pdf,"myplot.pdf", width=4, height=4)
dev.off()
# 等同于：
# pdf("myplot.pdf", width=4, height=4)
# plot(...)
# dev.off()
dev.copy(png,"myplot.png", width=400, height=400)
dev.off()

```
