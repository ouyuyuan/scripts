
// Description: module for draw variables
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-10-13 14:40:13 CST
// Last Change: 2012-10-24 17:11:15 CST

// scalar variable structure
struct scalar {
    string label;
    real l, w;

    real pw=0.5, deg=45; // shadow slant scale, 0.5w, 45 degree
    real lent=2; // axis tick length
    real ps=0.3; // axis separation scale between array ps*w

    string[] idx={"",""}; // index in array

    picture pic;

    // draw scalar node
    void draw(pen fillpen=nullpen, real l=l, real w=w) {

        label(pic, "\ttfamily "+this.label, (l/2,w/2));
        if( label == "..." ) { return; }

        filldraw(pic, box((0,0),(l,w)), fillpen);

        // cubic shadow
        pair a = (0,w), b = (l,w);
        pair d = (pw*w*Cos(deg), a.y+pw*w*Sin(deg));
        pair c = d + (b-a);
        pair e = (l,0);
        pair f = c + e-b;
        guide up = a--b--c--d--cycle;
        guide ri = e--f--c--b--cycle;
        filldraw(pic, up, gray(0.8)+fillpen);
        filldraw(pic, ri, gray(0.6));
    }

    // draw x axis
    void drawx(string axis="b") {

        if (axis == "") { return; }

        real sep = ps*w; // separation between axis and array
        real len = sep + 2l; 

        guide g = (0,0)--len*(1,0);
        guide gt = (0,0)--lent*(0,-1);

        pair o = (-sep,-sep);

        // axis place on top
        if ( find(axis,"t") == 0 ) { 
            pair a = (0.5pw*w*Cos(deg), 0.5pw*w*Sin(deg));
            o = o + (0,w+sep) + a; 
            gt = (0,0)--lent*(0,1);
        }

        pen drawpen = black;
        if (label == "...") { drawpen = dotted; }

        if (find(axis,"r") == 1) {
            draw(pic, shift(o)*g, drawpen, Arrow(5));
        } else {
            draw(pic, shift(o)*g, drawpen);
        }

        draw(pic, shift(o)*shift(sep)*gt);
        draw(pic, shift(o)*shift(sep+l)*gt);

        // label first dimension
        string id = idx[0];
        if ( length(id) > 0 ) {
            pair pos = o + (sep+l/2,0);
            pair dir = S;
            pair rot = SE;
            if ( length(id) > 2 ) { 
                if (find(axis,"t") == 0) { dir = N; rot = NE; }
                label(pic, Label("\sffamily "+id, Rotate(rot)), pos, dir);
            } else {
                label(pic, idx[0], pos, dir);
            }

            if (find(axis,"r",1) == 1) { 
                label("1st",o+(len,0),E);
            }
        }
    }

    // draw y axis
    // axis = uu,dd: 
    // uu: more top, direct up, dd: more bottom, direct down
    void drawy(string axis="u") {

        if (axis == "") { return; }

        real sep = ps*w; // separation between axis and array
        real len = sep + 2w; 

        guide g = (0,0)--len*(0,1); // default up
        guide gt = (0,0)--lent*(-1,0);

        pair o = (-sep,-sep);
        pair a = (0.5pw*w*Cos(deg), 0.5pw*w*Sin(deg));

        pen drawpen = black;
        if (label == "...") { drawpen = dotted; }

        // more on bottom
        if (find(axis,"d",0) == 0) {
            o = o + (0,w+sep) + a; 
            g = rotate(180)*g;
            if ( find(axis,"d",1) == 1 ) { 
                draw(pic, shift(o)*g, drawpen, Arrow(5));
            } else {
                draw(pic, shift(o)*g, drawpen);
            }
            draw(pic, shift(o)*shift(0,-a.y)*gt);
            draw(pic, shift(o)*shift(0,-a.y-w)*gt);
        } else { 

            if (find(axis,"u",1) == 1) {
                draw(pic, shift(o)*g, drawpen, Arrow(5));
            } else {
                draw(pic, shift(o)*g, drawpen);
            }
            draw(pic, shift(o)*shift(0,sep)*gt);
            draw(pic, shift(o)*shift(0,sep+w)*gt);
        } 

        // label second dimension
        string id = idx[1];
        if ( length(id) > 0 ) {
            pair dir = W;
            pair pos;
            if (find(axis,"u") == 0) { 
                pos = o + (0,sep+w/2);
            } else {
                pos = o + (0,-sep-w/2);
            }

            if ( length(id) > 2 ) { 
                label(pic, Label("\sffamily "+id), pos, dir);
            } else {
                label(pic, idx[0], pos, dir);
            }

            if (find(axis,"u",1) == 1) { 
                label("2nd",o+(0,len),dir);
            }
            if (find(axis,"d",1) == 1) { 
                label("2nd",o+(0,-len),dir);
            }
        }

    }

}

// draw scalar
void draw(picture pic=currentpicture, scalar nd, string[] axes={"",""},
    pen fillpen=nullpen) {

    nd.draw(fillpen);
    nd.drawx(axes[0]);
    nd.drawy(axes[1]);
    add(pic, nd.pic);
}

// construct a scalar variable
scalar scalar(string label) {

    scalar nd;
    nd.label = label;

    picture pic;
    label(pic, label);
    pair m = min(pic);
    pair M = max(pic);

    nd.l = M.x - m.x;
    nd.w = M.y - m.y;

    return nd;
}

///////////////////////////////////////////////////////////////////

// array structure
struct array {
    scalar[] arr;
    real l, w;
    picture pic;

    // draw array by invoking scalar draw
    void draw(pen fillpen=nullpen, string[] axes={"",""}, 
        int start=1, string endstr="") {
        
        // unify scalar l, w
        real per = l/arr.length;
        for (int i=0; i<arr.length; ++i) {
            arr[i].l = per;
            arr[i].w = w;
            arr[i].draw(fillpen);
            arr[i].drawx(axes[0]);
            arr[i].drawy(axes[1]);

            add(pic, shift(i*per) * arr[i].pic);
        }
    }

    // draw x axis
//    void draw(string[]

//        if ( axe != "" ) {
//            real ticklen = 2;
//            guide g = (0,0)--(per,0);
//            pair tickdir = S; 

//            real sep = 0.3w; // separation between axe and array 
//            guide overhead = sep*W--(0,0);

            // get axes tick label array
//            string[] ticklab;
//            for (int i=0; i<arr.length; ++i) {
//                    ticklab.push((string)(i+start));
//            }
//            if ( endstr != "") {
//                ticklab[arr.length-1] = endstr;
//                for ( int i=arr.length-2; i>0; --i) {
//                    if ( arr[i].label == "..." ) {
//                        ticklab[i] = "";
//                        break;
//                    } else {
//                        int j = arr.length-1 - i;
//                        ticklab[i] = endstr + " - " + (string) j; 
//                    }
//                }
//            }


            // draw axe
//            for (int i=0; i<arr.length; ++i) {
//                pair sh = (i*per, 0) + sep*tickdir;
//                
//                if ( axe == "u" ) {
//                    real r = 0.5*arr[i].pw * arr[i].w;
//                    real x = r * Cos(arr[i].deg);
//                    real y = r * Cos(arr[i].deg);
//                    sh = (0,w) + (x,y) + (i*per,0);
//                    
//                    tickdir = N;

//                    real dr = r/2 * Cos(arr[i].deg);
//                    overhead = (dr+sep)*W--(0,0);
//                }
//                pen drawpen;

//                if (arr[i].label == "...") {
//                    drawpen = dotted;
//                } else {
//                    drawpen = black;
//                }

//                guide tick = sh--(sh + ticklen*tickdir);
//                draw(pic, shift(sh) * g, drawpen);
//                draw(pic, tick);
                
                // draw arrow
//                if ( i == arr.length - 1 ) {
//                    draw(pic, shift(sh+(per,0)) * g, drawpen, Arrow(6));
//                    draw(pic, shift(per) * tick);
//                }

                // draw overhead
//                if ( i == 0 ) {
//                    draw(pic, shift(sh) * overhead, drawpen);
//                }

//                pair tickpos = sh + (per/2,0);
//                if ( length(ticklab[i]) < 3 ) {
//                    label(pic, ticklab[i], tickpos, tickdir);
//                } else {
//                    pair di = SE;
//                    if ( axe == "u" ) { di = NE; };
//                    label(pic, Label("\sffamily "+ticklab[i], Rotate(di)), 
//                        tickpos, tickdir);
//                }
//            }
//        }
//    }
}

// draw array
void draw(picture pic=currentpicture, array arr, 
    pen fillpen=nullpen, string[] axes={"",""},
        int start=1, string endstr="") {

    arr.draw(fillpen, axes, start, endstr);
    add(pic, arr.pic);
}

// create a array structure
array array(string[] labels) {

    array arr;

    for (string s : labels) {
        arr.arr.push(scalar(s));
    }

    real l=0, w=0;
    for (scalar sc : arr.arr) {
        if ( sc.l > l ) { l = sc.l; }
        if ( sc.w > w ) { w = sc.w; }
    }

    arr.l = l*arr.arr.length;
    arr.w = w;

    return arr;
}

////////////////////////////////////////////////////////

// 2d array structure
struct array2d {
    array[] arr;
    real l, w;
    picture pic;

    // draw 2d array by invoking array draw
    void draw(pen fillpen=nullpen, string axe="",
        int[] start={1,1}, string[] endstr={"",""}) {
        
        real per = w/arr.length;
        for (int i=0; i<arr.length; ++i) {
            arr[i].l = l;
            arr[i].w = per;
            arr[i].draw(fillpen);
            add(pic, shift(0,-i*per) * arr[i].pic, above=false);
        }
    }
}

// draw 2d array
void draw(picture pic=currentpicture, array2d arr, 
    pen fillpen=nullpen) {

    arr.draw(fillpen);
    add(pic, arr.pic);
}

// create a 2d array structure
array2d array2d(string[][] labels) {

    array2d arr;

    for (string[] s : labels) {
        arr.arr.push(array(s));
    }

    real l=0, w=0;
    for (array a : arr.arr) {
        if ( a.l > l ) { l = a.l; }
        if ( a.w > w ) { w = a.w; }
    }

    arr.l = l;
    arr.w = w*arr.arr.length;

    return arr;
}
