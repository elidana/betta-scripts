#! /bin/csh

### --- calculate average mp1, mp2, cycle slip and obs value from QC summaries of the last 45 days


set inputdir = sum_network

set mp1  = mp1.avg
set mp2  = mp2.avg
set obs  = obs.avg
set slp  = slip.avg
set osl  = osl.avg

set sitelist = tmp1.$$


### -- check an print the last 45 days data interval
set from  = `ls $inputdir/????????.??S | awk 'BEGIN {FS="/"} {print substr($NF,5,3)}' | sort -u | head -1`
set fromy = `ls $inputdir/????????.??S | awk 'BEGIN {FS="/"} {print 20substr($NF,10,2)}' | sort -u | head -1`
set to    = `ls $inputdir/????????.??S | awk 'BEGIN {FS="/"} {print substr($NF,5,3)}' | sort -u | tail -1`
set toy   = `ls $inputdir/????????.??S | awk 'BEGIN {FS="/"} {print 20substr($NF,10,2)}' | sort -u | tail -1`


ls $inputdir/????????.??S | cut -c13-16 | sort -u > $sitelist


foreach sta (`cat $sitelist`)
  echo 'working on ' $sta
  set a = `ls $inputdir/${sta}????.??S`
 ## -- media e deviazione standard di #have
  set mo = `grep -F SUM $a | awk '{sum += $13*$13}; END {print sqrt(sum/NR)}'`
  set so = `grep -F SUM $a | awk -v m=$mo '{sum += ($13-m)*($13-m)}; END {print sqrt(sum/NR)}'`
  echo $mo $so $sta | awk '{printf"%15.6f%15.6f%10s\n",$1,$2,$3}' >> $obs
 ## -- media e deviazione standard di observation/cycle_slps
  set ms = `grep -F SUM $a | awk '{sum += $17*$17}; END {print sqrt(sum/NR)}'`
  set ss = `grep -F SUM $a | awk -v m=$ms '{sum += ($17-m)*($17-m)}; END {print sqrt(sum/NR)}'`
  echo $ms $ss $sta | awk '{printf"%15.6f%15.6f%10s\n",$1,$2,$3}' >> $osl
 ## -- media e deviazione standard di observation/cycle_slps
  set ms = `grep -F SUM $a | awk '{sum += ((1/$17)*1000)*((1/$17)*1000)}; END {print sqrt(sum/NR)}'`
  set ss = `grep -F SUM $a | awk -v m=$ms '{sum += (((1/$17)*1000)-m)*(((1/$17)*1000)-m)}; END {print sqrt(sum/NR)}'`
  echo $ms $ss $sta | awk '{printf"%15.6f%15.6f%10s\n",$1,$2,$3}' >> $slp
 ## -- media e deviazione standard di mp1
  set mm1 = `grep -F SUM $a | awk '{sum += $15*$15}; END {print sqrt(sum/NR)}'`
  set sm1 = `grep -F SUM $a | awk -v m=$mm1 '{sum += ($15-m)*($15-m)}; END {print sqrt(sum/NR)}'`
  echo $mm1 $sm1 $sta | awk '{printf"%15.6f%15.6f%10s\n",$1,$2,$3}' >> $mp1
 ## -- media e deviazione standard di mp2
  set mm2 = `grep -F SUM $a | awk '{sum += $16*$16}; END {print sqrt(sum/NR)}'`
  set sm2 = `grep -F SUM $a | awk -v m=$mm2 '{sum += ($16-m)*($16-m)}; END {print sqrt(sum/NR)}'`
  echo $mm2 $sm2 $sta | awk '{printf"%15.6f%15.6f%10s\n",$1,$2,$3}' >> $mp2
end


## --- order the station following increasing value of each qc-parameter
foreach c ($obs $slp $mp1 $mp2 $osl)
 sort -n $c > tmp.$$
 awk '{print NR,$0}' tmp.$$ > $c
end

foreach c ($obs $slp $mp1 $mp2 $osl)
 echo 'from ' $fromy-$from 'to ' $toy-$to > tmp1.$$
 cat $c >> tmp1.$$
 mv tmp1.$$ $c
end

mv $obs $slp $mp1 $mp2 $osl qc-tseries/.

echo ------
echo ''
echo avg files are ready


rm *.$$
