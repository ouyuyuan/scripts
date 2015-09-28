
// Description: example formula for logo ico
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
//     Created: 2013-07-23 08:21:33 CST
// Last Change: 2013-07-23 08:32:05 CST

import EmacsColors;
import myfunctions;
import latexpre;

string text = "$ \frac{\partial\int_{p}^{p_{b}}\rho dp}{a\partial\varphi}$";

pair pos = (0,0);

label(scale(3.5)*text,pos);
myshipout("png","pcom");
