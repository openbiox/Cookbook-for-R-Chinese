# 确保自己在book目录下

bookdown::render_book(".")
system("cp -rf _book/* ../docs")
