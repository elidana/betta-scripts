#! /bin/csh -f

#### ----------------------------------------------------------
####
####  estimate cumulative values (true cosismic offset and postseismic
###     displacement) for GPS+InSar inversion
####    doy1 = 27/07/2013 (doy 208)
####    doy2 = 20/08/2013 (doy 232)
####
#### ----------------------------------------------------------


set coordfile = /home/elidana/work/cook-earthquakes/20130816_6.6/globk_gras_13225-229.offsets
set sub = out.onlypost
set log = out.log

set logs = `pwd`
set tseries = `pwd`


set d0 = `echo 2013 208 | awk '{printf"%10.5f\n",$1+($2/365.25)}'`
set d1 = `echo 2013 232 | awk '{printf"%10.5f\n",$1+($2/365.25)}'`

set out1 = cumulative_offsets.dat

set tmp = tmp.$$ 

#### ----------------------------------------------------------
### --
### -- offset cosismici campotosto
### --

cat << END > $out1
#
#  coseismic and afterslip cumulative offsets 
#  doy1 = 2013-208 / doy2 = 2013-232
#  N, E, U components (mm)
#  lat lon N  E  U  sN  sE  sU  SITE
#
END
foreach s (CMBL WITH) 
 echo ------------- $s
 #set xy = `grep "^ $s" /raid/sta_info/*sta_pos /datagps/rinex2/igm/2009/sta_info/sta_pos | cl 8 9 10 | xyz2gd - | cl 1 2`
 set xy = `grep $s $coordfile | awk '{print $1,$2}'`

  foreach comp (n e u)
   set a0 = `grep "^$d0" $tseries/${s}_${comp}.${sub} | awk '{print $3}'`
   set a1 = `grep "^$d1" $tseries/${s}_${comp}.${sub} | awk '{print $3}'`

    if ($#a0 != 0 && $#a1 != 0 ) then
     set cum = `echo $a0 $a1 | awk '{print $2-$1}'`
     set rms = `grep RMS $logs/${s}_${comp}.${log} | awk '{print ($8*sqrt(2))}'`
     if ($comp == n) set n = `echo $cum $rms`
     if ($comp == e) set e = `echo $cum $rms`
     if ($comp == u) set u = `echo $cum $rms`
    else if ($#a0 == 0 || $#a1 == 0) then
     echo ${s} non ha valore per $comp - lo calcolo
     set cum = `calc_frommodel.csh ${s} ${comp}`
     set rms = `grep RMS $logs/${s}_${comp}.${log} | awk '{print ($8*sqrt(2))}'`
     if ($comp == n) set n = `echo ${cum[1]} $rms`
     if ($comp == e) set e = `echo ${cum[1]} $rms`
     if ($comp == u) set u = `echo ${cum[1]} $rms`
    endif
  end
 
  echo $xy[1] $xy[2] $n[1] $e[1] $u[1] $n[2] $e[2] $u[2] $s \
   | awk '{printf"%12.5f%12.5f%10.2f%10.2f%10.2f%10.2f%10.2f%10.2f%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9}' >> $out1
  echo $xy[1] $xy[2] $n[1] $e[1] $u[1] $n[2] $e[2] $u[2] $s \
   | awk '{printf"%12.5f%12.5f%10.2f%10.2f%10.2f%10.2f%10.2f%10.2f%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9}' 

end


rm input? input.param output?

