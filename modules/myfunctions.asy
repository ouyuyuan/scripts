
// Description: Common functions
//
//      Author: OU Yuyuan <ouyuyuan@gmail.com>
//     Created: 2012-10-24 08:50:52 CST
// Last Change: 2013-12-18 09:20:08 BJT

// def var <<<1

pen flatnib = scale(5)*makepen((0,0)--(1,0)--(1,0.1)--(0,0.1)--cycle);

pen flatnib_cn = scale(5)*makepen((0,0)--(0.4,0)--(0.4,1)--(0,1)--cycle);

// signature <<<1

// ou <<<2

guide guide_sign_ou()
{
    pair oa = (-141,124);
    pair ob = (-234,-32);
    pair oc = (-231,-56);
    pair od = (-126,-60);
    pair oe = (-53,60);
    pair of = (-77,130);
    pair og = (-134,123);
    pair oh = (-118,-60);
    pair oi = (-51,-30);
    pair oj = (-24,0);

    guide go = oa .. ob .. oc .. od .. oe .. of ..  og .. oh .. oi .. oj;

    pair ua = (-87,-78);
    pair ub = (-15,-97);
    pair uc = (63,-3);
    pair ud = (-21,-110);
    pair ue = (-18,-113);
    pair uh = (24,-100);

    guide gu = oj .. tension 2 .. ua .. ub .. tension 4 .. uc ..  uc .. 
               tension 4 .. ud .. ue .. tension 2 .. uh;

    guide si = (shift(30SW) * go) & (shift(15NE) * gu);

    return si;
}

picture sign_ou(pen p = flatnib)
{
    picture pic;

    guide si = guide_sign_ou();

    draw(pic, si, p);

    return scale(0.1)*pic;
}

// ou cn <<<2

picture sign_ou_cn(pen p = flatnib_cn)
{
    picture pic;

    pair a1 = (32,128);
    pair a4 = (75,129);
    pair a8 = (45,98);
    pair a11 = (52,119);
    pair a14 = (60,101);
    guide ga = a1.. tension 4 ..a4.. tension 4 
        ..a8..tension 4 ..a11.. tension 4 ..a14;
    picture pa;
    draw(pa, ga, p);

    picture pleft;
    add(pleft,pa);

    pair b1 = (36,114);
    pair b2 = (36,87);
    pair b3 = (40,82);
    pair b4 = (54,85);
    pair b5 = (72,101);
    guide gb = b1 .. tension 4 .. b3 .. tension 4 .. b5;
    picture pb;
    draw(pb, gb, p);
    add(pleft, pb);

    pair c1 = (90,146);
    pair c5 = (86,119);
    pair c6 = (122,126);
    pair c9 = (113,113);

    guide gc = c1 .. tension 4 .. c5 .. tension 4 .. c6
        .. tension 4 .. c9;
    picture pc;
    draw(pc, gc, p);

    picture pright;
    add(pright, pc);

    pair d1 = (101,115);
    pair d3 = (90,90);
    pair d7 = (71,75);
    guide gd = d1 .. tension 1 .. d3 .. d7;
    picture pd;
    draw(pd, gd, p);
    add(pright, pd);

    pair e1 = (95,96);
    pair e2 = (110,88);
    pair e5 = (130,70);
    guide ge = e1 .. tension 4 .. e2 .. e5;
    picture pe;
    draw(pe, ge, p);
    add(pright, pe);

    add(pic, pleft);
    add(pic, shift(-3,7)*pright);
    return xscale(0.8)*pic;
}

// yu cn <<<2

picture sign_yu_cn(pen p = flatnib_cn)
{
    picture pic;
    pair a1 = (66,185);
    pair a2 = (55,161);
    pair a3 = (86,174);

    picture pa, pleft;
    guide ga;
    ga = a1 .. tension 4 .. a2 .. tension 4 .. a3;
    draw(pa, ga, p);
    add(pleft, shift(-24,20)*rotate(-12)*pa);

    pair b1 = (69,156);
    pair b2 = (84,157);
    pair b3 = (70,144);
    pair b4 = (83,146);

    picture pb;
    guide gb = b1.. tension 4 ..b2.. tension 4 ..b3.. tension 4 ..b4;
    draw(pb, gb, p);
    add(pleft, shift(40W + 3S)*xscale(1.6)*pb);

    pair c1 = (77,154);
    pair c2 = (75,120);
    pair c3 = (76,120);
    pair c4 = (84,129);

    picture pc;
    guide gc = c1.. tension 6 ..c2.. tension 4 ..c3.. tension 4 ..c4;
    draw(pc, gc, p);
    add(pleft, shift(7E + 2S)*pc);

    pair d1 = (98,169);
    pair d3 = (122,173);
    pair d4 = (121,164);
    pair d5 = (100,145);
    pair d6 = (98,148);
    pair d8 = (112,154);
    pair d9 = (115,151);
    pair d13 = (94,119)+10W;
    pair d16 = (116,128)+8S;

    picture pright, pd;
    guide gd = d1..tension 2 ..d3..d4.. tension 1.5 ..
        d5..d6..tension 1.5 ..d8..
        d9.. tension 2 ..
        d13..d13..tension 2.5 ..d16..d16+2SE;
    draw(pd, gd, p);
    add(pright, shift(40E)*slant(-0.2)*pd);

    pair e1 = (126,142);
    pair e2 = (128,140);
    pair e3 = (129,138);

    picture pe;
    guide ge = e1..e2..e3;
    draw(pe, ge, p);
    add(pright, shift(15S)*pe);

    add(pic, rotate(-5, c3)*pleft);
    add(pic, pright);

    return pic;
}

// yuan cn <<<2

picture sign_yuan_cn(pen p = flatnib_cn)
{
    picture pic;
    pair a1 = (20,97);
    pair a2 = (66,107);
    pair a3 = (47,121);
    pair a4 = (47,76);
    pair a5 = (61,84);

    picture pleft, pa;
    guide ga = a1..tension 4 ..a2.. tension 4 ..a3
        ..tension 6 ..a4..tension 4 ..a5;
    draw(pa, ga, p);
    add(pleft, shift(30E)*xscale(0.7)*pa);

    pair b1 = (82,126);
    pair b2 = (96,127);
    pair b3 = (102,126);
    pair b4 = (92,120);
    pair b5 = (81,105);
    pair b6 = (71,69);
    pair b7 = (67,66);

    picture pright, pb;
    guide gb = b1..b2..b3..b3..b4..b5..b6..b7;
    draw(pb, gb, p);
    add(pright, pb);

    pair c1 = (97,114);
    pair c2 = (100,111);
    pair c3 = (96,96);
    pair c4 = (109,111);
    pair c5 = (114,108);
    pair c6 = (111,98);
    pair c7 = (100,94);
    pair c8 = (102,98);
    pair c9 = (105,101);
    pair c10 = (108,101);
    pair c11 = (105,95);
    pair c12 = (103,93);
    pair c13 = (105,71);
    pair c14 = (105,63);
    pair c15 = (97,73);
    pair c16 = (105,79);
    pair c17 = (114,77);
    pair c18 = (122,73);
    pair c19 = (124,71);

    picture pc;
    guide gc = c1..tension 1.5 ..c2..c2{left}..c2+(-1,-1)..
        c3..c3{up}..tension 1 ..{right}c4
        ..c5..c6..tension 1.5 ..c7
        .. tension 1.5 ..c9..c9+(2,-1)..tension 4 
        ..c14..tension 3 ..c15..c16
        ..c17..c18;
    draw(pc, gc, p);
    add(pright, shift(9NW)*pc);

    add(pic, pleft);
    add(pic, pright);

    return pic;
}

// ouyuyuan cn <<<2

picture sign_ouyuyuan_cn(pen p = flatnib_cn)
//picture sign_ouyuyuan_cn()
{
    picture pic, pa, pb, pc;
    pa = sign_ou_cn(p);
    pb = sign_yu_cn(p);
    pc = sign_yuan_cn(p);

    add(pic, scale(0.45)*pb.fit(), (0,0));
    add(pic, scale(0.5)*pc.fit(), (1.6,0.6)*1cm);
    add(pic, scale(0.45)*pa.fit(), (-0.9,0.6)*1cm);

    return pic;
}

// ouyuyuan cn time <<<2

picture sign_ouyuyuan_cn_time()
{
    picture pic, pic2;
    pic2 = sign_ouyuyuan_cn();

    string t = time("%Y-%m-%d %H:%M:%S UTC+8");

    label(pic, "\ttfamily " + t, fontsize(28pt));
    add(pic, pic2.fit(), (0,0), 20N);
    return pic;
}

// ou time <<<2

picture sign_ou_time()
{
    picture pic;
    picture pic2 = sign_ou();
    string t = time("%Y-%m-%d %H:%M:%S UTC+8");

    label(pic, "\ttfamily " + t, fontsize(28pt));
    add(pic, pic2.fit(), (0,0), 20N);
    return pic;
}

// timestamp <<<1

string timestamp()
{
    return time("%Y-%m-%d %H:%M:%S UTC+8");
}

// read file data <<<1

// string column <<<2

string[] read_string(string filename, int column) {
    file in = input(filename, comment="#");
    string[] lines = in; // read as strings
    string[] col_data;

    for (int i=0; i<lines.length; ++i) {
        string[] s = split(lines[i]);
        if (s.length == 0) continue; // comment line
        col_data.push(s[column]);
    }
    return col_data;
}

// integer column  <<<2

int[] read_int(string filename, int column) {
    file in = input(filename, comment="#");
    string[] lines = in; // read as strings
    int[] col_data;

    for (int i=0; i<lines.length; ++i) {
        string[] s = split(lines[i]);
        if (s.length == 0) continue; // comment line
        col_data.push((int)s[column]);
    }
    return col_data;
}

// real column <<<2

real[] read_real(string datafile, int n) {
    file in = input(datafile).line().word();
    string[][] cols = in.dimension(0,0);
    cols = transpose(cols);

    real[] data = (real[])cols[n]; 
    data.delete(n); // first line is comment

    return data;
}

// shipout image <<<1

void myshipout( string fmt="pdf", string dir="" ) {

    string imgdir = "/home/ou/archive/drawing";
    if ( dir != "" ) {
        imgdir += "/" + dir;
    }
    string filename = imgdir + "/" + outprefix();

    if ( fmt == "pdf" ) {
        settings.outformat="pdf";
        shipout(filename);

    } else if ( fmt == "eps" ) {
        settings.outformat = nativeformat();
        shipout(filename);

    } else if ( fmt == "png" ) {
        settings.outformat="pdf";
        shipout(filename);

        string pdf = filename + ".pdf";
        string png = imgdir + "/png/" + outprefix() + ".png";
        string cmd = "convert -density 150 -units PixelsPerInch";
        cmd = cmd + " " + pdf + " " + png;

        system(cmd);

    } else if ( fmt == "3d" ) {
        settings.outformat="pdf";
        shipout(filename);
        settings.prc=false;
        settings.render=6;

        shipout(filename);

        string pdf = filename + ".pdf";
        string png = imgdir + "/png/" + outprefix() + ".png";
        string cmd = "convert -density 300 -units PixelsPerInch";
        cmd = cmd + " " + pdf + " " + png;

        system(cmd);

    } else {
        write("Incorrect format in shiptout function. exit.");
        exit;
    }
}
