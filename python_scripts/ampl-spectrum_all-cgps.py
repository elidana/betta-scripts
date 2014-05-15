#! /usr/bin/env python

import matplotlib.pyplot as plt
import scipy as sp
import numpy as np
import os


gpsdir = "/home/elidana/work/sdf_mueller/track-outputs/"
#sitelist = open('sites.list','r')

def loadsitelist():
    f = open('sites.list', "r")
    list = f.readlines()
    f.close()
    return list

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

def calcSpectrum(y,Fs):
    n = len(y)
    k = sp.arange(n)
    T = n/Fs
    frq = k/T
    frq = frq[range(n/2)]
    Y = 2*sp.fft(y)/n
    Y = Y[range(n/2)]
    return frq, abs(Y)

def savefile(array,fileout):
    arr = np.array(array)
    arr1 = arr.T
    np.savetxt(fileout,arr1)

Fs = 1.0;               

for sites in loadsitelist():
    site = sites.strip()
    print ("Working on %s" % site)
    inputfile = gpsdir+"TRAK200.NEU."+site+".LC"

    (N,E,U) = loadnoisefile(inputfile)
    (frN,yN) = calcSpectrum(N,Fs)
    (frE,yE) = calcSpectrum(E,Fs)
    (frU,yU) = calcSpectrum(U,Fs)

    siteoutn = open("spectrum.N.%s.out" % (site), 'w')
    siteoute = open("spectrum.E.%s.out" % (site), 'w')
    siteoutu = open("spectrum.U.%s.out" % (site), 'w')
    
    savefile((frN,yN),siteoutn)
    savefile((frE,yE),siteoute)
    savefile((frU,yU),siteoutu)

    siteoutn.close()
    siteoute.close()
    siteoutu.close()


