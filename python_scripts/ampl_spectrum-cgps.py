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
    N1 = []
    E1 = []
    U1 = []
    for line in lines:
      p = line.split()
      N1.append(float(p[6]))   ## North
      E1.append(float(p[8]))   ## East
      U1.append(float(p[10]))  ## Up
    N = np.array(N1)          
    E = np.array(E1)          
    U = np.array(U1)          
    return N, E, U


def loadmodelfile(filename1):
    file  = open(filename1, "r")
    lines = file.readlines()
    file.close()
    y1 = []
    for line in lines:
      p = line.split()
      y1.append(float(p[1]))  
    yv = np.array(y1)
    return yv


def calcSpectrum(y,Fs):
    n = len(y)
    k = sp.arange(n)
    T = n/Fs
    frq = k/T
    frq = frq[range(n/2)]
    Y = 2*sp.fft(y)/n
    Y = Y[range(n/2)]
    return frq, Y

site = ('gisb')
#site = raw_input("Enter the site code (lower case): ")


print "Working on GPS file"
### work on GPS data - "Fs" defines the frequency (samples per seconds)
gpsdir = "/home/elidana/work/sdf_mueller/track-outputs/"
inputfile  = gpsdir+"TRAK200.NEU."+site+".LC"
Fs = 1.0;               
(N,E,U) = loadnoisefile(inputfile)
(frN,yN) = calcSpectrum(N,Fs)
(frE,yE) = calcSpectrum(E,Fs)
(frU,yU) = calcSpectrum(U,Fs)

print "Working on Yoshimodel file"
## work on Yoshi Model
modeldir   = "/home/elidana/work/sdf_mueller/models/yoshi/model4_dataset1/"
inputfile1 = modeldir+"GPS_"+site+"_N.dat"
inputfile2 = modeldir+"GPS_"+site+"_E.dat"
inputfile3 = modeldir+"GPS_"+site+"_Z.dat"
Fs1 = 13.0; 
(N1) = loadmodelfile(inputfile1)
(E1) = loadmodelfile(inputfile2)
(U1) = loadmodelfile(inputfile3)
(frN1,yN1) = calcSpectrum(N1,Fs1)
(frE1,yE1) = calcSpectrum(E1,Fs1)
(frU1,yU1) = calcSpectrum(U1,Fs1)

## plot 
plt.title(site)
plt.subplot(3,1,1)
plt.loglog(frN,abs(yN), 'r')
plt.loglog(frN1,abs(yN1), 'k')
plt.xlabel('Freq (Hz)')
plt.ylabel('|North(m)|')

plt.subplot(3,1,2)
plt.loglog(frE,abs(yE), 'r')
plt.loglog(frE1,abs(yE1), 'k')
plt.xlabel('Freq (Hz)')
plt.ylabel('|East(m)|')

plt.subplot(3,1,3)
plt.loglog(frU,abs(yU), 'r')
plt.loglog(frU1,abs(yU1), 'k')
plt.xlabel('Freq (Hz)')
plt.ylabel('|Up(m)|')

plt.show()
