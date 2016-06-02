
// Description: grid stucture in a subdomain
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-06-23 09:30:58 CST
// Last Change: 2016-04-07 18:50:45 BJT

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
string[] lonid = {"\tt j=1", "\tt 2", "\tt 3", " ", " ", "\tt nj"};
string[] latid = {"\tt i=ni", "\tt ni-1", "\tt ni-2", " ", " ", "\tt 1"};

// latitude and longitude lines
picture p;
draw(p, line );

for (int i=0; i<y.length; ++i)
{
  add( p.fit(),     (0,y[i]) );
}

p = rotate(90)*p;

for (int i=0; i<x.length; ++i)
{
  add( p.fit(),     (x[i],0) );
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
  label( lonid[i],  (x[i],-0.4dw) );
  if ( i==0 ) {
    label( "\tt 1", (x[i]+0.5dw,-0.4dw) );
  } else {
    label( lonid[i], (x[i]+0.5dw,-0.4dw) );
  }
}

for (int i=0; i<y.length; ++i)
{
  label( latid[i],  (-0.6dw,y[i]) );
  if ( i==0 ) {
    label( "\tt ni", (-0.6dw, y[i]+0.5dw) );
  } else {
    label( latid[i], (-0.6dw, y[i]+0.5dw) );
  }
}

// shade boundary points
picture p;
pair v = (0.3dw, 6.4dw);
pen bndPen = MediumPurple1;
fill( p, (0,0)--(v.x,0)--v--(0,v.y)--cycle, bndPen);
p = shift(-0.15dw, -0.2dw)*p;

// T-grid west boundary
add( p, above=false );

// T-grid south boundary
add( rotate(270)*p, above=false );

// T-grid north boundary
add( shift(0,6dw)*rotate(270)*p, above=false );

// T-grid east boundary
add( shift(6dw)*p, above=false );

pair v = (0.5dw, 0.5dw);
p = shift(v) * p;
// U-grid west boundary
add( p, above=false );

// U-grid south boundary
add( rotate(270, z=v)*p, above=false );

// U-grid north boundary
add( shift(0,6dw)*rotate(270,z=v)*p, above=false );

// U-grid east boundary
add( shift(6dw)*p, above=false );

// draw vertical grid
picture ver;
real dz = -0.7dw;
pen layerPen = SkyBlue2;
real[] z = {0, dz, 2dz, 5dz, 6dz}; // layer position
string[] kid = {"\tt k=1", "\tt 2", "\tt 3", "\tt nk-1", "\tt nk"};

picture p;
pair v = (2.3dw, -0.9dz);
fill( p, (0,0)--(v.x,0)--v--(0,v.y)--cycle, layerPen);

for (int k=0; k<z.length; ++k)
{
  add( ver, p.fit(), (0,z[k]) );
  label( ver, kid[k], (2.7dw,z[k]-0.5dz) );
  if ( k == 0 ) {
    label( ver, "\tt 1", (2.7dw,z[0]) );
  } else {
    label( ver, kid[k], (2.7dw,z[k]) );
  }
  label( ver, scale(1.0)*"$\dot{\eta}, p$", (1.2dw, z[k]-0.5dz) );
  label( ver, scale(1.0)*"$\theta, S, \tilde{u}, \tilde{v}$", (1.2dw, z[k]) );
}
add( ver.fit(), (8dw, 5dw) );

// add text
if (debug) {
  dot( "O", (0,0), green+linewidth(2mm) );
}

pair p = (0,-1.0dw);
dot( p, linewidth(poiwidth) );
label( "T 网格", p, 0.1cm*E );

pair p = (2dw, p.y);
add( U.fit(), p );
label( "U 网格", p, 0.1cm*E );

pair v = (dw, 0.3dw);
pair p = (4dw, p.y-0.5v.y);
filldraw( shift(p) * scale(v.x,v.y) * unitsquare, fillpen = bndPen, drawpen = white );
label( "并行子区域边界格点", p+(v.x,0.5v.y), 0.1cm*E );

//pair p = (8.4dw, -1.5dw);
//guide layer = (0,0)--(dw,0);
//draw( shift(p) * layer, layerPen + linewidth(-0.4dz) );
//label( "M points", p+(dw,0), 0.1cm*E );
//label( "B points", p+(dw,0.25dw), 0.1cm*E );

myshipout("pdf", "phdthesis/");
