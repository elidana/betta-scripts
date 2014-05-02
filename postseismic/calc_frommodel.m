#! /usr/bin/octave -qf
### calcola valori di modello est_noise se non esiste gia per specifico doy
## b  = nominal value
## a  = exponential decay amplitude (exponential number)
## t  = exponential decay time (tau, time constant)
## x0 = earthquake time
## o  = offset at x0

## x  = epoch tserie
## h  = heaviside step function tserie

#format long

A = load ("input.param");
b = A(1);
a = A(2);
t = A(3);
x0 = A(4);
o = A(5);
d0 = A(6);
d1 = A(7);
d2 = A(8);

x = load ("input1");
h = load ("input2");

### heaviside step function
## COMECAZZOSIFAAAAAA
## per ora fatta porcata fuori

### --- CALCOLA MODELLO da output Estnoise
 ## y = postseismic decay tserie
 ## z = coseismic offset tserie
 ## w = resulting time series
y = h .* (a*(1-exp(-(x-x0)/t)));
z = b + (h * o);
w = y+z;

### --- calcola valori modello per epoche d1 e d2
 ## dd1 = valore doy 103.5 (coseismic)
 ## dd2 = valore doy 290.5-103.5 (postseismic)
y0 = b;
y1 = b+o+(a*(1-exp(-(d1-x0)/t)));
y2 = b+o+(a*(1-exp(-(d2-x0)/t)));
dd1 = y1-y0;
dd2 = y2-y1;

### --- file di output
 ## B output1 = modello ricalcolato
 ## C output2 = valori offset da invertire
 ## D output3 = valori su modello per doy 103.5 e 290.5
B = [x,w];
C = [d1,dd1;d2,dd2];
D = [d1,y1;d2,y2];
disp (dd1)
disp (dd2)
save output1 B
save output2 C
save output3 D

#plot(x,y,x,z);
