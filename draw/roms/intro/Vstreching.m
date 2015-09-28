draw_dir = '/home/ou/archive/drawing/roms/intro';
img      = fullfile(draw_dir, 'Vstreching.png');

s = 8;
%s = -8;
%s = 0;
%b = -1;
b = 8;

x = -1:0.02:0;

%y = sin(x);
%y = cosh(x);

if s > 0,
  y = ( 1 - cosh(s*x) ) / ( cosh(s) - 1 );
else
  y = - x.*x;
%  disp('"s" should not be negative. Stop');
%  return;
end

y0 = x;
y = ( exp(b*y) - 1 ) ./ ( 1 - exp(-b) );

plot(x,y);
%plot(x,y0);
saveas(gcf, img);
