
// Description: vertical grid arrangement
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
//     Created: 2013-06-23 10:45:59 CST
// Last Change: 2014-04-06 15:06:19 BJT

import trembling;
from myfunctions access myshipout;
import mycolor;
include "latexpre.asy";

real len = 15cm;
real dw = 1cm;
real text_scale = 1.2;

guide line = (0,0)--len*E;

picture pic;

// water  <<<1

tremble tr=tremble(angle=20,frequency=0.2,random=50,fuzz=1);
pair A = (0,dw);
pair B = (0.5len, -7.3*dw);
pair C = A + len*E;
path waterline=tr.deform(A--C); 
path water = waterline{down} .. tension 1.5 .. {-85}B{-85} .. tension 1.5 ..
{up}A..cycle;
//pen waterpen= mediumgrey+opacity(0.5); 
pen waterpen = SteelBlue2 + opacity(0.1);
filldraw(pic, water, fillpen=waterpen, drawpen=black);

// axe <<<1

real dh = 0.5cm;

pair bp = (-dh, 0.5dw);
pair ep = (-dh, -8*dw - dh);
draw(pic, bp--ep, Arrow); 

label(pic, scale(text_scale)*"sea surface", 0.5*len*E, 0.4*cm*N);
label(pic, scale(text_scale)*"array index", ep, S);

// lines  <<<1

for ( int i = 0; i<9; ++i ) {

    if ( i<3 || i>5 ) {
        pair p = (0,-i*dw);
        if ( i>0 ) draw(pic, shift(p - 0.5dw*S)*line, dashed);
//        draw(pic, shift(p - 0.5dw*S)*line, dashed);
        draw(pic, shift(p)*line);
        if ( i<3 ) label(pic, "\tt "+(string)(i+1), p+dh*W, W);
        if ( i>5 ) label(pic, "\tt "+(string)(60-(8-i)), p+dh*W, W);

    } else {
        dot(pic, (len/2, -i*dw+0.25*dw));
    }
}
pair p = (0,-9*dw);
//draw(pic, shift(p - 0.5dw*S)*line, dashed); // the last dash line

// label  <<<1

label(pic, scale(text_scale)*"$w, p$", (len/2, 0.5dw), Fill(white));
label(pic, scale(text_scale)*"$T, S, u, v$", (len/2, 0), Fill(white));
label(pic, scale(text_scale)*"$w, p$", (len/2, -0.5dw), Fill(white));
//label(pic, scale(text_scale)*"$w, p$", (len/2, -dw), Fill(white));

add(pic);

myshipout("png", "pcom");
