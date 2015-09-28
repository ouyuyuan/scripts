
// Description: module
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-09 10:06:32 CST
// Last Change: 2013-12-21 07:11:13 BJT

import mycolor;
import EmacsColors;
//import latexpre; // Can't do this way, use "include" in the specific slide
import myfunctions;

// global setting of slides <<<1

defaultpen(fontsize(18pt));
settings.outformat="pdf";

struct outline {
    string title = "";
    int level = 1;
    int pagestart = 1;
}

struct slide {
   string type = "";
   pen bg = hsv(214, 0.21, 0.93);
   real x = 38cm;
   real y = 24cm;
   pair pagepos;
}
slide slide; // variable "slide" with type "slide"
include slide_config;

// tweak config <<<2

// background color
if (slide.type == "scientific") {
   slide.bg = white;
}

// x,y portion
if (slide.type == "scientific") {
   slide.x = 32cm;
   slide.y = 24cm;
}

// page number position
slide.pagepos = (slide.x*3.9/4, slide.y*0.1/4);

//write(slide.type);

// fill background color <<<1

void fillslide(bool shade = true) {
    pair m = (0,0), M = (slide.x, slide.y);
    if (shade) {
        axialshade(box(m,M), slide.bg, (0,0), ghostwhite, (0,slide.y));
//        pair p = (0, slide.y/2);
//        axialshade(box(p,M), slide.bg, p, ghostwhite, (0,slide.y));
//        pair p = (slide.x, slide.y/2);
//        fill(box(m,p), slide.bg);
    } else {
        fill(box(m,M), slide.bg);
    }
}

// draw underscore line of a picture <<<1

void underscore(picture pic, pen deep=black, pen shallow=gray) {
    pair m=min(pic);
    pair M=max(pic);

    real x = size(pic).x;
    real y = size(pic).y;

    real extra = 1mm;
    pair a = m; a = extra*SW + a;
    pair b = shift(x) * m; b = extra*SE + b;
    pair c = (a+b)/2;
    guide ga = a -- c;
    guide gb = c -- b;

    axialshade(pic, ga, stroke=true, shallow+linewidth(1mm), a, deep, c);
    axialshade(pic, gb, stroke=true, shallow+linewidth(1mm), b, deep, c);
}

// slide title <<<1

void title( string title = "") {
    picture pic;

    real h = 239, s = 0.65, v = 0.47;
    pen drawpen, shadedeep, shadeshallow;
    if (slide.type == "scientific") {
       drawpen = black;
       shadedeep = black;
       shadeshallow = white;
    } else {
       drawpen = hsv(h, s, v);
       shadedeep = drawpen;
//       shadeshallow = hsv(h, s*2.5/4, v+ (1-v)*3.5/4);
       shadeshallow = aliceblue;
   }

    fillslide();

    label(pic, scale(2)*("\bf "+title), drawpen);

    if (slide.type == "scientific") {
//    underscore(pic, shadedeep, shadeshallow);
    } else {
      underscore(pic, shadedeep, shadeshallow);
    }

    pair tipos = (slide.x*2.0/4, slide.y * 3.75/4);
    add(pic, tipos);
}

// mark pagenumber <<<1

void pagenumber( int page ) {
    string s = "$\cdot " + (string) page + " \cdot $";
    label(scale(1.3)*s, slide.pagepos);
}

// make a cover-slide <<<1

void cover(string title="", bool shade=true) {
    fillslide(shade);

    picture picti;
//    string text = minipage(("\center " + title),10cm);
    string text = minipage(("\center " + title),12cm);
    label(picti, scale(2.5)*("\bf " + text));

    pair tipos = (slide.x/2, slide.y * 2/3);
    add(picti, tipos);

    if (title=="Daily Analysis") {
        label("\bf Give me another chance, I will spare no effort.
        --Qin Xingui", tipos, 
            5S, myred+fontsize(25));
    }

   if (slide.type == "scientific") {
       string au = "\bf OU, Niansen";
       pair aupos = (slide.x/2, slide.y * 1.5/3);
       label(scale(1.5)*au, aupos);
   } else {
      picture PicAu = sign_ouyuyuan_cn();
      pair aupos = (slide.x/2 - 2cm, slide.y * 1.5/3);
      add(PicAu, aupos);
   }

//    time("%Y-%m-%d %H:%M:%S BJT");
    string st = "\tt " + time("%B %-d, %Y");
    pair tpos = (slide.x/2, slide.y * 1.2/3);
    label(scale(1.5)*st, tpos);
}

picture outline(outline[] entrys) {
    picture pic;

    real rowwid = 1.3cm;
    real colwid = 1.5cm;

   pen secpen, subpen;
    if (slide.type == "scientific") {
       secpen = black;
       subpen = black;
    } else {
       secpen = hsv(239, 0.65, 0.47);
       subpen = hsv(214, 0.9, 0.8);
    }

    pen drawpen;

    for (int i=0; i<entrys.length; ++i)
    {
        string ti = "\bf " +  entrys[i].title;
        int le = entrys[i].level;
        pair enpos = (colwid * (le-1), -rowwid * i);
        
        drawpen = secpen;
        if ( le == 2 ) { drawpen = subpen; };

        label(pic, ti, enpos, E, drawpen+fontsize(30));
    }

    // mark page number
    real widpic = abs( max(pic).x - min(pic).x );
    for (int i=0; i<entrys.length; ++i)
    {
        int le = entrys[i].level;
        int st = entrys[i].pagestart;

        pair a = (colwid * (le-1) + 0.5cm, -rowwid * i);
        pair b = a + (widpic - a.x + 3cm, 0);

        drawpen = secpen;
        if ( le == 2 ) drawpen = subpen;

        label(pic, "\tt "+(string)st, b+(1.4cm, 0), W, drawpen+fontsize(30)); 
    }

    return pic;
}

void outline(bool shade=true) {

    fillslide(shade);

    picture picti;
    string ol = "\bf Outline";
    label(picti, scale(3)*ol, (0,0));
    underscore(picti, shallow=slide.bg);
    
    add(picti, (slide.x*2.0/4, slide.y*3.6/4));

    outline[] entrys; include "outline.asy";

    int half = round(entrys.length/2);
    outline[] halfentrys;
    for (int i=0; i<half; ++i) {
        halfentrys.push(entrys[0]);
        entrys.delete(0);
    }

    picture picl = outline(halfentrys);
    picture picr = outline(entrys);

    // vertical seperated line
    real olhei = size(picl).y;
    pair a = (0,olhei/2), b = (0,0), c = (0,-olhei/2);
    picture picol;
    real verw = 1mm;

    pen pena, penb;
    if (slide.type == "scientific") {
       pena = black;
       penb = white;
    } else {
       pena = myblue;
       penb = aliceblue;
    }

    axialshade(picol, a--b, stroke=true, pena + linewidth(verw), a, penb, b);
    axialshade(picol, c--b, stroke=true, pena + linewidth(verw), c, penb, b);

    real sep = 1cm;
    add(picol, picl.fit(), b, sep*W);
    add(picol, picr.fit(), b, sep*E);

    pair olpos = (slide.x*2.0/4, slide.y * 2.0/4);
    add(picol.fit(), olpos);
}

// write text on a picture <<<1

picture textPatch (string s, real width=5cm) {
    picture pic;

    label(pic, minipage("\center "+s,width));

    pair m=min(pic);
    pair M=max(pic);

    real x = size(pic).x;
    real y = size(pic).y;

    pair a = shift(1mm*SE) * m;
    pair b = shift(x)  * a;
    pair c = shift(x)  * m;
    pair d = shift(0,y)  * b;

    guide g = box(m, M);
    guide gl = box(m, (m.x+x/2, M.y));
    guide gr = box((m.x+x/2, m.y), M);
    draw(pic, g, myblue);
//    axialshade(pic, g, slide.bg, c, aliceblue, m+(0,y)); // left lighted
    axialshade(pic, g, slide.bg, c, aliceblue, M); // up lighted
//    axialshade(pic, gl, slide.bg, m, aliceblue, m+(x/2,0));
//    axialshade(pic, gr, slide.bg, m+(x,0), aliceblue, m+(x/2,0));

    guide gb = a--b--c--m--cycle;
    guide gr = c--b--d--M--cycle;

    axialshade(pic, gb, myblue, c, slide.bg, m);
    axialshade(pic, gr, myblue, c, slide.bg, M);

    return pic;
}
