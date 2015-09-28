import math;
import mycolor;
from myfunctions access myshipout;

settings.tex="xelatex";
usepackage("xeCJK");
texpreamble("\setCJKmainfont[BoldFont={Adobe Heiti Std}, ItalicFont={Adobe Kaiti Std}]{Adobe Song Std}");

unitsize(1cm);

// grid function from math module
pen helpline = linewidth(0.2bp)+gray(0.7);
add (grid(7,7,helpline));
add (shift(4,0)*rotate(aTan(4/3))*grid(5,5,helpline));

// yellow box
fill(box((3,3),(4,4)), opacity(0.4)+myyellow);
label("黄实",(3.5,3.5));

// triangle
pair a=(4,0), b=(4,3), c=(0,3);
guide triangle = a--b--c--cycle;
pen fillpen=opacity(0.1)+myred;
pen drawpen=myred+0.4mm;
filldraw(triangle^^
         shift(c-a)*rotate(-90,a)*triangle^^
         shift((7,4)-a)*rotate(90,a)*triangle^^
         shift((3,4)-b)*rotate(-180,b)*triangle, fillpen, drawpen);
label("朱实",(2,4));
label("弦实",(5,4));
label(Label("勾三",Rotate(S)), a--b, LeftSide);
label("股四", c--b);
label(Label("弦五",Rotate((4,-3))), c--a, LeftSide);

myshipout();
