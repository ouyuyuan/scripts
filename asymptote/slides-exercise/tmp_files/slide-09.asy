
// Description: standard graph package
//
//   @hierarchy: Graph Module | Marker
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-15 21:36:34 CST
// Last Change: 2012-12-03 16:03:43 CST

import myslide;
import graph;

include "latexpre.asy";

fillslide();
title("\bf Markers");

pair posMar = (slidex*1.7/4, slidey*1.4/3);
label(scale(1.4)*graphic("marker-errorbar.eps", "width=20cm"), posMar, N);
label(scale(1.5)*"marker and errorbars {\color{red} \em (manual, 2004, P.107)}", posMar, S);

pair posCus = (slidex*1.7/4, slidey*0.2/3);
label(scale(1.0)*graphic("custom-marker.eps", "width=10cm"), posCus, N);
label(scale(1.5)*"customized marker{\color{red} \em (manual, 2004, P.108)}", posCus, S);
pagenumber(09);

shipout("slide-09.pdf");

