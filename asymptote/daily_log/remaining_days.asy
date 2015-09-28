
// Description: remainning days in plans
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2013-03-08 07:39:20 CST
// Last Change: 2013-03-23 07:38:27 CST

import EmacsColors;
import myfunctions;

struct plan {
    string title;
    string bdate;  // begin date
    string edate;  // end date
    pen rfill;     // remain fill pen
    pen pfill;     // passed fill pen
    int tdays;     // total days
    int rdays;     // remainning days
}

string perl_scr = "./generate_plan_structure.pl";
system(perl_scr);
plan[] plans; include "remaining_days_struct.asy";

real radi = 3cm;

// remain days function <<<1

picture remain_days(plan plan) {
    picture pic;
    pair po = (0,0);
    guide gcir = circle(po, radi);

    filldraw(pic, gcir, plan.rfill);

    // passed part <<<2

    real deg = 360 * (plan.tdays - plan.rdays) / plan.tdays;
    guide garc = arc(po, radi, 90, 90-deg);

    fill(pic, po--garc--cycle, plan.pfill);

    // text <<<2

    int passDay   = plan.tdays - plan.rdays;
    int remainDay = plan.rdays;

    int passPer   = (int)( 100*passDay/(passDay+remainDay) );
    int remainPer = (int)( 100*remainDay/(passDay+remainDay) );

    string sleft = "\frac{" + (string)passDay + "}{" + (string)remainDay + "}";
    string sright= "\frac{" + (string)passPer + "\%}{" + (string)remainPer + "\%}";
    string text = "\center \[ " + sleft + " = " + sright + " \]";
    text += " \\ " + plan.bdate + " \\ " + plan.edate;

    label(pic, scale(1.5)*minipage(text), (0, -radi), S);
    label(pic, scale(1.5)*plan.title, (0, radi), 0.2cm*N);

    return pic;
}


real zon_sep = 1cm;

// draw plans <<<1 

for (int i=0; i<plans.length; ++i) {
    pair pos = ( 2radi + zon_sep ) * i * E;
    picture pic = remain_days(plans[i]);
    add(pic.fit(), pos);
}

string title = timestamp();
pair tipos = (2radi + zon_sep)*(int)(plans.length/2) + (radi + zon_sep)*N;
label(scale(1.5)*title, tipos, 0.5cm*N);

myshipout("png","daily_log");
