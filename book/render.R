#!/usr/bin/Rscript
# 确保自己在book目录下

bookdown::render_book(".")
#bookdown::render_book(".", output_format="all")
system("cp -rf _book/* ../docs")
