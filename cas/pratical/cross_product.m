
syms t;
a = [0 2*t t];
b = [exp(t) sin(t) t];
c = [exp(t) -cos(t) t^2/2];
d = [0 2 1];
r = cross(a,b) + cross(c,d)
