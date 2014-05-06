#! /usr/bin/env python


import matplotlib.pyplot as plt
import scipy as sp
import numpy as np


def loadnoisefile(filename):
    file  = open(filename, "r")
    lines = file.readlines()
    file.close()
    x1 = []
    y1 = [] 
    for line in lines:
      p = line.split()
      x1.append(float(p[17]))  ## epoch
      y1.append(float(p[8]))   ## east (NEU)
    xv = np.array(x1)                ## array of x
    yv = np.array(y1)                ## array of y
    return xv, yv

def loadmodelfile(filename1):
    file  = open(filename1, "r")
    lines = file.readlines()
    file.close()
    x1 = []
    y1 = []
    for line in lines:
      p = line.split()
      x1.append(float(p[0]))  ## epoch
      y1.append(float(p[1]))   ## east (NEU)
    xv = np.array(x1)                ## array of x
    yv = np.array(y1)                ## array of y
    return xv, yv


def calcSpectrum(y,Fs):
    n = len(y)
    k = sp.arange(n)
    T = n/Fs
    frq = k/T
    frq = frq[range(n/2)]
    Y = 2*sp.fft(y)/n
    Y = Y[range(n/2)]
    return frq, Y


Fs = 1.0;   ## frequency
Ts = 1.0/Fs;

Fs1 = 13.0;   ## frequency (samples per seconds)
Ts1 = 1.0/Fs;

inputfile  = "TRAK200.NEU.cnst.LC"
inputfile1 = "GPS_ptoi_E.dat"

(t,y) = loadnoisefile(inputfile)
(t1,y1) = loadmodelfile(inputfile1)

(frq,Y) = calcSpectrum(y,Fs)
(frq1,Y1) = calcSpectrum(y1,Fs1)

plt.loglog(frq,abs(Y), 'r')
plt.loglog(frq1,abs(Y1), 'k')
plt.xlabel('Freq (Hz)')
plt.ylabel('|Y(freq)|')

plt.show()
