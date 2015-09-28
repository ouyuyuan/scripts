
// Description: 
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-06-02 21:34:45 CST
// Last Change: 2013-06-08 09:21:44 CST

from myfunctions access myshipout;
import EmacsColors;
import latexpre;

// def. var <<<1


unitsize(5cm);

pair p0 = (0.0, 1.0);
pair p1 = (0.1, 0.9999);
pair p2 = (0.3, 0.9999);
pair p3 = (0.5, 0.9999);
pair p4 = (0.7, 0.9994);
pair p5 = (0.9, 0.8946);
pair p6 = (1.0, 0.0);

dot(p0);
dot(p1);
dot(p2);
dot(p3);
dot(p4);
dot(p5);
dot(p6);

pair c1 = p0;
pair c2 = 2*p1 - c1;
pair c3 = 2*p2 - c2;
pair c4 = 2*p3 - c3;
pair c5 = 2*p4 - c4;
pair c6 = 2*p5 - c5;

draw(p0..p1..p2..p3..p4..p5.. tension 3 ..p6);
draw(p0..controls(c1)..p1..controls(c2)..p2..controls(c3)..p3..controls(c4)..p4..controls(c5)..p5..controls(c6)..p6);

//draw((0,0)..controls(1,1) and (1.5,2) .. (2,0));
draw((0,0.5)..controls(2,0.5) .. (2,0.5));

myshipout("png","numer_ex");
