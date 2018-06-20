function [f] = gal(x)

f1 = x(1)-x(2)-3;
f2= 3*x(1)-8*x(2)-14;
f= f1.^2+f2.^2;

end