
%function [lon,lat,h]=x_etopo(Llon, Rlon, Blat, Tlat, Fname);

Fname = Bname;
x=nc_read(Fname,'x');
y=nc_read(Fname,'y');

%--------------------------------------------------------------------------
%  If geographical area is a both sides of the day line (Lon=-180=180),
%  we need to convert to east longitudes: 0 to 360.
%--------------------------------------------------------------------------

if (abs(Llon) > 180 || abs(Rlon) > 180),
  ind=find(x < 0);
  x(ind)=360+x(ind);
end

%--------------------------------------------------------------------------
%  Determine indices to extract.
%--------------------------------------------------------------------------

I=find(x >= Llon & x <= Rlon);
X=x(I);
[X,Isort]=sort(X);
I=I(Isort);

J=find(y >= Blat & y <= Tlat);
Jmin=min(J);
Jmax=max(J);
Y=y(J); Y=Y';

%--------------------------------------------------------------------------
%  Read in bathymetry.
%--------------------------------------------------------------------------

topo=nc_read(Fname,'z');
h=topo(I,Jmin:Jmax);
[Im,Jm]=size(h);

%--------------------------------------------------------------------------
%  Set coordinates of extracted bathymetry.
%--------------------------------------------------------------------------

lon=repmat(X,[1 Jm]);
lat=repmat(Y,[Im 1]);
