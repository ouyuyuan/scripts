
// Description: T, U grid in pcom
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
//     Created: 2013-06-23 09:30:58 CST
// Last Change: 2014-04-20 08:41:09 BJT

from myfunctions access myshipout;
import mycolor;
import pcom_grid_mod;
include "latexpre.asy";

// def var <<<1

model pcom;
pcom.dlat = 1;
pcom.dlon = 1;
pcom.lat_min = -81;
pcom.lat_max =  80;
pcom.lon_min =   0.5;
pcom.lon_max = 359.5;
pcom.dw  = 1.2cm;

pen tpen = black;
pen upen = myred;

draw_grids(pcom);

dot_points(pcom, "i,j", tpen);
dot_points(pcom, "i+1/2,j+1/2", upen);

label_points(pcom, "i,j", "T", tpen);
label_points(pcom, "i+1/2,j+1/2", "U", upen);

// add text <<<1

picture pictex;

real dh = 0.5cm;
real texlen = 10cm;

string text = "T grid : $T$ (potential temperature), $S$ (sality), \\ 
   \phantom{T grid :} $z_0$ (sea surface height), $w$ (vertical velocity), \\ 
   \phantom{T grid :} $p$ (pressure), and tracers.";
text = minipage(text, texlen);
pair pos = (0,0);
label(pictex, text, pos, tpen);

text = "U grid : $u$ (zonal wind), $v$ (meridianal wind)";
text = minipage(text, texlen);
pos = pos + 3dh*S;
label(pictex, text, pos, upen);

add(pcom.pic.fit(), pos, NW);
//add(pictex.fit(), (-2cm,-2cm), E);
add(pictex.fit(), pos, 1.5cm*S+4.5cm*W);

myshipout("png", "pcom");
