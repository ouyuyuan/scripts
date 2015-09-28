
// Description: for drawing grids of models
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-04-01 16:14:58 CST
// Last Change: 2013-04-01 16:58:21 CST

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
    real hlen = (8-1)*md.dw;

    guide line = (0,0)--len*(0,1);
    guide hline = (0,0)--hlen*(0,1);
    guide hori_line = (0,0)--(len)*(0,1);

    pen lonpen = black;
    pen latpen = black;

    // draw axes <<<3

    real dh = -0.55cm;
    pair a = (0, dh);
    pair b = (8*dw, dh) + 3cm*E;
    draw(pic, a--b, Arrow);
    label(pic, "East", b, E);
    label(pic, "Longitude", b+2cm*W, NE, lonpen);
    label(pic, "\tt Index", b+2cm*W, SE, lonpen);

    real dh = -1.20cm;
    pair a = (dh,0);
    pair b = (dh, 8*dw) + 2cm*N;
    draw(pic, a--b, Arrow);
    label(pic, "North", b, N);
    label(pic, "Latitude",  b+1cm*S, E, latpen);
    label(pic, "\tt Index", b+1cm*S, W, latpen);


    // left and bottom grids <<<3

    for (int i=0; i<3; ++i) {
        draw(pic, shift(i*dw,0)*line, lonpen);
        draw(pic, shift((i+0.5)*dw,0.5dw)*hline, dashed+lonpen);

        string lab = (string)(i*md.dlon) + "$^\circ$";
        pair pos = (i*dw, 0);
        label(pic, lab, pos, S, lonpen);
        label(pic, "\tt "+(string)(i+1), pos, 0.2cm*S, lonpen);

        draw(pic, shift(0,i*dw)*rotate(-90)*hori_line, latpen);
        draw(pic, shift(0.5dw,(i+0.5)*dw)*rotate(-90)*hori_line, dashed+latpen);

        real lat = md.lat_min + i*md.dlat;
        string lab = (string)(lat) + "$^\circ$";
        pair pos = (0,i*dw);
        label(pic, lab, pos, W, latpen);
        label(pic, "\tt "+(string)(i+1), pos, 0.4cm*W, latpen);
    }

    // middle grids <<<3

    for (int i=3; i<6; ++i) {
        dot(pic, (i*dw, 0.5len), lonpen);
        dot(pic, (0.5len, i*dw), latpen);
    }

    // right and up grids <<<3

    for (int i=6; i<9; ++i) {
        draw(pic, shift(i*dw,0)*line, lonpen);
        draw(pic, shift((i+0.5)*dw,0.5dw)*hline, dashed+lonpen);

        real lon = md.lon_min + (nlons - (8-i) -1)*md.dlon;
        string lab = (string)(lon) + "$^\circ$";
        pair pos = (i*dw,0);
        label(pic, lab, pos, S, lonpen);
        label(pic, "\tt "+(string)(nlons - (8-i)), pos, 0.2cm*S, lonpen);

        draw(pic, shift(0,i*dw)*rotate(-90)*hori_line, latpen);
        if (i<8) 
            draw(pic, shift(0.5dw,(i+0.5)*dw)*rotate(-90)*hori_line, dashed+lonpen);

        real lat = md.lat_min + (nlats - (8-i) -1)*md.dlat;
        string lab = (string)(lat) + "$^\circ$";
        pair pos = (0,i*dw);
        label(pic, lab, pos, W, latpen);
        label(pic, "\tt "+(string)(nlats - (8-i)), pos, 0.4cm*W, latpen);
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

            } else if ( chars == "i,j+1/2" ) {
                p = (i*dw, (j+0.5)*dw);
                if ( (i<3 || i>5) && (j<3 || j>5) && j<8 ) {
                    dot(pic, p, dotpen+linewidth(poiwidth));
                }

            } else if ( chars == "i+1/2,j" ) {
                p = ((i+0.5)*dw, j*dw);
                if ( (i<3 || i>5) && (j<3 || j>5) ) {
                    dot(pic, p, dotpen+linewidth(poiwidth));
                }

            } else if ( chars == "i+1/2,j+1/2" ) {
                p = ((i+0.5)*dw, (j+0.5)*dw);
                if ( (i<3 || i>5) && (j<3 || j>5) && j<8 ) {
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

            } else if ( chars == "i+1/2,j" ) {
                p = ((i+0.5)*dw, j*dw);
                label(pic, lab, p, NE, labpen);

            } else if ( chars == "i,j+1/2" ) {
                p = (i*dw,(j+0.5)*dw);
                if (j<1) label(pic, lab, p, NE, labpen);

            } else if ( chars == "i+1/2,j+1/2" ) {
                p = ((i+0.5)*dw,(j+0.5)*dw);
                if (j<1) label(pic, lab, p, NE, labpen);

            } else {
                write("Wrong coordinate in labeling points");
                exit();
            }
        }
    }
}

