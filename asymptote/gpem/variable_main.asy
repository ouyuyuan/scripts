
// Description: Variables distribution
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2013-01-05 16:33:28 CST
// Last Change: 2013-04-01 16:17:05 CST

from myfunctions access myshipout;
import mycolor;
import model_grid_mod;
include "latexpre.asy";

// def var <<<1

model gpem;
gpem.dlat = 5;
gpem.dlon = 5;
gpem.lat_min = -90;
gpem.lat_max =  90;
gpem.lon_min =   0;
gpem.lon_max = 355;
gpem.dw  = 1.0cm;

// pens  <<<2

pen potpen = red;
//pen strpen = purple;
pen strpen = black;
pen upen   = mygreen;
pen vpen   = blue;

// math symbols <<<2

string sym_pot = "$\phi $";
string sym_str = "$\psi $";
string sym_u   = "$u $";
string sym_v   = "$v $";

draw_grids(gpem);

// draw and label points <<<1

dot_points(gpem, "i,j", potpen);
dot_points(gpem, "i+1/2,j", upen);
dot_points(gpem, "i,j+1/2", vpen);
dot_points(gpem, "i+1/2,j+1/2", strpen);

label_points(gpem, "i,j", sym_pot, potpen);
label_points(gpem, "i+1/2,j", sym_u, upen);
label_points(gpem, "i,j+1/2", sym_v, vpen);
label_points(gpem, "i+1/2,j+1/2", sym_str, strpen);

// add text <<<1

picture pictex;

real dh = 0.5cm;
real texlen = 7cm;

string text = sym_pot+" -- potential height";
text = minipage(text, texlen);
pair pos = (0,0);
label(pictex, text, pos, potpen);

text = sym_u+" -- zonal component of wind";
text = minipage(text, texlen);
pos = pos + dh*S;
label(pictex, text, pos, upen);

text = sym_v+" -- longitudinal component of wind";
text = minipage(text, texlen);
pos = pos + dh*S;
label(pictex, text, pos, vpen);

text = sym_str+" -- stream function";
text = minipage(text, texlen);
pos = pos + dh*S;
label(pictex, text, pos, strpen);

add(gpem.pic.fit(), (0,0), W);
add(pictex.fit(), (-2cm,0), E);

myshipout("png", "gpem");
