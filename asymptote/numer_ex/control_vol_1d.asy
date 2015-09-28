
// Description: schematic of control volume in 1-D
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-06-01 08:47:25 CST
// Last Change: 2013-06-01 18:59:13 CST

from myfunctions access myshipout;
import EmacsColors;
import latexpre;

// def. var <<<1

real width = 3cm, height = 2.0cm;

pair A = (0,0);
pair B = (width,0);
pair A1 = (0,height);
pair B1 = (width,height);

// the volume <<<1

draw(A--B, dashed);
draw(A1--B1, dashed);
draw(A--A1);
draw(B--B1);
fill( box(A,B1), aliceblue );

string title = "Control volume in 1-D";
pair pos = (A1+B1)/2;
label(scale(1.1)*title, pos, N*0.1cm);

pair C = (A+A1)/2 + 1.5*width*W;
pair D = (B+B1)/2 + 1.5*width*E;
draw(C--D);

// points <<<1

pair P = (A+B)/2 + N*height/2;
dot("$P$", P, S);

pair P = (A+A1)/2;
dot("$w$", P, SW);
dot("$W$", P + width*W, S);

pair P = (B+B1)/2;
dot("$e$", P, SE);
dot("$E$", P + width*E, S);

// flux arrows <<<1

pair C = A + (A1-A)/4 + (width/4)*W;
pair D = A + (A1-A)/4 + (width/4)*E;
draw(C--D, Arrow(TeXHead));
label("diffusion", C, W);

pair C = A + (A1-A)*3/4 + (width/4)*W;
pair D = A + (A1-A)*3/4 + (width/4)*E;
draw(C--D, Arrow);
label("convection", C, W);

pair C = B + (B1-B)/4 + (width/4)*E;
pair D = B + (B1-B)/4 + (width/4)*W;
draw(C--D, Arrow(TeXHead));
label("diffusion", C, E);

pair C = B + (B1-B)*3/4 + (width/4)*E;
pair D = B + (B1-B)*3/4 + (width/4)*W;
draw(C--D, Arrow);
label("convection", C, E);


myshipout("png","numer_ex");
