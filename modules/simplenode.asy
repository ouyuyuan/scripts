
// Description: Finite Automata Machine Module
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-09-19 15:04:10 CST
// Last Change: 2012-11-25 22:10:42 CST

// node structure
struct node {
    guide outline;
    picture pic;
    pair pos;

    pair dir(pair v) {
        guide g = shift(pos)*outline;
        pair m=min(g), M=max(g), c=0.5*(m+M);
        guide ray = c -- c+length(M-m)*unit(v);
        return intersectionpoint(g, ray); }

    pair angle(real ang){
        return this.dir(dir(ang)); } }

// draw node array
void draw(picture pic=currentpicture, node[] ndarr) {
    for (node nd : ndarr)
        add(pic, shift(nd.pos)*nd.pic); }

// draw one or more nodes
void draw(picture pic=currentpicture ... node[] ndarr) {
    draw(pic, ndarr); }

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

// draw node shadow
drawtype shadow(pair shift=2SE, real scale=1, pen color=gray) {
    return new void(picture pic, guide g) {
        fill(pic, shift(shift)*scale(scale)*g, color); }; }
drawtype shadow=shadow();

// circle node construct function
node circlenode(string text, pair pos, 
    pen textpen=currentpen, drawtype drawfn) {

    node nd;
    nd.pos = pos;
    label(nd.pic, text, textpen);

    pair m = min(nd.pic);
    pair M = max(nd.pic);
    pair c = (m + M) / 2;
    real r = length(M-m) / 2;

    nd.outline = circle(c, r);
    drawfn(nd.pic, nd.outline);
    return nd; }

// concatenate two nodes
guide operator-- (node na, node nb) {
    guide ga = shift(na.pos)*na.outline;
    guide gb = shift(nb.pos)*nb.outline;
    pair ca = ( min(ga) + max(ga) ) / 2;
    pair cb = ( min(gb) + max(gb) ) / 2;
    guide con = ca -- cb;
    con = firstcut(con, ga).after;
    con = firstcut(con, gb).before;
    return con; }

// nodes connecting function
typedef guide connect(node na, node nb);
// create connect line from single node 
typedef guide halfconnect(node n);

// first half for node_a .. connectfunc .. node_b
halfconnect operator.. (node na, connect con) {
    return new guide(node nb) { return con(na, nb); }; }

// last half for node_a .. connectfunc .. node_b
guide operator.. (halfconnect halfcon, node n) {
    return halfcon(n); }

// connect line with bending curve
connect bend (real ang) {
    return new guide(node na, node nb) {
        guide pa = shift(na.pos)*na.outline;
        guide pb = shift(nb.pos)*nb.outline;
        pair ca = ( min(pa) + max(pa) ) / 2;
        pair cb = ( min(pb) + max(pb) ) / 2;
        real deg = degrees(cb - ca); 

        pair a = na.dir(dir(deg + ang));
        pair b = nb.dir(dir(deg + 180 - ang));
        return a{dir(deg + ang)} .. {dir(deg - ang)}b; }; }
connect bendleft = bend(30);
connect bendright = bend(-30);

// node loop itself
guide loop(node n, pair direct= up, real r = 1.5, real deg = 15) {
    real dega = degrees(direct) - deg;
    real degb = degrees(direct) + deg;
    pair a = n.angle(dega);
    pair b = n.angle(degb);
    pair h = r * fontsize(currentpen) * unit(direct);
    pair c = n.angle(degrees(direct)) + h;
    return a{dir(dega)} .. c .. {-dir(degb)}b; }

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
