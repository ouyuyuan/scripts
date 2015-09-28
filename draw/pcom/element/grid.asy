
// Description: PCOM grid distribution
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-06-23 09:30:58 CST
// Last Change: 2014-10-12 18:06:59 BJT

from myfunctions access myshipout;
import mycolor;
import EmacsColors;
include "latexpre.asy";

//bool debug = true;
bool debug    = false;
real dw       = 1.5cm; // space between grids
real poiwidth = 0.15*dw; // how big the point of T-grid
guide line    = (0,0)--(6dw,0);

real[] x = {0, dw, 2dw, 3dw, 5dw, 6dw}; // lon-line position
real[] y = {0, dw, 2dw, 3dw, 5dw, 6dw}; // lat-line position
string[] lat =
  {"$-81^\circ$", "$-80^\circ$", "$-79^\circ$", 
   "$-78^\circ$",  "$79^\circ$",  "$80^\circ$"};
string[] lon =
  {"$359.5^\circ$", "$0.5^\circ$", "$1.5^\circ$", 
   "$2.5^\circ$",  "$359.5^\circ$",  "$0.5^\circ$"};
string[] iid = {"\tt i=1", "\tt 2", "\tt 3", "\tt 4", "\tt Lm", "\tt L"};
string[] jid = {"\tt j=1", "\tt 2", "\tt 3", "\tt 4", "\tt Mm", "\tt M"};

// latitude and longitude lines
picture p;
draw(p, line );

for (int i=0; i<y.length; ++i)
{
  add( p.fit(),     (0,y[i]) );
  label( lat[i], (-1.4dw,y[i]) );
}

p = rotate(90)*p;

for (int i=0; i<x.length; ++i)
{
  add( p.fit(),     (x[i],0) );
  label( lon[i], (x[i],-0.9dw) );
}

// dot T-points and U-points
picture U; // U-grid, arrow
draw( U, (-3mm,0)--(2mm,0), linewidth(0.2mm), Arrow );

picture p;
for (int i=0; i<x.length; ++i)
{
  dot( p, (x[i],0), linewidth(poiwidth) );
  add( p, U.fit(), (x[i]+0.5dw,0.5dw) );
}

for (int i=0; i<y.length; ++i)
{
  add( p.fit(), (0,y[i]) );
}

// latitude and longitude index
for (int i=0; i<x.length; ++i)
{
  label( iid[i],  (x[i],-0.4dw) );
  if ( i==0 ) {
    label( "\tt 1", (x[i]+0.5dw,-0.4dw) );
  } else {
    label( iid[i], (x[i]+0.5dw,-0.4dw) );
  }
}

for (int i=0; i<y.length; ++i)
{
  label( jid[i],  (-0.6dw,y[i]) );
  if ( i==0 ) {
    label( "\tt 1", (-0.6dw, y[i]+0.5dw) );
  } else {
    label( jid[i], (-0.6dw, y[i]+0.5dw) );
  }
}

// shade wrap-up columns
picture p;
pair v = (0.3dw, 6.4dw);
pen haloPen = MediumPurple1;
fill( p, (0,0)--(v.x,0)--v--(0,v.y)--cycle, haloPen);
p = shift(-0.15dw, -0.2dw)*p;
add( p, above=false );
add( shift(6dw)*p, above=false );
p = shift(0.5dw, 0.5dw) * p;
add( p, above=false );
add( shift(6dw)*p, above=false );

// draw vertical grid
picture ver;
real dz = -0.7dw;
pen layerPen = SkyBlue2;
real[] z = {0, dz, 2dz, 5dz, 6dz}; // layer position
string[] kid = {"\tt n=1", "\tt 2", "\tt 3", "\tt Nm", "\tt N"};

guide line = (0,0)--(2dw,0);
picture p;
draw( p, line, layerPen + linewidth(-0.95dz) );

for (int k=0; k<z.length; ++k)
{
  add( ver, p.fit(), (0,z[k]) );
  label( ver, kid[k], (2.5dw,z[k]-0.5dz) );
  if ( k == 0 ) {
    label( ver, "\tt 1", (2.5dw,z[0]) );
  } else {
    label( ver, kid[k], (2.5dw,z[k]) );
  }
  label( ver, scale(1.0)*"$w, p$", (1.2dw, z[k]-0.5dz) );
  label( ver, scale(1.0)*"$\theta, S, u, v$", (1.2dw, z[k]) );
}
add( ver.fit(), (8dw, 5dw) );

// add text
if (debug) {
  dot( "O", (0,0), green+linewidth(2mm) );
}

pair p = (0,-1.5dw);
dot( p, linewidth(poiwidth) );
label( "T points", p, 0.1cm*E );

pair p = (2dw, p.y);
add( U.fit(), p );
label( "U points", p, 0.1cm*E );

pair v = (dw, 0.3dw);
pair p = (4dw, p.y-0.5v.y);
filldraw( shift(p) * scale(v.x,v.y) * unitsquare, fillpen = haloPen, drawpen = white );
label( "halo points", p+(v.x,0.5v.y), 0.1cm*E );

//pair p = (8.4dw, -1.5dw);
//guide layer = (0,0)--(dw,0);
//draw( shift(p) * layer, layerPen + linewidth(-0.4dz) );
//label( "M points", p+(dw,0), 0.1cm*E );
//label( "B points", p+(dw,0.25dw), 0.1cm*E );

myshipout("eps", "pcom/element");
