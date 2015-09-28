
// Description: stagger grid
//       Usage: /usr/bin/asy -globalwrite -nosafe xxx.asy
//
//      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
//     Created: 2012-03-24 10:07:07 CST
// Last Change: 2013-03-22 16:08:16 CST

import EmacsColors;
from myfunctions access myshipout;

// A grid  <<<1

unitsize(2cm);
pair A,B,C,D;
A=(0,0); B=(1,0); C=(1,1); D=(0,1);
path square = A--B--C--D--cycle;
draw(square,dashed);

label("A grid",0.5*(A+B),4*S);

//////////////////////////////////////////////////////////////////////////////
real len=0.05, lena=0.08;
pair ua,va,za, dza,dua,dva;
za=len*expi(pi/4); 
ua=len*expi(11*pi/12); 
va=len*expi(19*pi/12);
dza=lena*expi(pi/4); 
dua=lena*expi(11*pi/12); 
dva=(lena+0.01)*expi(19*pi/12);

dot(za,red3); label("$z$",dza,dza,red3);
dot(ua,green4); label("$u$",dua,dua,green4);
dot(va,mediumblue); label("$v$",dva,dva,mediumblue);
//////////////////////////////////////////////////////////////////////////////
pair ub,vb,zb, dub,dvb,dzb; pair transb = (1,0); real lenb=0.4;
zb=len*expi(3*pi/4)+transb;
ub=len*expi(pi/12) +transb; 
vb=len*expi(17*pi/12)+transb;
dzb=lenb*expi(3*pi/4); 
dub=lenb*expi(pi/12); 
dvb=(lenb+0.3)*expi(17*pi/12);

dot(zb,red3); label("$z$",zb,dzb,red3);
dot(ub,green4); label("$u$",ub,dub,green4);
dot(vb,mediumblue); label("$v$",vb,dvb,mediumblue);
//////////////////////////////////////////////////////////////////////////////
pair uc,vc,zc, duc,dvc,dzc; pair transc = (1,1); real lenc=0.4;
zc=len*expi(5*pi/4)+transc;
uc=len*expi(23*pi/12) +transc; 
vc=len*expi(7*pi/12)+transc;
dzc=lenc*expi(5*pi/4); 
duc=lenc*expi(23*pi/12); 
dvc=(lenc+0.3)*expi(7*pi/12);

dot(zc,red3); label("$z$",zc,dzc,red3);
dot(uc,green4); label("$u$",uc,duc,green4);
dot(vc,mediumblue); label("$v$",vc,dvc,mediumblue);
//////////////////////////////////////////////////////////////////////////////
pair ud,vd,zd, dud,dvd,dzd; pair transd = (0,1); real lend=0.4;
zd=len*expi(7*pi/4)+transd;
ud=len*expi(13*pi/12) +transd; 
vd=len*expi(5*pi/12)+transd;
dzd=lend*expi(7*pi/4); 
dud=lend*expi(13*pi/12); 
dvd=(lend+0.3)*expi(5*pi/12);

dot(zd,red3); label("$z$",zd,dzd,red3);
dot(ud,green4); label("$u$",ud,dud,green4);
dot(vd,mediumblue); label("$v$",vd,dvd,mediumblue);

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
picture picb;
draw(picb,square,dashed);
label(picb,"B grid",0.5*(A+B),4*S);

dot(picb,A,red3); label(picb,"$z$",A,0.4*SW,red3);
dot(picb,B,red3); label(picb,"$z$",B,0.4*SE,red3);
dot(picb,C,red3); label(picb,"$z$",C,0.4*NE,red3);
dot(picb,D,red3); label(picb,"$z$",D,0.4*NW,red3);

pair center = (1/4)*(A+B+C+D); 
pair u = 0.03*expi(pi)+center;
pair v = 0.03*expi(0)+center;
dot(picb,u,green4);     label(picb,"$u$",u,0.4*W,green4);
dot(picb,v,mediumblue); label(picb,"$v$",v,0.4*E,mediumblue);

add(shift(2*right)*picb);


// B grid <<<1

picture picc;
draw(picc,square,dashed);
label(picc,"C grid",0.5*(A+B),4*S);

dot(picc,A,red3); label(picc,"$z$",A,0.4*SW,red3);
dot(picc,B,red3); label(picc,"$z$",B,0.4*SE,red3);
dot(picc,C,red3); label(picc,"$z$",C,0.4*NE,red3);
dot(picc,D,red3); label(picc,"$z$",D,0.4*NW,red3);

pair u = 0.5*(A+B);
dot(picc,u,green4);     label(picc,"$u$",u,0.7*S,green4);
u = 0.5*(C+D);
dot(picc,u,green4);     label(picc,"$u$",u,0.7*N,green4);
pair v = 0.5*(B+C);
dot(picc,v,mediumblue);     label(picc,"$v$",v,0.5*E,mediumblue);
v = 0.5*(A+D);
dot(picc,v,mediumblue);     label(picc,"$v$",v,0.5*W,mediumblue);

add(shift(4*right)*picc);


// C grid <<<1

picture picc;
draw(picc,square,dashed);
label(picc,"C grid",0.5*(A+B),4*S);

dot(picc,A,red3); label(picc,"$z$",A,0.4*SW,red3);
dot(picc,B,red3); label(picc,"$z$",B,0.4*SE,red3);
dot(picc,C,red3); label(picc,"$z$",C,0.4*NE,red3);
dot(picc,D,red3); label(picc,"$z$",D,0.4*NW,red3);

pair u = 0.5*(A+B);
dot(picc,u,green4);     label(picc,"$u$",u,0.7*S,green4);
u = 0.5*(C+D);
dot(picc,u,green4);     label(picc,"$u$",u,0.7*N,green4);
pair v = 0.5*(B+C);
dot(picc,v,mediumblue);     label(picc,"$v$",v,0.5*E,mediumblue);
v = 0.5*(A+D);
dot(picc,v,mediumblue);     label(picc,"$v$",v,0.5*W,mediumblue);

add(shift(4*right)*picc);


// D grid <<<1

picture picd;
draw(picd,square,dashed);
label(picd,"D grid",0.5*(A+B),4*S);

dot(picd,A,red3); label(picd,"$z$",A,0.4*SW,red3);
dot(picd,B,red3); label(picd,"$z$",B,0.4*SE,red3);
dot(picd,C,red3); label(picd,"$z$",C,0.4*NE,red3);
dot(picd,D,red3); label(picd,"$z$",D,0.4*NW,red3);

pair v = 0.5*(A+B);
dot(picd,v,mediumblue);     label(picd,"$v$",v,0.7*S,mediumblue);
v = 0.5*(C+D);
dot(picd,v,mediumblue);     label(picd,"$v$",v,0.7*N,mediumblue);
pair u = 0.5*(B+C);
dot(picd,u,green4);     label(picd,"$u$",u,0.5*E,green4);
u = 0.5*(A+D);
dot(picd,u,green4);     label(picd,"$u$",u,0.5*W,green4);

add(shift(6*right)*picd);

myshipout("png");
