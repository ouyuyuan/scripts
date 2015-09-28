
// Description: show all the five connectors in 3D. Explanations about
// these connector can be found on "Asymptote 范例教程" P.33,34
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-29 16:43:04 CST
// Last Change: 2012-10-09 00:11:48 CST

import graph3;
import mycolor;

currentlight.background = mybackground;

size(400);
currentprojection=orthographic(1,-1,1);
triple[] z=new triple[10];
z[0]=(0,1,0); z[1]=(0.5,0,0); z[2]=(1.8,0,0);
for(int n=3; n <= 9; ++n)
    z[n]=z[n-3]+(2,0,0);

path3 p=z[0]..z[1]---z[2]::{Y}z[3]
&z[3]..z[4]--z[5]::{Y}z[6]
&z[6]::z[7]---z[8]..{Y}z[9];
draw(p,grey+linewidth(4mm),currentlight);
xaxis3(Label("$x$",align=-2Y), xmin=0, xmax=6.5, 
    above=true, Arrow3);
yaxis3(Label("$y$",align=-X), ymin=0, ymax=1.5, 
    above=true, Arrow3);
label("$O$",(0,0,0), SW);

dot("$z_0$",z[0],3X);
dot("$z_1$",z[1],-3Y);
dot("$z_2$",z[2],-3Y);
dot("$z_3$",z[3],3X);
dot("$z_4$",z[4],-3Y);
dot("$z_5$",z[5],-3Y);
dot("$z_6$",z[6],3X);
dot("$z_7$",z[7],-3Y);
dot("$z_8$",z[8],-3Y);
dot("$z_9$",z[9],3X);
