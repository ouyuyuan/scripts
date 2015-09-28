
// Description: first 3d drawing 
//  compile this with asy -noV -noprc -render=0 -f pdf xxx.ash to get
//  a 2D vector graph.
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-28 21:21:25 CST
// Last Change: 2012-09-29 00:09:11 CST

import three;
import mycolor;

size(100);

// the follow project info is get by -V to view, then 'c' to export,
// then copy from the terminal
currentprojection=perspective(
camera=(2.81865000843165,-4.45310421516577,2.65647387434422),
up=(-0.0025984910581856,0.00168762245941046,0.00646906081875381),
target=(0.518772084441647,0.501528617917453,0.440116971534337),
zoom=0.746215396636627,
angle=17.2487529482539,
autoadjust=false);

draw(unitcube, mylightblue);

