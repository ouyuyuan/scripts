
// Description: standard graph package
//
//   @hierarchy: Graph Module | a
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-15 21:36:34 CST
// Last Change: 2012-12-03 16:04:03 CST

import myslide;
import graph;

include "latexpre.asy";

fillslide();
title("\bf Text and Scientific Style");

// text style function
//--------------------------------------------------------------------
picture picTsf;
size(picTsf, slidex*1.0/4);
pair posTsf = (slidex*0.6/4, slidey*1.5/4);

real f(real x) { return exp(x); }
pair F(real x) { return (x, f(x)); }

guide g = graph(f, -4, 2, operator ..);
draw(picTsf, g);

xaxis(picTsf, "$x$");
yaxis(picTsf, "$y$", 0);
labely(picTsf, 1, E);
label(picTsf, "$e^x$", F(1), SE);
add(scale(1.1)*picTsf.fit(), posTsf, N);
label(scale(1.5)*"{\color{red} \em (manual, 2004, P.102)}", posTsf, S);

// scientific style function
//--------------------------------------------------------------------
picture picSci;
real sizex = slidex*1.0/4;
pair posSci = (slidex*2.5/4, slidey*0.6/3);

add(scale(1.2)*picSci.fit(), posSci, N);
label(scale(1.0)*graphic("scientific-style-func.eps", "width=23cm"), posSci, N);
label(scale(1.5)*"{\color{red} \em (manual, 2004, P.103)}", posSci, S);
pagenumber(08);

shipout("slide-08.pdf");

