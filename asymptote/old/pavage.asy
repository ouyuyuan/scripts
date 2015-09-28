
// Description: 
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-15 14:41:42 CST
// Last Change: 2012-11-15 20:35:57 CST

import mycolor;

unitsize(0.5cm);

bool showlabel = false;
//bool showlabel = true;
// a pavage
pair a=(0,1.5), b=(0.5,-0.2), c=(0,0), d=(3,0);
guide leftside = a{SE}..tension 1.4..{dir(-150)}b..{NW}c;
guide bottomside = c{SE}..{dir(30)}b..{SE}d;
guide sides = leftside & bottomside & 
    shift(d)*reverse(leftside) & 
    shift(a)*reverse(bottomside) & cycle;
guide eye = circle((2.6,1.2), 0.1);
guide ear = (2.3,1.3) .. (2.1,1.5) .. (2.2,1.7) &
    (2.2,1.7) .. (2.4,1.6) .. (2.5,1.4);
guide nose = circle((3.5,0.5), 0.13);
guide mouth = (3,0.4) .. (3.4,0.1) .. (3.6,0.2);

pen fillpen, drawpen=linewidth(0.5mm);
int xdim = 3, ydim = 12, zdim = 3;
for (int z=0; z<zdim; ++z)
    for (int y=0; y<ydim; ++y){
        for ( int x=0; x<xdim; ++x){
            int c = (x+y+z)%3;
            if (c==0)
                fillpen = mylightred;
            else
                if (c==1)
                    fillpen = mylightblue;
                else
                    fillpen = mylightgreen;
//            fillpen = (x+y)%2==0? cyan:lightblue;
            transform position = shift((3*x+3*xdim*z,1.5y));
            filldraw(position*sides, fillpen, drawpen);
            fill (position * (eye ^^ nose));
            draw (position * (ear ^^ mouth), drawpen);
        }
    }
real width = 3*xdim*zdim, height = 1.5*ydim;
pair center = (width/2, height/2);
clip(ellipse(center, width/2 - 2, height/2 - 1));

if (showlabel) {
    label ("a",a);
    label ("b",b);
    label ("c",c);
    label ("d",d);
}
