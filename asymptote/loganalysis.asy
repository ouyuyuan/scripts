
// Description: Log Analysis Module
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-10-24 08:55:45 CST
// Last Change: 2013-01-02 14:46:35 CST

import myfunctions;
import mycolor;
import graph;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// global variable
//
string datadir  = "/home/ou/archive/data";
string mainname = "daily-log";
string datafile = datadir + "/" + mainname + "-yesno.dat";
string[] dates  = read_string(datafile,0);
int[] days      = sequence(dates.length) + 1; // days from 2012-10-01

string[] shortdates;
for (int i=0; i<dates.length; ++i) {
    string[] nums = split(dates[i],"-");
    shortdates.push(nums[1]+"-"+nums[2]);
}

struct schedule {
    string content = "content";
    string time = "00:00-01:00";
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// internal functions
//

// x axis tick function
typedef string stringTick(real);

stringTick xtick (string[] dates=shortdates) {
    return new string(real x) {
        return dates[(int)x];
    };
}

// xaxis
void drawXaxis(picture pic=currentpicture, real minHei=0) {
    guide axis = (-1,minHei)--(dates.length,minHei);
    guide tick = (0,0)--(0,-0.1);
    draw(pic, axis, Arrow);

    for (int i=0; i<days.length; ++i) {
        if ( i%5 == 0 ) {
            draw(pic, shift(i,minHei)*tick);
            label(pic, (string)days[i],(i,minHei), S);
        }
    }
}

// xaxis
typedef void myXaxis(picture, string[]);

void topXaxis(picture pic, string[] dates = dates) { 
    xaxis(pic, Top, LeftTicks(xtick(dates)));
}

void bottomXaxis(picture pic, string[] dates = dates) { 
    xaxis(pic, Bottom, LeftTicks(xtick(dates)));
}

// convert average value to a label
typedef string ave2str(int, int);

string consumedTimeAve2str (int yave, int morey) {
    int yaveh = (int)((yave-morey)/60);
    int yavem = (yave-morey - yaveh*60);
    string yaves = (string)yaveh + "h " + (string)yavem + "m";
    return yaves;
}

string pointTimeAve2str (int yave, int morey) {
    int yaveh = (int)(yave/60);
    int yavem = round(yave - 60*yaveh);

    string zs = yavem<10 ? "0":"";
    string yaves = (string)yaveh + ":" + zs +(string)yavem;
    return yaves;
}

string scoresAve2str (int yave, int morey) {
    return (string)(yave-morey);
}

string normalAve2str (int yave, int morey) {
    return (string)(yave-morey);
}

// average funtion, take account of invalid data
typedef int myave(int[]);

int normalAve(int[] data) {
    return round(sum(data)/data.length);
}

int arrivalAve(int[] data) {
    int invalid = 25*60;
    int[] newdata;
    
    for (int i = 0; i<data.length; ++i) {
        if (data[i] != invalid) newdata.push(data[i]);
    }

    return normalAve(newdata);
}

// draw y- equal lines
typedef void myYequals(picture, int, int, int);

void consumedTimeYzeros(picture pic, int start, int stride, int n) {
    for (int i=0; i<n; ++i) {
        int morey = stride*i + start;
        yequals(pic, morey, dotted); 
        labely(pic, morey, S, "0");
    }
}

void arrivalTimeYequals(picture pic, 
    int start=0, int stride=0, int n=0) {
}

// return an index order of 2-d array for biggest first
int[] sortIndex(int[][] data) {
    int[] order = sequence(data.length);

    int[] sumdata = new int[data.length];
    for (int i=0; i<data.length; ++i) {
        sumdata[i] = sum(data[i]);
    }

    for (int i=0; i<order.length; ++i) {
        int k=i;
        for (int j=i+1; j<order.length; ++j) {
            if (sumdata[order[j]] > sumdata[order[k]]) k=j;
        }
        if ( k!=i ) {
            int temp = order[i];
            order[i] = order[k];
            order[k] = temp;
        }
    }
    return order;
}

// mark
frame snowmark (pen fillpen = blue) {
    frame mark;
    real mkscale = 1.5mm;
    filldraw(mark,scale(mkscale)*polygon(6),fillpen,fillpen);
    draw(mark,scale(mkscale)*cross(6),white);
    return mark;
}

// vertical bar
void drawBar(picture pic=currentpicture, real hei, int i, 
    pen fillpen=nullpen, pen drawpen=currentpen) {
    string[] str = shortdates;
    real wid     = 1;
    real pw      = 0.5;
    real deg     = 40;

    pair a = (i-0.5*wid, 0), b = (i+0.5*wid, hei);
    filldraw(pic, box(a,b), fillpen);
    label(pic, Label(str[i], Rotate(N)), (i,0), N, drawpen);

    // cubic shadow
    hsv q = fillpen;
    a = shift(0,hei)*a;
    pair c = b + pw*wid*(Cos(deg),Sin(deg));
    pair d = shift(-wid, 0)*c;
    guide up = a--b--c--d--cycle;
    filldraw(pic, up, hsv(q.h, q.s/3, 1));

    pair e = shift(0,-hei)*b;
    pair f = shift(0,-hei)*c;
    guide ri = e--f--c--b--cycle;
    filldraw(pic, ri, hsv(q.h, q.s + (1-q.s)*2/3, 0.5));
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// external functions
//

// yes or no bars
picture yesNo(int[] data, pen fillpen=nullpen, pen drawpen=currentpen) {

    picture pic;
    int len = data.length;
    real ph = 4;

    drawXaxis(pic);

    for (int i=0; i<len; ++i) {
        real hei = data[i]*ph;
        if ( hei > 0) drawBar(pic, hei, i, fillpen, drawpen);
    }

    real ave = sum(data)/len;
    string save = (string)(round(1/ave))+" days";
    real avehei = ave*ph;
    guide gave = (0,avehei) -- (len, avehei);

    draw(pic, gave, myred+linewidth(0.618mm));
    label(pic, save, (0, avehei), W, red);

    return pic;
}

// draw time-trend lines for several part
picture myTrend(int[][] data, pen[] drawpen, string[] legends, 
    myave myave         = normalAve,
    ave2str ave2str     = consumedTimeAve2str,
    myXaxis myXaxis     = topXaxis,
    myYequals myYequals = consumedTimeYzeros,
    string[] dates = shortdates,
    int[] order=sequence(data.length), int splity=0) {

    picture pic;
    int len = data[0].length;
    int[] x = sequence(len);

    for (int i=0; i<data.length; ++i) {
        int morey = (data.length-1 - i)*splity; // split apart lines

        int j = order[i];

        data[j] += morey;
        int yave = myave(data[j]);
        string yaves = ave2str(yave, morey);

        guide g = graph(x, data[j]);
        draw(pic, g, linewidth(0.618mm), legends[j], 
            marker( snowmark(drawpen[j]) ));

        yequals(pic, yave, drawpen[j]);
        labely(pic, yave, W, minipage("\bf "+yaves+"\par "+legends[j], 2.5cm), 
            drawpen[j]);
    }

    if (data.length > 1) myYequals(pic, 0, splity, 3);
    myXaxis(pic, dates);

    return pic;
}

// scores
picture scores(int[][] data, pen[] drawpen, string[] legends, 
    string[] dates = shortdates) {
    return myTrend(data, drawpen, legends, dates = dates, scoresAve2str, 
        sortIndex(data), 100);
}

// arrival time
picture arrivalTime(int[][] data, pen[] drawpen, string[] legends) {
    return myTrend(data, drawpen, legends, arrivalAve, pointTimeAve2str, 
        bottomXaxis, arrivalTimeYequals,
        sortIndex(data));
}

// daily time
picture dailyTime(int[][] data, pen[] drawpen, string[] legends) {
    return myTrend(data, drawpen, legends, 6*60);
}

// classified time
picture classTime(int[][] data, pen[] drawpen, string[] legends) {
    return myTrend(data, drawpen, legends, sortIndex(data), 10*60);
}

// 1-d consumed time
picture consumedTime(int[] data, pen drawpen=currentpen, string legend="", 
    string[] dates = shortdates) {
    return myTrend(new int[][]{data}, new pen[]{drawpen}, new
        string[]{legend}, dates = dates, bottomXaxis);
}

// pages read
picture pagesRead(int[] data, pen drawpen=currentpen, string legend="", 
    string[] dates = shortdates) {
    return myTrend(new int[][]{data}, new pen[]{drawpen}, new
        string[]{legend}, dates = dates, normalAve2str, bottomXaxis);
}

