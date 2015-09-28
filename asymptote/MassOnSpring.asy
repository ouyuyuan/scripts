// Mass on a spring, adapted from Feynman Lectures, V1, P.9-4 figure 9.3
//@hierarchy:mass on a spring

import graph3;
import mycolor;

size3(200);

currentlight.background = mybackground;
//currentprojection = obliqueX;
//currentprojection=perspective(
//camera=(6.830650732609,-0.059869388066799,-1.90916143977444));

limits((0,0,0), (2,2,-2));
axes3("$x$","$y$","$z$",Arrow3);

real radius = 0.5;
draw(scale3(radius)*unitsphere, grey, currentlight);

// spring
picture PicSpr;
{
    // spring parameter equation
    real r = 0.05, zv = 0.2;
    real x(real t) { return sqrt(r)*cos(2pi*t); }
    real y(real t) { return sqrt(r)*sin(2pi*t); }
    real z(real t) { return zv*t; }
    triple spring(real t) { return (x(t), y(t), z(t)); }

    real ta = 1, tb = 11; // domain of parameter t

    guide3 spring = O--spring(ta) &                   // head 
                  graph(x,y,z,ta,tb,operator ..) &    // body
                  spring(tb)--spring(tb)+(0,0,z(ta)); // head

    draw(PicSpr, spring, grey+linewidth(0.5mm), currentlight);

    // suspended wall in YZ plane
    picture PicWall;
    {
        // shadow
        real length = 2, height = 0.25, deg = 45;
        pair a = (0,0), b = height*(Cos(45),Sin(45));
        guide line = a--b;

        int n = 10;
        for (int i = 0; i <= n; ++i) {
            guide3 g = path3( shift(length * i/n,0)*line, YZplane );
            draw(PicWall, g);
        }

        // boundary side
        guide boun = (0,0)--(length,0);
        guide3 g = path3(boun, YZplane);
        draw(PicWall, g, linewidth(2));

        triple shift = spring(tb) + (0,0,z(ta)) + (0,-length/2,0);
        add(PicSpr, shift(shift) * PicWall);
    }

    add(shift(0,0,radius-z(ta))*PicSpr);
}

shipout("MassOnSpring.pdf");
