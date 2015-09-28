
// Description: T, U grid in licom
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-04-01 16:25:58 CST
// Last Change: 2013-04-02 14:25:36 CST

from myfunctions access myshipout;
import mycolor;
import licom_grid_mod;
include "latexpre.asy";

// def var <<<1

model licom;
licom.dlat = 0.5;
licom.dlon = 0.5;
licom.lat_min = -78.5;
licom.lat_max =  90;
licom.lon_min =   0;
licom.lon_max = 360.5;
licom.dw  = 1.2cm;

pen tpen = black;
pen upen = myred;

draw_grids(licom);

dot_points(licom, "i,j", tpen);
dot_points(licom, "i-1/2,j-1/2", upen);

label_points(licom, "i,j", "T", tpen);
label_points(licom, "i-1/2,j-1/2", "U", upen);

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

add(licom.pic.fit(), (0,0), W);
add(pictex.fit(), (-2cm,-2cm), E);

myshipout("png", "licom");
