
// Description: custom mark routine, ref. manual p.108
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-11 20:00:39 CST
// Last Change: 2012-11-11 20:07:40 CST

import graph;

size(8cm, 6cm, IgnoreAspect);

markroutine marks() {
    return new void (picture pic=currentpicture, frame f, guide g) {
        guide p = scale(1mm)*unitcircle;
        for (int i=0; i<length(g); +=i) {
            pair z = point(g, i);
            if (i%4 == 0) {
                fill(f, p);
                add(pic, f, z);
            } else {
                if (z.y > 50) {
                    pic.add(new void (frame F, transform t) {
                        guide q = shift(t*z)*p;

