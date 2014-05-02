#! /bin/csh

if ($#argv == 0) then
cat << END
 
    3a-creatimeseries.csh   site

END
exit
endif

## WARNING - funziona solo dal 2000 in poi



set sta = $1

#foreach sta (auck quar kara)

 set perc = ${sta}_perc.plt
 set mp1  = ${sta}_mp1.plt
 set mp2  = ${sta}_mp2.plt
 set osl  = ${sta}_osl.plt
 set slp  = ${sta}_slip.plt
 
 foreach file (sum/${sta}????.??S)
  #set d = `echo $file:t | cut -c 5-7`
  #set y = `echo $file:t | cut -c 10-11`
  set date = `grep SUM $file | awk '{printf"20%02s-%02s-%02s\n",$2,$3,$4}'`
  echo $date `grep SUM $file | awk '{print $14}'` >> $perc.$$
  echo $date `grep SUM $file | awk '{print $15}'` >> $mp1.$$
  echo $date `grep SUM $file | awk '{print $16}'` >> $mp2.$$
  echo $date `grep SUM $file | awk '{print $17}'` >> $osl.$$
  echo $date `grep SUM $file | awk '{print (1/$17)*1000}'` >> $slp.$$
 end
 
 foreach tmp (${sta}*.$$)
  cat $tmp | sort > qc-tseries/$tmp:r
  rm $tmp
 end

echo qc time series for $sta are ready

#end



