#!/bin/bash

# Description: mirror a web-site in the current directory
#
#       Usage: ./xxx.sh web-url
#
#      Author: OU Yuyuan <ouyuyuan@gmail.com>
#     Created: 2012-09-24 17:03:15 CST
# Last Change: 2012-12-15 21:11:31 CST

holdDir="./"
wget --mirror -r -p -np --convert-links -P $holdDir $1

# -r
# 表示递归下载,会下载所有的链接,不过要注意的是,不要单独使用这个参数,因为如果
# 你要下载的网站也有别的网站的链接,wget也会把别的网站的东西下载下来,所以要加上
# -np这个参数,表示不下载别的站点的链接. 
# -np     表示不下载别的站点的链接.
# -p      下载所有html文件适合显示的元素
# --convert-links：下载完成后，将文档链接都转换成本地的
# -P ./LOCAL-DIR：保存所有的文件和目录到指定文件夹下
