
// Description: agenda plots
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-11-29 19:18:08 CST
// Last Change: 2013-01-10 08:34:25 CST

import myslide;
import myfunctions;

struct schedule {
    string content = "content";
    string time = "00:00-01:00";
}

string date = "\bf " + time("%Y-%m-%d");
title(date);

// clock <<<1

picture picClo;
real radi = slidey*1.1/4;
pair o = (0,0);

guide gcir = circle(o, radi);
guide ghou = (0,radi)--(0,radi+2mm);

draw(picClo, gcir, grey+linewidth(3mm));
draw(picClo, gcir, white+linewidth(1mm));

for (int i=1; i<=24; ++i) {
    real deg = 90-i*360/24;
    draw(picClo, rotate(deg)*ghou, grey+linewidth(2mm));
    label(picClo, scale(1.0)*("\bf "+(string)i), radi*dir(deg), 
    dir(deg-180));
}

// add text, draw jobs <<<1

schedule[] sches; include "schedules.asy";
pair[] posTexes;
int[] begTime;
int[] endTime;

for (int i=0; i<sches.length; ++i) {
    real degb, dege;
    pen fillpen;

    string[] t  = split(sches[i].time, "-");
    string[] bt = split(t[0], ":");
    string[] et = split(t[1], ":");

    int bmin = 60*(int)bt[0] + (int)bt[1];
    begTime.push(bmin);
    int emin = 60*(int)et[0] + (int)et[1];
    endTime.push(emin);

    degb = 90 - 360*bmin/(24*60);
    dege = 90 - 360*emin/(24*60);
    guide garc = arc(o, radi, degb, dege);

//    if (i%2==0) {
//        fillpen = myblue;
//    } else {
        fillpen = red;
//    }

    // maybe available time
    if (sches[i].content == "") {
        fillpen = mygreen;
    }

    fill(picClo, o--garc--cycle, opacity(0.4)+fillpen);

    string text = "\raggedright \bf " + sches[i].time + " "+sches[i].content;

    picture picTex = textPatch(text, slidex*1.1/4.0);
    pair posTex = (slidex*2.2/4, slidey*3.2/4) + (slidey*0.25*i/4) * S;
    posTexes.push(posTex);
    add(scale(1.2)*picTex.fit(), posTex, E);
}

// draw minute pointer <<<1

pair posClo = (slidex*0.9/4, slidey*1.5/4); 
pen poipen = blue;

string[] hm = split(time("%H:%M"), ":");
int min = 60*(int)hm[0] + (int)hm[1];

pair posTex;
bool hasJob = false;
for (int i=0; i<sches.length; ++i) {
    if (min > begTime[i] && min < endTime[i]) {
        posTex = posTexes[i];
        hasJob = true;
        break;
    }
}

real deg = 90 - 360*min/(24*60);
pair p = (radi+6mm)*dir(deg);
axialshade(picClo, o--p, stroke=true, grey+linewidth(1.5mm), o, poipen, p); 

// connect job with curve <<<1

if (hasJob) {
    pair pp  = p + posClo;
    pair pup = posClo + (radi+1cm)*N;
    pair pdown = posClo + (radi+1cm)*S;

    int hour = (int)hm[0];
    if (hour>12 && hour<=18) {
        axialshade(pp{dir(deg)}..tension 2 ..{E}pdown..{E}posTex, stroke=true, 
        poipen+linewidth(1mm), posTex, poipen, pp); 
    } else {
        if (hour>18 && hour<24) {
            axialshade(pp{dir(deg)}..tension 2 ..{E}pup..{E}posTex, stroke=true, 
            poipen+linewidth(1mm), posTex, poipen, pp); 
        } else {
            axialshade(pp{dir(deg)}..tension 2 ..{E}posTex, stroke=true, 
            poipen+linewidth(1mm), posTex, poipen, pp); 
        }
    }
}

add(picClo.fit(), posClo);

// pass days <<<1

picture picPass;
real radi = slidey*0.5/4;
pair o = (0,0);

guide gcir = circle(o, radi);
draw(picPass, gcir);

// pass time  <<<2

int tb   = seconds("2012-10-01","%Y-%m-%d");
int tn   = seconds(time("%Y-%m-%d"), "%Y-%m-%d");
int te   = seconds("2014-04-14","%Y-%m-%d");
real deg = 360 * (tn - tb) / (te - tb);

guide garc = arc(o, radi, 0, deg);
fill(picPass, o--garc--cycle, opacity(0.4) + red);
pair posPass = (posClo.x, slidey*3.4/4);

// pass text

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
