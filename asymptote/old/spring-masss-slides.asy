
// Description: Model of Mass on a spring 
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-10-27 09:04:31 CST
// Last Change: 2012-10-27 10:09:28 CST

orientation=Landscape;

import slide;
import mycolor;

viewportsize=pagewidth-2pagemargin;

usepackage("mflogo"); //<> metapost, metafont logo fonts

fill(background,box((-1,-1),(1,1)),mybackground);

titlepage(title="Model of mass-spring",
          author="OU Yuyuan",
          institution="LASG/IAP/CAS",
          date="\today");

title("Mass on a spring");
figure("img/MassOnSpring.eps","width=10cm");

shipout("img/"+outprefix());
