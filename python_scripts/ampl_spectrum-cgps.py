#! /usr/bin/env python

import matplotlib.pyplot as plt
import scipy as sp
import numpy as np


def loadnoisefile(filename):
    file  = open(filename, "r")
    header1 = file.readline()  ## skip the first line
    header2 = file.readline()  ## skip the second line
    lines = file.readlines()
    file.close()
    x1 = []
    N1 = []
    E1 = []
    U1 = []
    for line in lines:
      p = line.split()
      x1.append(float(p[17]))  ## epoch
      N1.append(float(p[6]))   ## North
      E1.append(float(p[8]))   ## East
      U1.append(float(p[10]))  ## Up
    x = np.array(x1)           ## array of x
    N = np.array(N1)          
    E = np.array(E1)          
    U = np.array(U1)          
    return x, N, E, U


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


### work on GPS data - "Fs" defines the frequency (samples per seconds)
gpsdir = "/home/elidana/work/sdf_mueller/track-outputs/"
inputfile  = gpsdir+"TRAK200.NEU.prtu.LC"
Fs = 1.0;               
(t,N,E,U) = loadnoisefile(inputfile)
(frN,yN)  = calcSpectrum(N,Fs)
(frE,yE)  = calcSpectrum(E,Fs)
(frU,yU)  = calcSpectrum(U,Fs)

## work on Yoshi Model
modeldir   = "/home/elidana/work/sdf_mueller/models/yoshi/model13_dataset1/"
inputfile1 = modeldir+"GPS_prtu_E.dat"
Fs1 = 13.0; 
(t1,y1) = loadmodelfile(inputfile1)
(frq1,Y1) = calcSpectrum(y1,Fs1)

plt.loglog(frN,abs(yN), 'r')
plt.loglog(frq1,abs(Y1), 'k')

plt.xlabel('Freq (Hz)')
plt.ylabel('|Y(freq)|')

plt.show()
