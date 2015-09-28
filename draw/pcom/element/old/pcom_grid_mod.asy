
// Description: for drawing grids of PCOM
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
//     Created: 2013-06-23 09:51:50 CST
// Last Change: 2013-06-23 10:43:26 CST

import mycolor;

// structure <<<1

struct model {
    real dlat, dlon;
    real lat_min, lat_max, lon_min, lon_max;
    real dw;  // grid width for drawing
    picture pic;
}

// functions <<<1

// draw grids <<<2

void draw_grids(model md) {

    picture pic = md.pic;
    real dw = md.dw;

    int nlats = (int)((md.lat_max - md.lat_min) / md.dlat + 1);
    int nlons = (int)((md.lon_max - md.lon_min) / md.dlon + 1);

    real len = 8*md.dw;
//    real hlen = len + 2*md.dw; // lon. wrap up
    real hlen = len;

    guide line = (0,0)--len*(0,1);
    guide hline = (0,0)--hlen*(0,1);
    guide hori_line = (0,0)--(len)*(0,1);

    pen lonpen = black;
    pen latpen = black;

    // draw axes <<<3

    // horizontal
    real dh = -1.0cm;
    pair a = (0, dh);
    pair b = (8*dw, dh) + 3cm*E;
    draw(pic, a--b, Arrow);
    label(pic, "East", b, 0.2cm*E);
    label(pic, "Longitude", b+2cm*W, NE, lonpen);
    label(pic, "\tt array index", b+2cm*W, SE, lonpen);

    // vertical
    real dh = -2.0cm;
    pair a = (dh,0);
    pair b = (dh, 8*dw) + 2cm*N;
    draw(pic, a--b, Arrow);
    label(pic, "North", b, N);
    label(pic, "Latitude",  b+1cm*S, E, latpen);
    label(pic, "\tt array index", b+1cm*S, W, latpen);

    // left <<<3

    for (int i=0; i<3; ++i) {
        draw(pic, shift(i*dw,0)*line, lonpen);
        draw(pic, shift((i+0.5)*dw,0.5dw)*hline, dashed+lonpen);

        // label horizontal axis
        string lab = (string)(i*md.dlon+0.5) + "$^\circ$";
        pair pos = (i*dw, 0);
        label(pic, lab, pos, S, lonpen);
        label(pic, "\tt "+(string)(i+1+1), pos, 0.3cm*S, lonpen);
    }

    // bottom <<<3

    for (int i=0; i<3; ++i) {
        draw(pic, shift(0,i*dw)*rotate(-90)*hori_line, latpen);
        draw(pic, shift(0.5dw,(i+0.5)*dw)*rotate(-90)*hori_line, dashed+latpen);

        // label vertical axis
        real lat = md.lat_min + i*md.dlat;
        string lab = (string)(lat) + "$^\circ$";
        pair pos = (-0.5dw,i*dw);
        label(pic, lab, pos, W, latpen);
        // horizontal wrap up
        label(pic, "\tt "+(string)(i+1), pos, 0.45cm*W, latpen); 
    }

    // middle grids <<<3

    for (int i=3; i<6; ++i) {
        dot(pic, (i*dw+0.25*dw, 0.5*len), lonpen);
        dot(pic, (0.5*len+0.25*dw, i*dw), latpen);
    }

    // right <<<3

    for (int i=6; i<9; ++i) {
        draw(pic, shift(i*dw,0)*line, lonpen);
        draw(pic, shift((i+0.5)*dw,0.5dw)*hline, dashed+lonpen);

        // label horizontal axis
        real lon = md.lon_min + (nlons - (8-i) -1)*md.dlon;
        string lab = (string)(lon) + "$^\circ$";
        pair pos = (i*dw,0);
        label(pic, lab, pos, S, lonpen);
        // horizontal wrap up
        label(pic, "\tt "+(string)(nlons - (8-i) + 1), pos, 0.3cm*S, lonpen);
    }

    // top <<<3

    for (int i=6; i<9; ++i) {
        draw(pic, shift(0,i*dw)*rotate(-90)*hori_line, latpen);
        draw(pic, shift(0.5dw,(i+0.5)*dw)*rotate(-90)*hori_line, dashed+lonpen);

        // label vertical axis
        real lat = md.lat_min + (nlats - (8-i) -1)*md.dlat;
        string lab = (string)(lat) + "$^\circ$";
        pair pos = (-0.5dw,i*dw);
        label(pic, lab, pos, W, latpen);
        label(pic, "\tt "+(string)(nlats - (8-i)), pos, 0.45cm*W, latpen);
    }
}

// dot points <<<2

void dot_points(model md, string chars, pen dotpen) {

    pair p;
    picture pic = md.pic;
    real dw = md.dw;
    real poiwidth = 0.15*dw;

    for (int i = 0; i<9; ++i) {
        for (int j = 0; j<9; ++j) {

            if ( chars == "i,j" ) {
                p = (i*dw, j*dw);
                // points are in the four corners
                if ( (i<3 || i>5) && (j<3 || j>5) ) {
                    dot(pic, p, dotpen+linewidth(poiwidth));
                }

            } else if ( chars == "i-1/2,j-1/2" ) {
                p = ((i-0.5)*dw, (j-0.5)*dw);
                if ( (i<3 || i>5) && (j<3 || j>5) ) {
                    dot(pic, p, dotpen+linewidth(poiwidth));
                }

            } else if ( chars == "i+1/2,j+1/2" ) {
                p = ((i+0.5)*dw, (j+0.5)*dw);
                if ( (i<3 || i>5) && (j<3 || j>5) ) {
                    dot(pic, p, dotpen+linewidth(poiwidth));
                }

            } else {
                write("Wrong coordinate in dotting points");
                exit();
            }
        }
    }
}

// label points <<<2

void label_points(model md, string chars, string lab, pen labpen) {

    picture pic = md.pic;
    real dw = md.dw;
    pair p;

    for (int i = 0; i<2; ++i) {
        for (int j = 0; j<2; ++j) {

            if ( chars == "i,j" ) {
                p = (i*dw, j*dw);
                label(pic, lab, p, NE, labpen);

            } else if ( chars == "i-1/2,j-1/2" ) {
                p = ((i-0.5)*dw,(j+0.5)*dw);
                if (j<2) label(pic, lab, p, NE, labpen);

            } else if ( chars == "i+1/2,j+1/2" ) {
                p = ((i+0.5)*dw,(j+0.5)*dw);
                if (j<2) label(pic, lab, p, NE, labpen);

            } else {
                write("Wrong coordinate in labeling points");
                exit();
            }
        }
    }
}

