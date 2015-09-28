
// Description: three dimensional saddle draw
//
//       Usage: compile with: 
// asy -noV -noprc -glOptions=-indirect -render=6 -f pdf xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-29 09:18:25 CST
// Last Change: 2012-09-29 16:58:02 CST

import three;
import mycolor;

size(400,0);
currentlight.background = mybackground;

currentprojection=perspective(
camera=(5.99248089958695,2.56636294034066,0.585200218525075),
up=(0.000336478384941707,4.85220557953581e-06,0.00999433633377264),
target=(0.0452631424951292,-0.00582318685752497,0.786673426393476),
zoom=1.1025,
angle=19.9277504172209,
autoadjust=false);

triple a = (1,0,0), b = (0,1,1), c = (-1,0,0), d = (0,-1,1);
guide3 cir = a .. b .. c .. d .. cycle;
draw(surface(cir, new pen[] {white, myred, myblue, mygreen}));

triple e = (1,0,0), f = (0,1,0), g = (-1,0,0), h = (0,-1,0);
guide3 base = e .. f .. g .. h .. cycle;
draw(surface(base, new pen[] {black, myred, mygreen, myblue}));
