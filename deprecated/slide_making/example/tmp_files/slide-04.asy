
// Description: creative examples from other people
//
//  @hierarchy: Creative Examples | Geometry
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-15 19:29:54 CST
// Last Change: 2012-11-17 16:19:11 CST

import myslide;
import mypictures;

include "latexpre.asy";

fillslide();

title("\bf Geometry");

// triangle in a circle
pair posTri = (slide.x*1.1/4, slide.y*1.1/4);
label(graphic("note-triangle.eps", "width=18cm"), posTri, N);
label(scale(1.5)*"{\color{red} \em (莫图, 2007, P.9)}", posTri, S);

// Pythagorean
picture picPyt = pythagoreanProve();
size(picPyt, 12cm);
pair posPyt = (slide.x*3.1/4, slide.y*0.4/4);
add(picPyt.fit(), posPyt, N);
label(scale(1.5)*"{\color{red} \em (刘海洋, 2009, P.3)}", posPyt, S);
pagenumber(04);

shipout("slide-04.pdf");

