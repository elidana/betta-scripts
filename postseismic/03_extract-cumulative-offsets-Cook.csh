#! /bin/csh -f

#### ----------------------------------------------------------
####
####  estimate cumulative values (true cosismic offset and postseismic
###     displacement) for GPS+InSar inversion
####    doy1 = 27/07/2013 (doy 208)
####    doy2 = 20/08/2013 (doy 232)
####
#### ----------------------------------------------------------


set coordfile = /home/elidana/work/cook-earthquakes/sites.lonlat
set sub = out.onlypost
set log = out.log

set tseries = /home/elidana/work/cook-earthquakes/Hamling-etal_paper/02_review/results/white-noise
set logs    = $tseries

## Cook Eq      = doy 202-2013 (21-July)
## Grassmere Eq = doy 228-2013 (16 August)


## Cook earthquake only
#set dd1 = 200
#set dd2 = 202
#set out1 = 01_Cook_coseismic.dat

## Cook to Grassmere (Cook postseismic)
set dd1 = 202
set dd2 = 226
set out1 = 02_Cook-to-Grassmere.dat

## GPS+InSar Grassmere modelling (Initial Submission)
##set out1 = cumulative_offsets.dat
#set dd1 = 208
#set dd2 = 232
#set out1 = 03_Grassmere_coseismic-InSAR.dat


## Grassmere to InSAR 
#set dd1 = 227
#set dd2 = 232
#set out1 = 04_Grassmere-to-InSAR.dat


set d0 = `echo 2013 $dd1 | awk '{printf"%10.4f%12.5f\n",$1,$2}'`
set d1 = `echo 2013 $dd2 | awk '{printf"%10.4f%12.5f\n",$1,$2}'`

echo calculating offsets from $d0  to $d1

#### ----------------------------------------------------------
### --
### -- offset cosismici
### --

cat << END > $out1
#
#  Cook earthquake sequence cumulative offsets
#  doy1 = 2013-${dd1} / doy2 = 2013-${dd2}
#  N, E, U components (mm)
#  lat lon N  E  U  sN  sE  sU  SITE
#
END
#foreach s (`cat sites.list.all | awk '{print toupper($1)}'`)
foreach s (`cat sites.list | awk '{print toupper($1)}'`)
 echo ------------- $s
 set xy = `grep $s $coordfile | awk '{print $1,$2}'`
 set dioce1 = `grep $d0[1] $tseries/${s}_e.${sub} | grep $d0[2]`
 set dioce2 = `grep $d1[1] $tseries/${s}_e.${sub} | grep $d1[2]`
 echo $dioce1 $dioce2
 if ($#dioce1 != 0 && $#dioce2 != 0) then

   foreach comp (n e u)
     #set a0 = `grep "^$d0" $tseries/${s}_${comp}.${sub} | awk '{print $4}'`
     #set a1 = `grep "^$d1" $tseries/${s}_${comp}.${sub} | awk '{print $4}'`
     set a0 = `grep $d0[1] $tseries/${s}_${comp}.${sub} | grep $d0[2] | awk '{print $4}'`
     set a1 = `grep $d1[1] $tseries/${s}_${comp}.${sub} | grep $d1[2] |awk '{print $4}'`

     set cum = `echo $a0 $a1 | awk '{print $2-$1}'`
     set rms = `grep "white noise" $logs/${s}_${comp}.${log} | tail -1 | awk '{print sqrt($3)}'`
     if ($s == A7R1) set rms = `grep RMS $logs/${s}_${comp}.${log} | awk '{print sqrt($8)}'`
     if ($comp == n) set n = `echo $cum $rms`
     if ($comp == e) set e = `echo $cum $rms`
     if ($comp == u) set u = `echo $cum $rms`
   end
 
   echo $xy[1] $xy[2] $n[1] $e[1] $u[1] $n[2] $e[2] $u[2] $s \
    | awk '{printf"%12.5f%12.5f%10.2f%10.2f%10.2f%10.2f%10.2f%10.2f%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9}' >> $out1
   echo $xy[1] $xy[2] $n[1] $e[1] $u[1] $n[2] $e[2] $u[2] $s \
    | awk '{printf"%12.5f%12.5f%10.2f%10.2f%10.2f%10.2f%10.2f%10.2f%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9}' 

 else if ($#dioce1 == 0 || $#dioce2 == 0) then
   echo ${s} non ha valore 
 endif

end


rm input? input.param output? 

