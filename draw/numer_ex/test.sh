#!/bin/bash

mainname="center"

args="'mainname=\"$mainname\"'"

echo $args
#ncl $args convect.ncl
ncl 'mainname=\"$mainname\"' convect.ncl
