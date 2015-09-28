
// Description: Model resolution
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-12-29 16:14:37 CST
// Last Change: 2013-03-22 15:02:47 CST

from myfunctions access myshipout;
import mycolor;
include "latexpre.asy";

picture pic;

pen lonpen = myblue;
pen latpen = mygreen;

real dw  = 1cm;
real len = 8*dw;
guide line = len*(0,0)--len*(0,1);

// funtions  <<<1

// draw points <<<2

// draw poins for a vertical line
void draw_points(picture pic, int k) {

    pen poipen = linewidth(1.5mm);
    
    for (int i=0; i<3; ++i) {
        pair p = (k*dw, i*dw);
        dot(pic, p, poipen);

        pair p = (k*dw, (i+6)*dw);
        dot(pic, p, poipen);
    }
}

// draw axes <<<1

real dh = -0.55dw;
pair a = (0, dh);
pair b = (8*dw, dh) + 3cm*E;
draw(pic, a--b, Arrow);
label(pic, "East", b, E);
label(pic, "Longitude", b+2cm*W, NE, lonpen);
label(pic, "\tt Index", b+2cm*W, SE, lonpen);

real dh = -0.95dw;
pair a = (dh,0);
pair b = (dh, 8*dw) + 2cm*N;
draw(pic, a--b, Arrow);
label(pic, "North", b, N);
label(pic, "Latitude",  b+1cm*S, E, latpen);
label(pic, "\tt Index", b+1cm*S, W, latpen);

// draw grids <<<1

for (int i=0; i<9; ++i) {
    
    // bottom, left <<<2

    if (i<3) {
        draw(pic, shift(i*dw,0)*line, lonpen);
        string lab = (string)(i*5) + "$^\circ$";
        pair pos = (i*dw, 0);
        label(pic, lab, pos, S, lonpen);
        label(pic, "\tt "+(string)(i+1), pos, 0.2cm*S, lonpen);

        draw(pic, shift(0,i*dw)*rotate(-90)*line, latpen);
        draw_points(pic, i);
        string lab = (string)(i*5-90) + "$^\circ$";
        pair pos = (0,i*dw);
        label(pic, lab, pos, W, latpen);
        label(pic, "\tt "+(string)(i+1), pos, 0.3cm*W, latpen);

    // middle points <<<2

    } else if (i<6) {
        dot(pic, (i*dw, 0.5len), lonpen);
        dot(pic, (0.5len, i*dw), latpen);

    // up, right <<<2

    } else {
        draw(pic, shift(i*dw,0)*line, lonpen);
        string lab = (string)(i*5 + 315) + "$^\circ$";
        pair pos = (i*dw,0);
        label(pic, lab, pos, S, lonpen);
        label(pic, "\tt "+(string)(i+64), pos, 0.2cm*S, lonpen);

        draw(pic, shift(0,i*dw)*rotate(-90)*line, latpen);
        draw_points(pic, i);
        string lab = (string)(i*5 + 50) + "$^\circ$";
        pair pos = (0,i*dw);
        label(pic, lab, pos, W, latpen);
        label(pic, "\tt "+(string)(i+29), pos, 0.3cm*W, latpen);
    }
}

// add text <<<1

string text = "$5^\circ \times 5^\circ$ \par
           \bigskip 
           {\color{green4}
           \[ {\tt nlat} = \frac{90^\circ -(-90^\circ )}{5^\circ } + 1 = 37 \]
           }
           \bigskip
           {\color{blue2}
           \[ {\tt nlon} = \frac{355^\circ -0^\circ }{5^\circ } + 1 = 72 \] \par
           }
           ";
text = minipage(text, 6cm);
label(pic, text, (8dw, 0.5len), 0.2cm*E);
add(pic.fit());

myshipout("png", "gpem");
