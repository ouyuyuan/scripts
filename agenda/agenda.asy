
// Description: Week agenda
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2013-01-08 15:48:32 CST
// Last Change: 2014-04-28 18:49:27 BJT

import myslide;
import EmacsColors;
import myfunctions;

slide.x *= 1.5;
slide.y *= 1.2;

string ti = time("%Y-%m-%d %a");
title(ti);

string bdate = "2010-09-01";
string edate = "2015-04-01";

// data structure <<<1

real stdWei = 7; //standard weight of jobs

struct agenda {
    string content;
    pen fillPen;
    real weight;
    pair pos;       // label postion
    pair[] period;  // fixed period
    string time;
}

struct grid {
    agenda agenda;
    int idx; // available index
}

// functions <<<1

// init agenda <<<2

agenda newAgenda(string str="") {

    agenda ag;

    ag.content = str;
    ag.fillPen = nullpen;
    ag.weight = stdWei;
    ag.period = new pair[0];
    ag.time   = "";

    return ag;
}

// init grid <<<2

grid newGrid() {
    grid gr;
    agenda ag = newAgenda();
    gr.agenda = ag;

    return gr;
}

// def variables <<<1

agenda[] agendas; include "/home/ou/archive/configs/agendas.asy";

// periods time
string[] times;
int amperiods = 6;
times.push("06:30-07:00");
times.push("07:30-08:00");
times.push("08:15-08:45");
times.push("09:00-09:30");
times.push("09:45-10:15");
times.push("10:30-11:00");

int pmperiods = 5;
times.push("13:40-14:10");
times.push("14:25-14:55");
times.push("15:10-15:40");
times.push("15:55-16:25");
times.push("16:40-17:10");

int niperiods = 5;
times.push("18:20-18:50");
times.push("19:05-19:35");
times.push("19:50-20:20");
times.push("20:35-21:05");
times.push("21:20-21:50");

int np = amperiods + pmperiods + niperiods; // periods
int nd = 7;  // days one week

// weekly grids
grid[][] grids = new grid[nd][np];
for (int i=0; i<nd; ++i) {
    for (int j=0; j<np; ++j) {
        grid gr = newGrid();
        grids[i][j] = gr;
    }
}

// rearrange grids index <<<2

void rearrangeIdx() {
    int idx = 0;
    for (int i=0; i<grids.length; ++i) {
        for (int j=0; j<grids[i].length; ++j) {
            if (grids[i][j].agenda.content == "") {
                grids[i][j].idx = idx;
                idx += 1;
            }
        }
    }
}

// setup agendas <<<2

// place tail agenda on grids
void setupAgenda(int n) {
    if (agendas.length <= 0) return;
    int len = agendas.length;
    agenda ag = agendas[n];

    real Sum = 0;
    for (int i=n; i<len; ++i) {
        Sum += agendas[i].weight;
    }

    real p = Sum/ag.weight;

    for (int i=0; i<grids.length; ++i) {
        for (int j=0; j<grids[i].length; ++j) {
            string con = grids[i][j].agenda.content;
            if (con == "") {
                int idx = grids[i][j].idx;
                if (idx%p < 1) grids[i][j].agenda = ag;
            }
        }
    }
}

// set grid property <<<1

int len = agendas.length;
for (int i=0; i<len; ++i) {
    rearrangeIdx();
    agenda ag = agendas[i];
    if (ag.period.length > 0) {
        for (int k=0; k<ag.period.length; ++k) {
            int m = (int)(ag.period[k].x - 1);
            int n = (int)(ag.period[k].y - 1);
            grids[m][n].agenda = ag;
        }
    } else {
        setupAgenda(i);
    }
}

// draw grids <<<1

pair posGri  = (slide.x*2.1/4, slide.y*1.0/4);
real dw = 1.5cm;
real dh = 1.5cm;

// horizontal
for (int i = 0; i<=nd; ++i) {
    guide hor = (0,i*dh)--(np*dw,i*dh);
    draw(shift(posGri)*hor);
    }

// vertical
for (int i = 0; i<=np; ++i) {
    guide ver = (i*dw,0)--(i*dw,nd*dh);
    draw(shift(posGri)*ver);
    }

// add text <<<1

real widTex = 6cm;
real heiTex = 1.4cm;
real widLab = 1cm;
pair staPos = (slide.x*1.9/4, slide.y*3.4/4);
for (int i=0; i<agendas.length; ++i) {
    string text = "\raggedright \bf " + agendas[i].content;
    picture picTex = textPatch(text, widTex);

    pair posTex =  staPos + heiTex * i * S;
    agendas[i].pos = posTex;

    picture picLab;
    fill(picLab, box((0,0),(1cm,1cm)), agendas[i].fillPen);

    add(picLab.fit(), posTex, W);
    add(scale(1.1)*picTex.fit(), posTex + widLab*W, W);
}

// connect <<<1

for (int i=0; i<nd; ++i) {
    for (int j=0; j<np; ++j) {

        pair a = (j*dw,i*dh)+posGri;
        pair b = a + (0,dh);
        agenda ag = grids[i][j].agenda;

        real deg = 90+45;
        pair p = b;

        pen Pen = ag.fillPen + linewidth(0.8mm);
        draw(p{dir(deg)}..tension 2 ..{W}ag.pos, Pen);
    }
}

// fill <<<1

// after connection, to cover curves
for (int i=0; i<nd; ++i) {
    for (int j=0; j<np; ++j) {

        pair a = (j*dw,i*dh)+posGri;
        pair b = a + (dw,dh);
        agenda ag = grids[i][j].agenda;

        pen Pen = ag.fillPen;
        fill(box(a,b), Pen);
    }
}

// delimeter for a.m., p.m., night
real dm = 0*dh;
pen Pen = white + linewidth(2mm);
//draw(shift(posGri)*((4dw,-dm)--(4dw,nd*dh)), Pen);
//draw(shift(posGri)*((8dw,-dm)--(8dw,nd*dh)), Pen);
real amwid = amperiods*dw;
real pmwid = pmperiods*dw;
draw(shift(posGri)*((amwid,-dm)--(amwid,nd*dh)), Pen);
draw(shift(posGri)*(((amwid+pmwid),-dm)--((amwid+pmwid),nd*dh)), Pen);

// clock <<<1

real radi = 7cm;
pair posClo = (slide.x*0.3/4, slide.y*0.8/4) + radi*NE;
pair pup = posClo + (radi+2cm)*N;
pair pdown = posClo + (radi+1cm)*S;

guide gcir = circle(posClo, radi);
guide ghou = (0,radi)--(0,radi+2mm);

draw(gcir, grey+linewidth(3mm));
draw(gcir, white+linewidth(1mm));

for (int i=1; i<=24; ++i) {
    real deg = 90-i*360/24;
    draw(rotate(deg, posClo)*shift(posClo)*ghou, grey+linewidth(2mm));
    label(scale(1.0)*("\bf "+(string)i), posClo+radi*dir(deg), 
    dir(deg-180));
}

// draw job sector <<<1

int[] begTime;
int[] endTime;

// which week day <<<2

int day;
string wee = time("%a");
if        (wee == "Mon") {
    day = 0;
} else if (wee == "Tue") {
    day = 1;
} else if (wee == "Wed") {
    day = 2;
} else if (wee == "Thu") {
    day = 3;
} else if (wee == "Fri") {
    day = 4;
} else if (wee == "Sat") {
    day = 5;
} else {
    day = 6;
}

// connect day-clock <<<2

pair pday = posGri + np*dw*E + (day+0.5)*dh*N;
pair pcor = posGri + (np + 0.5)*dw*E + 0.5cm*S;
pair pmid = (slide.x*2.0/4, slide.y*0.1/4);
pair pend = posClo + radi*S;
draw(pday{E}..tension 3 .. pcor .. tension 3 .. pmid .. tension 3 .. {N}pend, 
    red+opacity(0.5)+linewidth(1.618mm), Arrow);

// minute pointer <<<2

pen poipen = blue;

string[] hm = split(time("%H:%M"), ":");
int min = 60*(int)hm[0] + (int)hm[1];

real deg = 90 - 360*min/(24*60);
pair p = posClo+(radi+6mm)*dir(deg);
axialshade(posClo--p, stroke=true, grey+linewidth(1.5mm), posClo, poipen, p); 

// np period a day
real widTim = 4.2cm;
for (int i=0; i<np; ++i) {
    real degb, dege;
    pen fillpen;

    // job sector 
    string[] t  = split(times[i], "-");
    string[] bt = split(t[0], ":");
    string[] et = split(t[1], ":");

    int bmin = 60*(int)bt[0] + (int)bt[1];
    begTime.push(bmin);
    int emin = 60*(int)et[0] + (int)et[1];
    endTime.push(emin);

    degb = 90 - 360*bmin/(24*60);
    dege = 90 - 360*emin/(24*60);
    guide garc = arc(posClo, radi, degb, dege);

    fillpen = red;

    // maybe available time
    if (grids[day][i].agenda.content == "") {
        fillpen = mygreen;
    }

    fill(posClo--garc--cycle, opacity(0.4)+fillpen);

    // add time text <<<2

    // draw current-time job
    if (min > begTime[i] && min < endTime[i]) {
        grids[day][i].agenda.time = times[i];
        string text = "\raggedright \bf " + times[i];
        text = minipage(text, widTim);
        pair posTex = grids[day][i].agenda.pos + (widTex + widLab) * W;
        label(text, posTex, W);
    }
}

// link job <<<2

// connect sector and current job
void connectJob(pair pos) {
    int hour = (int)hm[0];
    guide g = p{dir(deg)}..tension 2 ..{E}pos;
    pen Pen = poipen + linewidth(1mm);

    if (hour>12 && hour<=18) {
        g = p{dir(deg)}..tension 2 ..{E}pdown..{E}pos;
    } else if (hour>18 && hour<24) {
        g = p{dir(deg)}..tension 2 ..{E}pup..{E}pos;
    }

    draw(g, Pen); 
}

for (int i=0; i<np; ++i) {
    if (min > begTime[i] && min < endTime[i]) {
        pair pos = grids[day][i].agenda.pos + (widTim + widTex + widLab) * W;
        pos += 0.3cm*W;
        connectJob(pos);
        break;
    }
}

// pass days <<<1

picture picPass;
real radi = 3cm;
pair o = (0,0);

guide gcir = circle(o, radi);
draw(picPass, gcir);

// pass time  <<<2

int tb   = seconds(bdate,"%Y-%m-%d");
int tn   = seconds(time("%Y-%m-%d"), "%Y-%m-%d");
int te   = seconds(edate,"%Y-%m-%d");
real deg = 360 * (tn - tb) / (te - tb);

guide garc = arc(o, radi, 90, 90-deg);
fill(picPass, o--garc--cycle, opacity(0.4) + red);
pair posPass = (posClo.x, slide.y*3.2/4);

// pass text <<<2

int passDay   = (int)( (tn - tb) / (24*60*60) );
int remainDay = (int)( (te -tn) / (24*60*60)  );
int passPer   = (int)( 100*passDay/(passDay+remainDay) );
int remainPer = (int)( 100*remainDay/(passDay+remainDay) );

string sleft = "\frac{" + (string)passDay + "}{" + (string)remainDay + "}";
string sright= "\frac{" + (string)passPer + "\%}{" + (string)remainPer + "\%}";
string text = "\[ " + sleft + " = " + sright + " \]";
label(picPass, scale(1.5)*minipage(text), (-radi, 0), W);

add(picPass.fit(), posPass);

myshipout();
