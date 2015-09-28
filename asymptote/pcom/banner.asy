
// Description: Banner of PCOM
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
//     Created: 2013-07-13 07:50:55 CST
// Last Change: 2013-07-15 19:15:27 CST

import EmacsColors;
import myfunctions;

real length = 9.6cm*4;
real height = 1.5cm*4;

pair A = (0,0);
pair B = (length, height);

fill(box(A,B), DodgerBlue3);

pair pos = (0.1*length, 0.90*height);
//label(graphic("lasg.eps","width=2.2cm"),pos,SE);
label(graphic("iap.eps","width=2.2cm"),pos+2.5cm*E,SE);

real lineh=0.8cm;
real scalesize=1.6;
string text = "State Key Laboratory of Numerical Modeling for Atmospheric
Sciences";
label(scale(scalesize)*text, pos+5.5cm*E, SE, white);
string text = "and Geophysical Fluid Dynamics (LASG)";
label(scale(scalesize)*text, pos+5.5cm*E+lineh*S, SE, white);
string text = "Institute of Atmospheric Physics (IAP), Chinese Academy of
Sciences";
label(scale(scalesize)*text, pos+5.5cm*E+2*lineh*S, SE, white);

pos = (pos.x, 0.39*height);

string text = "Pressure Coordinate Ocean Model (PCOM)";
label(scale(3.5)*text,pos,SE,white);
myshipout("png","pcom");
