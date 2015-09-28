
// Description: standard graph package
//
//   @hierarchy: Graph Module | c
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-20 14:25:49 CST
// Last Change: 2012-12-03 16:03:33 CST

import myslide;
import graph;

include "latexpre.asy";

fillslide();
title("\bf Legend and Tick and Column Data");

pair posLeg = (slide.x*1.0/4, slide.y*0.8/3);
label(scale(1.4)*graphic("multi-entry-legend.eps", "width=10cm"), posLeg, N);
label(scale(1.5)*"multi-legend {\color{red} \em (manual, 2004, P.104)}", posLeg, S);

pair posTic = (slide.x*3.1/4, slide.y*1.5/3);
label(scale(1.4)*graphic("custom-tick.eps", "width=9cm"), posTic, N);
label(scale(1.5)*"custom-tick {\color{red} \em (manual, 2004, P.104)}", posTic, S);

pair posCol = (slide.x*2.5/4, slide.y*0.2/3);
label(scale(1.4)*graphic("column-file-data.eps", "width=8cm"), posCol, N);
label(scale(1.5)*"column-data {\color{red} \em (manual, 2004, P.105)}", posCol, S);
pagenumber(11);

shipout("slide-11.pdf");

