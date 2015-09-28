
// Description: module of reuseable pictures
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-19 22:24:34 CST
// Last Change: 2012-11-19 22:24:34 CST

import math;
import mycolor;

include "latexpre.asy";

picture pythagoreanProve ()
{
    picture pic;
    unitsize(pic, 1cm);

    // grid function from math module
    pen helpline = linewidth(0.2bp)+gray(0.7);
    add (pic, grid(7,7,helpline));
    add (pic, shift(4,0)*rotate(aTan(4/3))*grid(5,5,helpline));

    // yellow box
    fill(pic, box((3,3),(4,4)), opacity(0.4)+myyellow);
    label(pic, "黄实",(3.5,3.5));

    // triangle
    pair a=(4,0), b=(4,3), c=(0,3);
    guide triangle = a--b--c--cycle;
    pen fillpen=opacity(0.1)+myred;
    pen drawpen=myred+0.4mm;
    filldraw(pic, triangle^^
             shift(c-a)*rotate(-90,a)*triangle^^
             shift((7,4)-a)*rotate(90,a)*triangle^^
             shift((3,4)-b)*rotate(-180,b)*triangle, fillpen, drawpen);
    label(pic, "朱实",(2,4));
    label(pic, "弦实",(5,4));
    label(pic, Label("勾三",Rotate(S)), a--b, LeftSide);
    label(pic, "股四", c--b);
    label(pic, Label("弦五",Rotate((4,-3))), c--a, LeftSide);
    
    return pic;
}
