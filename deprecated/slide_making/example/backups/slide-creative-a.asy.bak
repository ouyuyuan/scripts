
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
pair posTri = (slidex*1.1/4, slidey*1.1/4);
label(graphic("note-triangle.eps", "width=18cm"), posTri, N);
label(scale(1.5)*"\citep[P.9]{Motu2007asy}", posTri, S);

// Pythagorean
picture picPyt = pythagoreanProve();
size(picPyt, 12cm);
pair posPyt = (slidex*3.1/4, slidey*0.4/4);
add(picPyt.fit(), posPyt, N);
label(scale(1.5)*"\citep[P.3]{Liu2009asy}", posPyt, S);
