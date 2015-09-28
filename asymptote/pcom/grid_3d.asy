
// Description: 3D view of grids
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
//     Created: 2013-06-23 10:49:16 CST
// Last Change: 2013-06-23 16:29:42 CST

import three;
import graph3;
import mycolor;
from myfunctions access myshipout;

currentprojection=perspective(
camera=(181.301891906631,-230.676950250663,47.6152279050531),
up=(-0.00935006398520853,0.413545266620435,0.910432297672668),
target=(100.507365064396,91.4719208583676,-99.5440370911211),
zoom=0.822702474791882,
angle=45.9402236377561,
autoadjust=false);

real dw = 1cm;
pen hpen = dashed;

// draw a plane

void draw_plane(picture pic, pen gridpen, pen surfacepen, 
    string tvar, string uvar, real zval) {

    real len = 8dw;

    draw(pic, shift(0,0,zval)*scale3(len)*unitsquare3, gridpen);
    draw(pic, surface( shift(0,0,zval)*scale3(len)*unitsquare3 ), surfacepen);

    triple hp = (0.5dw, 0.5dw, zval);

    // T grid
    if ( tvar != "" ) {
        draw(pic, shift(0,0,zval)*scale3(dw)*unitsquare3);
        label(pic, rotate(90,X)*tvar, hp, SW);
    }

    // U grid
    if ( uvar != "" ) {
        draw(pic, shift(hp)*scale3(dw)*unitsquare3, hpen+myred);
        label(pic, rotate(90,X)*uvar, (2dw,1.5dw,zval), myred);
    }
}

picture pic;

real zval = 0;
real dk = dw;
real dep = 0;

pen wsurfacepen = SteelBlue2 + opacity(0.1);
pen hsurfacepen = blue1 + opacity(0.1);
//pen hsurfacepen = nullpen;

draw_plane(pic, black, wsurfacepen, "$w, p$", "", dep);
dep -= dk;

draw_plane(pic, hpen,  hsurfacepen, "$T, S$", "$u, v$", dep);
dep -= dk;

draw_plane(pic, black, wsurfacepen, "$w, p$", "", dep);
dep -= dk;

draw_plane(pic, hpen,  hsurfacepen, "$T, S$", "$u, v$", dep);
dep -= dk;

draw_plane(pic, black, wsurfacepen, "$w, p$", "", dep);

add(pic);
myshipout("3d", "pcom");
