
// Description: pattern usage, Ref. Manual P.42
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-10 15:07:46 CST
// Last Change: 2012-11-10 15:42:41 CST

from myfunctions access myshipout;
import patterns;

size(0,100);

add("hatch",hatch());
add("hatchback",hatch(NW));
add("crosshatch",crosshatch(3mm));

real s=1.25;

filldraw(unitsquare,pattern("hatch"));
filldraw(shift(s,0)*unitsquare,pattern("hatchback"));
filldraw(shift(2s,0)*unitsquare,pattern("crosshatch"));

myshipout();
