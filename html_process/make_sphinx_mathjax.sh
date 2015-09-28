#/bin/bash

# Description: change Sphinx mathjax to local instead of cdn for quick loading 
#
#       Usage: in the Makefile directory of Sphinx, xxx.sh
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-04-26 20:26:12 CST
# Last Change: 2013-12-06 08:04:17 BJT

root=`pwd`
src_ori_dir="$root/origin_source"
filter_dir="$root/_filtered_source"
html_dir="$root/build/html"
scripts_dir="$HOME/archive/scripts"
alt_txt="$scripts_dir/html_process/mathjax.txt"
sub_script="$scripts_dir/html_process/change_html_mathjax_local.pl"
fileter="$scripts_dir/text_analysis/filter_math_rst.pl"

if [ -d "$src_ori_dir" ]; then
   rm -rf $filter_dir
   cp -r $src_ori_dir $filter_dir

   cd $src_ori_dir

   for file in `ls *.rst`
   do
      $fileter $file $filter_dir/$file
   done

   cd $root
   rm source
   ln -s $filter_dir source
   make html

   rm source
   ln -s $src_ori_dir source # link back for original source after compile by sphinx
else
   make html
fi

cd $html_dir

$sub_script $alt_txt *.html

