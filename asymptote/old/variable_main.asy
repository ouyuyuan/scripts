
// Description: Variables distribution
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2013-01-05 16:33:28 CST
// Last Change: 2013-03-22 15:00:51 CST

from myfunctions access myshipout;
import mycolor;
include "latexpre.asy";

// def variables  <<<1

picture pic;

real dw  = 1.0cm;
real len = 8*dw;
real poiwidth = 0.15dw;
guide line = (0,0)--len*(0,1);
guide hori_line = (0,0)--(len + 0.5dw)*(0,1);

// pens  <<<2

pen lonpen = black;
pen latpen = black;
pen potpen = red;
pen strpen = purple;
pen upen   = mygreen;
pen vpen   = blue;

// math symbols <<<2

string sym_pot = "$\phi $";
string sym_str = "$\psi $";
string sym_u   = "$u $";
string sym_v   = "$v $";

// funtions  <<<1

// draw points <<<2

// draw poins for a vertical line
// representing potential height
void draw_points(picture pic, int k) {

    for (int i=0; i<3; ++i) {

        // bottom <<<3

        pair p = (k*dw, i*dw);

        dot(pic, p, potpen+linewidth(poiwidth));
        if (k<2 && i<2) label(pic, sym_pot, p, NE, potpen);

        pair up = p+0.5dw*E;
        dot(pic, up, upen+linewidth(poiwidth));
        if (k<2 && i<2) label(pic, sym_u, up, NE, upen);

        pair sp = p+0.5dw*(E+N);
        dot(pic, sp, strpen+linewidth(poiwidth));
        if (k<2 && i<1) label(pic, sym_str, sp, NE, strpen);

        pair vp = p+0.5dw*N;
        dot(pic, vp, vpen+linewidth(poiwidth));
        if (k<2 && i<1) label(pic, sym_v, vp, NE, vpen);

        // top  <<<3

        pair p = (k*dw, (i+6)*dw);

        dot(pic, p, potpen+linewidth(poiwidth));
//        label(pic, sym_pot, p, NE, potpen);

        pair up = p+0.5dw*E;
        dot(pic, up, upen+linewidth(poiwidth));
//       label(pic, sym_u, up, NE, upen);

        if(i<2) {
            pair sp = p+0.5dw*(E+N);
            dot(pic, sp, strpen+linewidth(poiwidth));
        }

        if (i<2) {
            pair vp = p+0.5dw*N;
            dot(pic, vp, vpen+linewidth(poiwidth));
//            label(pic, sym_v, vp, NE, vpen);
        }
    }
}

// draw axes <<<1

real dh = -0.55cm;
pair a = (0, dh);
pair b = (8*dw, dh) + 3cm*E;
draw(pic, a--b, Arrow);
label(pic, "East", b, E);
label(pic, "Longitude", b+2cm*W, NE, lonpen);
label(pic, "\tt Index", b+2cm*W, SE, lonpen);

real dh = -0.95cm;
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
        draw(pic, shift((i+0.5)*dw,0)*line, dashed+lonpen);

        string lab = (string)(i*5) + "$^\circ$";
        pair pos = (i*dw, 0);
        label(pic, lab, pos, S, lonpen);
        label(pic, "\tt "+(string)(i+1), pos, 0.2cm*S, lonpen);

        draw(pic, shift(0,i*dw)*rotate(-90)*hori_line, latpen);
        draw(pic, shift(0,(i+0.5)*dw)*rotate(-90)*hori_line, dashed+latpen);

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
        draw(pic, shift((i+0.5)*dw,0)*line, dashed+lonpen);

        string lab = (string)(i*5 + 315) + "$^\circ$";
        pair pos = (i*dw,0);
        label(pic, lab, pos, S, lonpen);
        label(pic, "\tt "+(string)(i+64), pos, 0.2cm*S, lonpen);

        draw(pic, shift(0,i*dw)*rotate(-90)*hori_line, latpen);
        if (i<8) draw(pic, shift(0,(i+0.5)*dw)*rotate(-90)*hori_line, dashed+lonpen);

        draw_points(pic, i);

        string lab = (string)(i*5 + 50) + "$^\circ$";
        pair pos = (0,i*dw);
        label(pic, lab, pos, W, latpen);
        label(pic, "\tt "+(string)(i+29), pos, 0.3cm*W, latpen);
    }
}

// add text <<<1

real dh = 0.5dw;

string text = sym_pot+" -- potential height";
text = minipage(text, 10cm);
pair pos = (8dw, 0.7len);
label(pic, text, pos, 0.2cm*E, potpen);

text = sym_u+" -- zonal component of wind";
text = minipage(text, 10cm);
pos = pos + dh*S;
label(pic, text, pos, 0.2cm*E, upen);

text = sym_v+" -- longitudinal component of wind";
text = minipage(text, 10cm);
pos = pos + dh*S;
label(pic, text, pos, 0.2cm*E, vpen);

text = sym_str+" -- stream function";
text = minipage(text, 10cm);
pos = pos + dh*S;
label(pic, text, pos, 0.2cm*E, strpen);

add(pic.fit());

myshipout("png", "gpem");
