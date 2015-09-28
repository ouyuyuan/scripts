
// Description: Banner of homepage
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-04-26 06:49:08 CST
// Last Change: 2013-08-21 09:26:46 CST

import EmacsColors;
import myfunctions;
include "latexpre.asy";

real width = 9.6cm*4;
real height = 1.5cm*4;
pair m = (0,0), M = (width, height);
//pen bg = hsv(214, 0.21, 0.93);
pen bg = DodgerBlue3;
pen shade = LightSkyBlue1;

axialshade(box(m,M), bg, (0,0), shade, (0,height));

// fill(box(m,M), bg);

pen nib = scale(2)*makepen((0,0)--(1,0)--(1,0.1)--(0,0.1)--cycle);
nib += white;

picture pic_sign = scale(1.0)*sign_ou(nib);

pair pos_sign = (0.93width, 0.2height);

add(pic_sign.fit(), pos_sign);

// shipout it

string imgdir = "/home/ou/archive/drawing/homepage";
string filename = imgdir + "/" + outprefix();

settings.outformat="pdf";
shipout(filename);

string pdf = filename + ".pdf";
string png = filename + ".png";
string cmd = "convert -density 150 -units PixelsPerInch";

cmd = cmd + " " + pdf + " " + png;
system(cmd);
