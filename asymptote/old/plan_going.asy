
// Description: module for drawing how a plan is going now
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-25 16:10:57 CST
// Last Change: 2012-11-29 22:40:03 CST

// structure of a plan
struct plan {
    guide outline;
    string content;
    // begin and end time in seconds from 1970-01-01-00:00:00
    int begin, end; 
    picture pic;
    pair pos; 
    real base_area = 1; // area for a week long plan, in cm^2
    real radius;
    int total; // total pages, lines, days, etc
    int finished = 0; // finished pages, lines, days, etc
    string unit; // unit of total/finish, e.g.: page, day, line

    pair dir(pair v) {
        guide g = outline;
        pair m=min(g), M=max(g), c=0.5*(m+M);
        guide ray = c -- c+length(M-m)*unit(v);
        return intersectionpoint(g, ray); }

    pair angle(real ang){
        return this.dir(dir(ang)); }

    void cover_part(real ratio, pen fillpen) {
        real deg = 360 * ratio;
        guide g = arc(pos, radius, 0, deg);
        fill(pos -- g -- cycle, fillpen); } 

    void past_time() {
        int now = seconds();
        real ratio = (now - begin) / (end - begin);
        if (ratio < 0) ratio = 0;
        if (ratio > 1) ratio = 1;
        pen p = opacity(0.5) + red;
        cover_part(ratio, p); } }

// draw plan array
void draw(picture pic=currentpicture, plan[] parr) {
    for (plan p : parr)
        add(pic, p.pic); }

// draw one or more plans
void draw(picture pic=currentpicture ... plan[] parr) {
    draw(pic, parr); }

// record finished part of plans, up to 5 plans
void dailyrecord(string date, plan pa, int na) {
    pa.finished += na; }
void dailyrecord(string date, plan pa, int na, plan pb, int nb) {
    pa.finished += na; 
    pb.finished += nb; }
void dailyrecord(string date, plan pa, int na, plan pb, int nb, 
    plan pc, int nc) {
    pa.finished += na; 
    pb.finished += nb;
    pc.finished += nc; }
void dailyrecord(string date, plan pa, int na, plan pb, int nb, 
    plan pc, int nc, plan pd, int nd) {
    pa.finished += na; 
    pb.finished += nb;
    pc.finished += nc; 
    pd.finished += nd; }
void dailyrecord(string date, plan pa, int na, plan pb, int nb, 
    plan pc, int nc, plan pd, int nd, plan pe, int ne) {
    pa.finished += na; 
    pb.finished += nb;
    pc.finished += nc; 
    pd.finished += nd;
    pe.finished += ne; }

// draw finished parts for plans
void finished_draw(plan[] parr) {
    real ratio;
    pen fillpen = opacity(0.4) + green;
    for (plan p : parr) {
        if (p.finished >= p.total)
            fill(p.outline, fillpen);
        else if (p.finished > 0) {
            ratio = p.finished / p.total;
            p.cover_part(ratio, fillpen); } } }

// draw outline functions
typedef void drawtype(picture pic, guide g);

// compose multi outline draw functions
drawtype compose(... drawtype[] drawfns) {
    return new void(picture pic, guide g) {
        for (drawtype f : drawfns) f(pic, g); }; }

// void outline drawer function
drawtype none = new void(picture pic, guide g){};

// draw outline
drawtype drawer(pen p) { 
    return new void(picture pic, guide g) {
        draw(pic, g, p); }; }
drawtype drawer=drawer(currentpen);

// fill outline
drawtype filler(pen p) {
    return new void(picture pic, guide g) {
        fill(pic, g, p); }; }
drawtype filler=filler(currentpen);

// fill and draw outline
drawtype filldrawer(pen fillpen, pen drawpen=currentpen) {
    return new void(picture pic, guide g) {
        filldraw(pic, g, fillpen, drawpen); }; }

// draw double outlines
drawtype doubledrawer(pen p, pen bg=white) {
    return compose(drawer(p + 3*linewidth(p)), 
        drawer(bg + linewidth(p))); }
drawtype doubledrawer=doubledrawer(currentpen);

// draw plan shadow
//drawtype shadow(pair shift=2SE, real scale=1, pen color=gray) {
drawtype shadow(real scale=0.1, pen color=gray) {
    return new void(picture pic, guide g) {
        pair m = min(g), M = max(g);
        real r = length(M-m) / 2;
        fill(pic, shift(scale*r*SE) * g, color); 
        unfill(pic, g); }; }
drawtype shadow=shadow();

// plan construct function
plan newplan(string content, string begin_date, int days, int total,
    string unit, pair pos=(0,0), 
    pen contentpen=currentpen, drawtype drawfn) {

    plan p;
    p.content = content;
    p.total = total;
    p.unit = unit;
    p.pos = pos;
    p.begin = seconds(begin_date,"20%y-%m-%d");
    p.end = p.begin + days * 24*60*60;
    real area = p.base_area * days/7.0;
    real r = sqrt(area / pi)*cm;
    p.radius = r;

    p.outline = circle(pos, r);
    drawfn(p.pic, p.outline);
    p.past_time();
    label(p.pic, content, pos, contentpen);
    return p; }

// concatenate two plans
guide operator-- (plan pa, plan pb) {
    guide ga = pa.outline;
    guide gb = pb.outline;
    pair ca = ( min(ga) + max(ga) ) / 2;
    pair cb = ( min(gb) + max(gb) ) / 2;
    guide con = ca -- cb;
    con = firstcut(con, ga).after;
    con = firstcut(con, gb).before;
    return con; }

// plans connecting function
typedef guide connect(plan pa, plan pb);
// create connect line from single plan 
typedef guide halfconnect(plan n);

// first half for plan_a .. connectfunc .. plan_b
halfconnect operator.. (plan pa, connect con) {
    return new guide(plan pb) { return con(pa, pb); }; }

// last half for plan_a .. connectfunc .. plan_b
guide operator.. (halfconnect halfcon, plan n) {
    return halfcon(n); }

// connect line with bending curve
connect bend (real ang) {
    return new guide(plan pa, plan pb) {
        guide ga = pa.outline;
        guide gb = pb.outline;
        pair ca = ( min(ga) + max(ga) ) / 2;
        pair cb = ( min(gb) + max(gb) ) / 2;
        real deg = degrees(cb - ca); 

        pair a = pa.dir(dir(deg + ang));
        pair b = pb.dir(dir(deg + 180 - ang));
        return a{dir(deg + ang)} .. {dir(deg - ang)}b; }; }
connect bendleft = bend(30);
connect bendright = bend(-30);

// adjust guide function
typedef guide adjustguide(guide);

// apply an adjust funtion to a guide
guide operator@(guide g, adjustguide adjust) {
    return adjust(g); }

// shorten a guide
adjustguide shorten(real pre=0, real post=2) {
    return new guide(guide g) {
        return subpath(g, arctime(g, pre), arctime(g, arclength(g) -
            post)); }; }
adjustguide shorten=shorten(0,2);
