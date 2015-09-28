
// Description: Week agenda
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2013-01-08 15:48:32 CST
// Last Change: 2013-03-09 11:05:35 CST

import EmacsColors;
import myfunctions;

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

agenda[] agendas; include "week_agenda_struct.asy";

int np = 12; // periods
int nd = 7;  // days one week

// periods time
string[] times;
times.push("07:50-08:30");
times.push("08:40-09:20");
times.push("09:30-10:10");
times.push("10:20-11:00");

times.push("14:00-14:40");
times.push("14:50-15:30");
times.push("15:40-16:20");
times.push("16:30-17:10");

times.push("18:00-18:40");
times.push("18:50-19:30");
times.push("19:40-20:20");
times.push("20:30-21:10");
//times.push("21:20-22:00");

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

pair posGri  = (0,0);
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
pair staPos = (0,0)+1cm*NW;
for (int i=0; i<agendas.length; ++i) {
    string text = "\raggedright \bf " + agendas[i].content;
    picture picTex;
    label(picTex, minipage(text, widTex));

    pair posTex =  staPos + heiTex * i * N;
    agendas[i].pos = posTex;

    picture picLab;
    fill(picLab, box((0,0),(1cm,1cm)), agendas[i].fillPen);

    add(picLab.fit(), posTex, W);
    add(scale(1.5)*picTex.fit(), posTex + widLab*W, W);
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
draw(shift(posGri)*((4dw,-dm)--(4dw,nd*dh)), Pen);
draw(shift(posGri)*((8dw,-dm)--(8dw,nd*dh)), Pen);


myshipout();
