
// Description: schematic of ROMS's nested grids
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2014-05-12 19:43:36 BJT
// Last Change: 2014-05-12 20:21:12 BJT

from myfunctions access myshipout;
import EmacsColors;

unitsize(4cm);

pair A = (0,0);
pair B = (0,1);
pair C = (2,1);
pair D = (2,0);

path grid1 = A--B--C--D--cycle;

filldraw(grid1, LightSteelBlue1, LightSteelBlue4 + 2*linewidth());
label(scale(2)*"1", B, SE);

myshipout("png", "roms");
