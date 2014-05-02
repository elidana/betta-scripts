#! /bin/csh -f

### estrae valori da log di estnoise per calc_frommodel.m

set sta  = `echo $1 | awk '{print toupper($1)}'`
set comp = $2

set type = clean
set exp  = e
set log_dir = ./logs
set tseries = ./tseries

set inlog = ${log_dir}/${sta}.${comp}.${type}.${exp}.log
#echo extracting info from $inlog

cat ./$tseries/${sta}.${comp}.${type}.${exp} | cl 1 > input1

### crea serie di punti continua
goto NOCONT
rm input1
set start = `cat ./raw/${sta}.${comp} | cl 1 2 | head -1 | awk '{printf"%12.8f\n",$1+($2/365.25)}'`
set end   = `echo 2010 100 | awk '{printf"%12.8f\n",$1+($2/365.25)}'`

set imax = `echo $end $start | awk '{print int(($1-$2)*365.25)}'`
set i = 1

while ($i <= $imax)
 set start = `echo $start | cl '(c1+ 0.00273785)'`
 echo $start >> input1
@ i++
end
NOCONT:
###

set b  = `grep -F "Nomimal value for baseline" $inlog | tail -1 | cl 6`
set a  = `grep -F "Exponential number   "      $inlog | tail -1 | cl 8`
set t  = `grep -F "Exponential number   "      $inlog | tail -1 | cl 14`
set tstart = `grep -F "Exponential number   "      $inlog | tail -1 | cl 5 6`
set off = `grep -F "Offset number     1"         $inlog | tail -1 | cl 8`

set d0 = `echo 2009  95.5 | awk '{printf"%12.8f\n",$1+($2/365.25)}'`
set d1 = `echo 2009 103.5 | awk '{printf"%12.8f\n",$1+($2/365.25)}'`
set d2 = `echo 2009 290.5 | awk '{printf"%12.8f\n",$1+($2/365.25)}'`
set doff = `echo $tstart  | awk '{printf"%12.8f\n",$1+($2/365.25)}'`

echo $b $a $t $doff $off $d0 $d1 $d2 > input.param

## --- porkata heaviside
awk -v a=$doff '{if ($1 <= a) print 0; else print 1}' input1 > input2

./calc_frommodel.m

#echo $sta $comp
#cat output2
#gnup -l1:3 ./tseries/${sta}.${comp}.${type}.${exp} -l1:2 output1 -p1:2 output2 -p1:2 output3

#rm input? input.param
