
// Description: 天上是，亮晶晶，永灿烂，长安宁。
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-17 09:45:18 CST
// Last Change: 2012-11-15 20:46:12 CST

import mycolor;

pen[] colorpen = {mylightred, myorange, myyellow, mylightgreen, mycyan, mylightblue};
int n, ncolor, angle, nstar=200;
real R, x, y, Rdefault = 0.2, epsilon = 1.0e-6,
    xmin=0, xmax=14, ymin=0, ymax=10, bnd=Rdefault;
transform position;

unitsize(1cm);

srand(seconds());

guide star(int n=5, real R=Rdefault, real topangle=90)
{
    real theta = 180/n;
    real r = Cos(theta)<epsilon? 0 : Cos(2theta)*R/Cos(theta);
    if (r<=epsilon) r = R/4;
    guide g;

    if (n<3) return nullpath;

    for (int i=0; i<n; ++i) {
        pair a = dir(topangle+2*i*theta)*R;
        pair b = dir(topangle+(2i+1)*theta)*r;
        g = g -- a -- b;
    }
    g = g -- cycle;

    return g;
}

int rand(int a, int b)
// return an random integer between a and b
{
    return min(a,b) + rand() % (abs(a-b)+1);
}

real rand(real a, real b)
{
    return min(a,b) + unitrand()*abs(a-b);
}

// the background air
fill(box((xmin, ymin), (xmax, ymax)), black);

// stars
for (int i=0; i<nstar; ++i) {
    n        = rand(3, 5);
    R        = rand(0,Rdefault);
    angle    = rand(0,180);
    ncolor   = rand(0,colorpen.length-1);

    x        = rand(xmin+bnd,xmax-bnd);
    y        = rand(ymin+5*bnd, ymax-bnd);
    position = shift(x,y);

    if (R<0.1*Rdefault) 
        dot(position*(0,0), white+1bp);
    else 
        if (R<0.2*Rdefault)
            dot(position*(0,0), white+2bp);
        else
            fill(position*star(n, R, angle), colorpen[ncolor]);
}

// comet
real r = 0.3;
pair o = (xmin+5bnd+r, ymin+5bnd+r);

radialshade(circle(o,r), white, o, 0.2*r, black, o, r);
path tail = o{dir(70)} .. {dir(10)}(xmax/2+6bnd,ymax-6bnd);

for (real t=0; t<1; t += 1/2000) {
    real d = 0.2*r + t^3;
    pair c = (rand(-d,d),rand(-d,d));
    dot(point(tail,t^3)+c, white + 1bp);
}

// moon
picture bg, moon;
fill(moon, unitcircle, black);
fill(bg, unitcircle, yellow);
unfill(bg, shift(-0.4,-0.1)*unitcircle);
add(moon, bg);
add(shift(xmax-8bnd,ymax-6bnd)*moon);

// text
settings.tex="xelatex";
usepackage("xeCJK");
texpreamble("\setCJKmainfont[BoldFont={Adobe Heiti Std}, ItalicFont={Adobe Kaiti Std}]{Adobe Song Std}");
string text = minipage("天上星\par 亮晶晶\par 水中月\par 笑盈盈",2cm);
label(text, (xmin+6bnd,ymax-8bnd), orange+fontsize(0.6cm), Fill(black+opacity(0.6)));


