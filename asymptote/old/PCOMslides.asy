
// Description: total and meaningful lines of PCOM source code
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-10-06 20:45:24 CST
// Last Change: 2012-11-04 15:36:29 CST

import myfunctions;
import codeanalysis;
import mycolor;

real slidex=32cm, slidey=24cm;

defaultpen(fontsize(18pt));
picture[] slides;

string datadir  = "/home/ou/archive/data/";
string datafile = datadir + "analysisPCOM.dat";

string[] names  = read_string(datafile,0);
int[] total     = read_int(datafile,1);
int[] mngful    = read_int(datafile,2); // meaningful lines

pen[] fpens     = {gray(0.2)+mybackground, myblue+mylightgreen};
pen[] dpens     = {black, black};
string[] desc   = {"total", "meaningful"}; // column description

// slide: meaningfull of total lines
///////////////////////////////////////////////////////////////
picture pic_mea;
pic_mea = draw_bars(names, total, mngful, fpens, dpens, desc);
slides.push(pic_mea);

// slide: understood of meaningful lines
//////////////////////////////////////////////////////////////
picture pic_und;
fpens[0] = gray(0.8)+myred;

int[] undstd = read_int(datafile,3); // understood lines
desc[0] = "meaningful";
desc[1] = "understood";

// print files contain question lines
int[] quest  = read_int(datafile,4); // question lines
string text  = "\bfseries Question Lines: \par ";

for (int i=0; i<quest.length; ++i) {
    if (quest[i] != 0) {
        text += "\ttfamily "+names[i]+": "+(string)quest[i]+" \par ";
    }
}
pic_und = draw_bars(names, mngful, undstd, fpens, dpens, desc,
    text=text, textpen=red);

slides.push(pic_und);

// concatenate slides
//////////////////////////////////////////////////////////////
for (int i=0; i<slides.length; ++i) {
    if (i>0) { newpage(); }
    size(slides[i],slidex,slidey,keepAspect=false); 
    add(slides[i].fit(), Fill(mybackground));
}

shipout("img/"+outprefix());
