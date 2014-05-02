#! /usr/bin/octave -qf
### toglie componenti non postseismic da tserie elaborata con est-noise
## b = nominal value
## v = linear velocity
## a1 = sin ampl annual
## b1 = cos ampl annual
## a2 = sin ampl semiannual
## b2 = cos ampl semiannual

A = load ("input.param");
t1 = A(1);
b = A(2);
v = A(3);
a1 = A(4);
a2 = A(5);
b1 = A(6);
b2 = A(7);

x = load ("input1");
y = load ("input2");
m = load ("input3");
### TOGLIE COMPONENTE NON POSTSISMICA 
c = y-(b+ (v*(x-t1)) + (a1*sin(2*pi*(x-t1))) + (b1*cos(2*pi*(x-t1))) + (a2*sin(4*pi*(x-t1))) + (b2*cos(4*pi*(x-t1))));
d = m-(b+ (v*(x-t1)) + (a1*sin(2*pi*(x-t1))) + (b1*cos(2*pi*(x-t1))) + (a2*sin(4*pi*(x-t1))) + (b2*cos(4*pi*(x-t1))));

B = [x,c,d];
save output B

#gset terminal postscript;
#set output "output.ps";
#plot(x,c,x,d);
