
// Description: vertical grid arrangement
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-04-01 18:51:12 CST
// Last Change: 2013-04-02 08:41:05 CST

from myfunctions access myshipout;
import mycolor;
include "latexpre.asy";

real len = 5cm;
real dw = 1cm;

guide line = (0,0)--len*E;

picture pic;

// axe <<<1

real dh = 0.5cm;

pair bp = (-dh, 0.5dw);
pair ep = (-dh, -8*dw - dh);
draw(pic, bp--ep, Arrow); 

label(pic, "surface", bp, 0.1cm*N);
label(pic, "bottom", ep, S);

// lines  <<<1

for ( int i = 0; i<9; ++i ) {

    if ( i<3 || i>5 ) {
        pair p = (0,-i*dw);
        draw(pic, shift(p - 0.5dw*S)*line, dashed);
        draw(pic, shift(p)*line);
        if ( i<3 ) label(pic, "\tt "+(string)(i+1), p+dh*W, W);
        if ( i>5 ) label(pic, "\tt "+(string)(30-(8-i)), p+dh*W, W);

    } else {
        dot(pic, (len/2, -i*dw));
    }
}

// label  <<<1

label(pic, "$T, S, u, v$", (len/2, 0.5dw), Fill(white));
label(pic, "$w, p$", (len/2, 0), Fill(white));
//label(pic, "$w, p$", (len/2, -dw), Fill(white));

add(pic);

myshipout("png", "licom");
