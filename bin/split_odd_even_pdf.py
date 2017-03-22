#!/usr/bin/python

import os
import sys
import subprocess

# filenames
filename = sys.argv[1]
odd_filename = "odd_" + filename
even_filename = "even_" + filename
even_filename_2 = "even2_" + filename
tmpfile = "/tmp/pdf.file.pages"

# deterimine total pages
pages_cmd = "pdftk " + filename + \
    " dump_data | grep NumberOfPages | tr -d -c [0-9]" \
    + " > " + tmpfile
os.system(pages_cmd)
pages = open(tmpfile,'r').read()

print(filename + " has " + pages + " pages")

# split to even and odd parts
get_odd_pages = "pdftk A=" + filename + " cat Aodd output " + odd_filename
get_even_pages= "pdftk A=" + filename + " cat Aeven output " + even_filename

os.system(get_odd_pages)
os.system(get_even_pages)

# deal with odd pages
if (int(pages) % 2 == 1):
    cmd = 'pdftk A=' + even_filename + ' B=' + filename + \
            ' cat A B'+pages + ' output ' + even_filename_2
    os.system(cmd)
    os.system('rm -f ' + even_filename)
    os.system('mv ' + even_filename_2 + ' ' + even_filename)
