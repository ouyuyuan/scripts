
// Description: Read column data in file. Ref. Manual p.105 
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-09 16:56:26 CST
// Last Change: 2012-11-21 21:20:09 CST

import graph;
from myfunctions access myshipout;

size(8cm, 6cm, IgnoreAspect);

file in = input("column-file-data.dat").line();
real[][] a = in.dimension(0,0);
// 0 means no restriction on dimension. Ref. Manual p.74
// for un-uniform column data, see tips in learning.org
a = transpose(a);

real[] x = a[0];
real[] y = a[1];

draw(graph(x,y));

xaxis("$x$", BottomTop, LeftTicks);
yaxis("$y$", LeftRight, RightTicks);

myshipout();
