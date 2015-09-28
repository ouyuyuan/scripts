
// Description: Code Analysis Module
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-10-11 10:29:04 CST
// Last Change: 2012-10-26 18:43:00 CST

import mycolor;

// draw a horizontal bar with two partition
picture draw_bar(real[] lengths, string[] lr_str, 
    pen[] fillpens, pen[] drawpens, real width=1) {

    picture pic;
    real pw  = 0.5, deg=45; // shadow slant scale, 0.5*width, 45 degree

    pair a = (0, 0);
    pair b = (lengths[0], width);
    pair c = (lengths[1], width);
    filldraw(pic, box(a,b), fillpens[0], drawpens[0]);
    filldraw(pic, box(a,c), fillpens[1], drawpens[1]);

    pair l = (0, width/2);
    pair r = (lengths[0], width/2) + pw*width*(Cos(deg),Sin(deg)); 
    label(pic, "\ttfamily "+lr_str[0], l, W);
    label(pic, "\ttfamily "+lr_str[1], r, E);

    // cubic shadow
    pen fillpen = gray(0.4)+fillpens[1];
    a = shift(0,width)*a;
    pair c = b + pw*width*(Cos(deg),Sin(deg));
    pair d = shift(-lengths[0], 0)*c;
    guide up = a--b--c--d--cycle;
    filldraw(pic, up, gray(0.8)+fillpen);

    pair e = shift(0,-width)*b;
    pair f = shift(0,-width)*c;
    guide up = e--f--c--b--cycle;
    filldraw(pic, up, gray(0.5));

    return pic;
}

// draw a series bars for N files
picture draw_bars(string[] names, int[] cnts, int[] parts, 
    pen[] fillpens, pen[] drawpens, string[] means,
    string text="", pen textpen=black, real width=1, int per=100) {

    picture pic;

    // draw bars
    for (int i = names.length-1; i>=0; --i) {

        string[] lrs = { names[i], 
            (string)parts[i]+", "+(string)cnts[i] };
        real[] lens  = { cnts[i]/per, parts[i]/per };

        picture pic2 = draw_bar(lens, lrs, fillpens, drawpens);
            
        real h = (names.length-1 - i) * width;
        add(pic, shift(0,h) * pic2);
    }

    // draw square representing total
    picture pic3;
    real r = sqrt(sum(cnts) / per);
    real p = (sum(parts) / per) / r;

    filldraw(pic3, box((0,0),(r,r)), fillpens[0], drawpens[0]);
    filldraw(pic3, box((0,0),(p,r)), fillpens[1], drawpens[1]);

    // cubic shadow
    {
        pen fillpen = gray(0.4)+fillpens[1];
        pair a = (0,0), b = (r,r);
        real width = r;

        real pw  = 0.5, deg=45;
        a = shift(0,width)*a;
        pair c = b + pw*width*(Cos(deg),Sin(deg));
        pair d = shift(-r, 0)*c;
        guide up = a--b--c--d--cycle;
        filldraw(pic3, up, gray(0.8)+fillpen);

        pair e = shift(0,-width)*b;
        pair f = shift(0,-width)*c;
        guide up = e--f--c--b--cycle;
        filldraw(pic3, up, gray(0.5));
    }

    label(pic3, "\bfseries "+means[1]+" and "+means[0]+" lines", (r/2,
        r+1), Fill(mybackground));
    label(pic3, "TOTAL:", (r/2, r/2));
    label(pic3, "$"+(string)sum(parts)+", "+(string)sum(cnts)+"$", (r/2, r/2-1));

    real a = cnts[cnts.length-1]/per - 2; // above longest
    real b = 3 * width;
    add(pic, shift(a,b) * pic3);

    // draw text as minipage
    if (length(text) != 0) {
        pair p = (a,b+r+3);
        label(pic, minipage(text,6cm),p,NE,textpen);
    }

    return pic;
}
