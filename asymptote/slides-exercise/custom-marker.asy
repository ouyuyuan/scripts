
// Description: Customize marker, ref. manual p.108
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-21 10:42:26 CST
// Last Change: 2012-11-21 21:20:48 CST

import graph;
import mycolor;
from myfunctions access myshipout;

picture pic;

real xsize = 8cm;
real ysize = 6cm;

size(pic, xsize, ysize, IgnoreAspect);
markroutine marks() {
    return new void(picture pic=currentpicture, frame f, path g) {
        path p=scale(1mm)*unitcircle;
        for(int i=0; i <= length(g); ++i) {
            pair z=point(g,i);
            frame f;
            if(i % 4 == 0) {
                fill(f,p);
                add(pic,f,z);
            } else {
                if(z.y > 50) {
                    pic.add(new void(frame F, transform t) {
                        path q=shift(t*z)*p;
                        unfill(F,q);
                        draw(F,q);
                    });
                } else {
                    draw(f,p);
                    add(pic,f,z);
                }
            }
        }
    };
}

pair[] f={(5,5),(40,20),(55,51),(90,30)};
draw(graph(f),marker(marks()));
scale(true);
xaxis("$x$",BottomTop,LeftTicks);
yaxis("$y$",LeftRight,RightTicks);

myshipout();
