
.. Description: Barotropic stream function
..
..      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
..     Created: 2014-04-07 21:02:36 BJT
.. Last Change: 2014-04-07 21:14:09 BJT

Overview
--------

For Ferret.

reference__

__ http://www.pmel.noaa.gov/maillists/tmap/ferret_users/fu_2001/msg00303.html

Formular
--------

 Define a streamfunction, Psi(x,y), such that 
 u = d(Psi)/dy and v = -d(Psi)/dx. 		(1)
 By definition:	 du/dx+dv/dy = 0			(2)
 so the field is non-divergent. 
 Given (1), u=d(Psi)/dy -> Psi = Int{y0:y}u dy + a(x)	(3)
 and therefore:	d(Psi)/dx = Int{y0:y}du/dx dy + da/dx
 Given (2), d(Psi)/dx = Int{y0:y}(-dv/dy) dy + da/dx
                      = -v(x,y) + v(x,y_0) + da/dx	(4)
 But also, by definition:   d(Psi)/dx = -v(x,y)
 Therefore: 	da/dx = -v(x,y_0)
 a(x) = -Int{x_0:x}v(x,y_0) dx		(5)
 From (3) and (5):  
 Psi = Int{y0:y}u(x,y) dy - Int{x_0:x}v(x,y_0) dx  (6)

 Algorithm
-----------

#.  Choose an (x_0,y_0). Integrate the second (indefinite)
#.  Integral of (6) along y_0. The result is a function of x. Then at
    each x, indefinitely integrate the first integral of (6) along y.
#. The streamfunction is the sum of those two.


In a model with topo., we integrate from north to south, so
u[y=@iin] = u[y=@din] - u[y=@iin]
And note that when we choose north pole as y0, than v(x,y0)[x=@iin]
is all missing_value, that is, we don't need to compute it.
 
Special treatment wiith LICOM
-----------------------------

Licom has more 2 points on east also can us[x=0:359,z=@din]
but 359.5 will be excluded if it exist and us[x=0:359.99] will include 360 
You can check it in an interactive command window.

About missing value with @iin
-----------------------------

@din will not account missing value point, but @iin will get 
missing value if just one point of the series is missing value.
e.g., let xx = {1,3,5}; set var/bad=1 xx;
let sum = xx[x=@din]; let isum = xx[x=@iin]; list sum; list isum
then the result will be::

   yes? list sum
                VARIABLE : XX[X=@DIN]
                X        : 0.5 to 3.5
             8.000
   yes? list isum
                VARIABLE : XX[X=@IIN]
                SUBSET   : 3 points (X)
    1   / 1:....
    2   / 2:....
    3   / 3:....

That's why we need to set missing to zero befor @iin
