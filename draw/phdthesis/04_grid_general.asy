
// Description: general grid
//       Usage: /usr/bin/asy -V xxx.asy, use the mouse to
//       ajust the orientation of the 3D graph, use screen capture
//       software to capture the png format of the figure
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
//     Created: 2013-06-23 10:49:16 CST
// Last Change: 2016-04-09 14:41:02 BJT

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
autoadjust=true);
//autoadjust=false);

real dw = 4cm;
pen hpen = dashed;

// draw a plane

void draw_plane(picture pic, pen gridpen, pen surfacepen, 
    string tvar, string uvar, real zval, 
    string hg1, string hg2, string hg3, string hg4) {

    real len = 1.5dw;

    draw(pic, shift(0,0,zval)*scale3(len)*unitsquare3, gridpen);
    draw(pic, surface( shift(0,0,zval)*scale3(len)*unitsquare3 ), surfacepen);

    triple hp = (0.5dw, 0.5dw, zval);

    // T grid
    if ( tvar != "" ) {
        draw(pic, shift(0,0,zval)*scale3(dw)*unitsquare3);
        label(pic, rotate(90,X)*tvar, (0dw,0dw,zval), SW);
        label(pic, rotate(90,X)*hg1, (1dw,1dw,zval), SW);
        label(pic, rotate(90,X)*hg2, (1dw,0.5dw,zval), SW);
        label(pic, rotate(90,X)*hg3, (0.5dw,0.5dw,zval), SW);
        label(pic, rotate(90,X)*hg4, (0.5dw,1dw,zval), SW);
    }

    // U grid
//    if ( uvar != "" ) {
        draw(pic, shift(hp)*scale3(dw)*unitsquare3, hpen+myred);
        label(pic, rotate(90,X)*uvar, (1.5dw,1.5dw,zval), myred);
//    }
}

picture pic;

real zval = 0;
real dk = 0.8dw;
real dep = 0;

pen wsurfacepen = SteelBlue2 + opacity(0.1);
pen hsurfacepen = blue1 + opacity(0.1);
//pen hsurfacepen = nullpen;

string g11 = "$g_{11}$"; string g21 = "$g_{21}$";
string g31 = "$g_{31}$"; string g41 = "$g_{41}$";
string g12 = "$g_{12}$"; string g22 = "$g_{22}$";
string g32 = "$g_{32}$"; string g42 = "$g_{42}$";

draw_plane(pic, black, wsurfacepen, "$\dot{\eta}$", "", dep,
g11, g21, g31, g41);
dep -= dk;

draw_plane(pic, hpen,  hsurfacepen, "$T$", "$U$", dep,
g12, g22, g32, g42);
dep -= dk;

//draw_plane(pic, black, wsurfacepen, "$\dot{\eta}$", "", dep, 
//g11, g21, g31, g41);
//dep -= dk;

//draw_plane(pic, hpen,  hsurfacepen, "$T$", "$U$", dep);
//dep -= dk;

add(pic);
//myshipout("3d", "pcom/phdthesis");
