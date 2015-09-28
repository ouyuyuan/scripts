#!/bin/bash

touch $1
chmod +x $1

echo "#!/usr/bin/perl -w" >> $1
echo "" >> $1
vim $1
