
// Description: text style function, ref manual P.102 
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-02 16:39:31 CST
// Last Change: 2012-11-02 17:00:45 CST

import graph;

size(200,0);

real f(real x) { return exp(x); }
pair F(real x) { return (x, f(x)); }

guide g = graph(f, -4, 2, operator ..);
draw(g);

xaxis("$x$");
yaxis("$y$", 0);
labely(1,E);
label("$e^x$", F(1), SE);

shipout("img/" + outprefix());
