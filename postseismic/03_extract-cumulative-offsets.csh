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

set tseries = /home/elidana/work/cook-earthquakes/Hamling-etal_paper/02_review/results
set logs    = /home/elidana/work/cook-earthquakes/Hamling-etal_paper/02_review/results

## Cook Eq      = doy 202-2013 (21-July)
## Grassmere Eq = doy 228-2013 (16 August)

## GPS+InSar Grassmere modelling (Initial Submission)
#set dd1 = 208
#set dd2 = 232
#set out1 = cumulative_offsets.dat

## Cook to Grassmere (Cook postseismic)
set dd1 = 203
set dd2 = 227
set out1 = Cook-to-Grassmere_offsets.dat

## Grassmere to InSAR 
set dd1 = 229
set dd2 = 232
set out1 = Grassmere-to-InSAR_offsets.dat

set d0 = `echo 2013 $dd1 | awk '{printf"%10.5f\n",$1+($2/365.25)}'`
set d1 = `echo 2013 $dd2 | awk '{printf"%10.5f\n",$1+($2/365.25)}'`

echo $d0 $d1
set tmp = tmp.$$ 
set scarto = 0.0027

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
foreach s (`cat sites.list.all | awk '{print toupper($1)}'`)
 echo ------------- $s
 set xy = `grep $s $coordfile | awk '{print $1,$2}'`

  foreach comp (n e u)
   #set a0 = `grep "^$d0" $tseries/${s}_${comp}.${sub} | awk '{print $3}'`
   #set a1 = `grep "^$d1" $tseries/${s}_${comp}.${sub} | awk '{print $3}'`
   ## modifica qui sotto e per tenere conto di schifezze yyyy ddd to yyyy.yyyy
   set a0 = `awk -v a=$d0 -v b=$scarto '{if ($1 > (a-b) && $1 < (a+b)) print $3}' $tseries/${s}_${comp}.${sub} `
   set a1 = `awk -v a=$d1 -v b=$scarto '{if ($1 > (a-b) && $1 < (a+b)) print $3}' $tseries/${s}_${comp}.${sub} `

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

