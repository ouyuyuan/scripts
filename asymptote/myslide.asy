
// Description: slide module
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-09 10:06:32 CST
// Last Change: 2012-12-31 18:20:57 CST

import mycolor;
import EmacsColors;
//import latexpre; // Can't do this way, use "include" in the specific slide
import myfunctions;

// global setting for slides
defaultpen(fontsize(18pt));
settings.outformat="pdf";

struct outline {
    string title = "";
    int level = 1;
    int pagestart = 1;
}

pen slidebg = hsv(214, 0.21, 0.93);

real slidex = 38cm;
real slidey = 24cm;

pair pagenumberpos = (slidex*3.9/4, slidey*0.1/4);

// fill the whole slide with background color
void fillslide(bool shade = true) {
    pair m = (0,0), M = (slidex, slidey);
    if (shade) {
        axialshade(box(m,M), slidebg, (0,0), ghostwhite, (0,slidey));
//        pair p = (0, slidey/2);
//        axialshade(box(p,M), slidebg, p, ghostwhite, (0,slidey));
//        pair p = (slidex, slidey/2);
//        fill(box(m,p), slidebg);
    } else {
        fill(box(m,M), slidebg);
    }
}

// draw underscore line of a picture
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

// label a title for a slide
void title( string title = "") {
    picture pic;

    real h = 239, s = 0.65, v = 0.47;
    pen drawpen = hsv(h, s, v);
    pen shadedeep = drawpen;
//    pen shadeshallow = hsv(h, s*2.5/4, v+ (1-v)*3.5/4);
    pen shadeshallow = aliceblue;

    fillslide();

    label(pic, scale(2)*("\bf "+title), drawpen);

    underscore(pic, shadedeep, shadeshallow);

    pair tipos = (slidex*2.0/4, slidey * 3.75/4);
    add(pic, tipos);
}

// mark pagenumber
void pagenumber( int page ) {
    string s = "$\cdot " + (string) page + " \cdot $";
    label(scale(1.3)*s, pagenumberpos);
}

// make a cover-slide
void cover(string title="", bool shade=true) {
    fillslide(shade);

    picture picti;
    label(picti, scale(2.5)*("\bf "+title));

    pair tipos = (slidex/2, slidey * 2/3);
    add(picti, tipos);

    if (title=="Daily Analysis") {
        label("\bf Give me another chance, I will spare no effort.
        --Qin Xingui", tipos, 
            5S, myred+fontsize(25));
    }

    picture PicAu = sign_ouyuyuan_cn();
    pair aupos = (slidex/2 - 2cm, slidey * 1.2/3);
    add(PicAu, aupos);

    string st = "\tt " + timestamp();
    pair tpos = (slidex/2, slidey * 1.2/3);
    label(scale(1.5)*st, tpos);
}

picture outline(outline[] entrys) {
    picture pic;

    real rowwid = 1.3cm;
    real colwid = 1.5cm;

    pen secpen = hsv(239, 0.65, 0.47);
    pen subpen = hsv(214, 0.9, 0.8);
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
    underscore(picti, shallow=slidebg);
    
    add(picti, (slidex*2.0/4, slidey*3.6/4));

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
    axialshade(picol, a--b, stroke=true, myblue+linewidth(verw), a, aliceblue, b);
    axialshade(picol, c--b, stroke=true, myblue+linewidth(verw), c, aliceblue, b);

    real sep = 1cm;
    add(picol, picl.fit(), b, sep*W);
    add(picol, picr.fit(), b, sep*E);

    pair olpos = (slidex*2.0/4, slidey * 2.0/4);
    add(picol.fit(), olpos);
}

// write text on a picture
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
//    axialshade(pic, g, slidebg, c, aliceblue, m+(0,y)); // left lighted
    axialshade(pic, g, slidebg, c, aliceblue, M); // up lighted
//    axialshade(pic, gl, slidebg, m, aliceblue, m+(x/2,0));
//    axialshade(pic, gr, slidebg, m+(x,0), aliceblue, m+(x/2,0));

    guide gb = a--b--c--m--cycle;
    guide gr = c--b--d--M--cycle;

    axialshade(pic, gb, myblue, c, slidebg, m);
    axialshade(pic, gr, myblue, c, slidebg, M);

    return pic;
}
