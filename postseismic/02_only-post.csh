#! /bin/csh -f

if ($#argv == 0) then
cat << END
  ./02_only-post.csh  sitename
END
exit
endif

set sta  = `echo $1 | awk '{print toupper($1)}'`

foreach stafile (${sta}_?.out)
  set infile  = $stafile
  set inlog   = ${infile}.log
  set outfile = ${infile}.onlypost

  #set first = `head -1 $infile | awk '{print $1}'`  #### first day of data
  set first = `head -1 $infile | awk '{print ($1+($2/365.25))}'`  #### first day of data

  echo extracting info from $inlog and $infile

  set b  = `grep -F "Nomimal value for baseline" $inlog | tail -1 | awk '{print $6}'`
  set v  = `grep -F "Rate in units per year" $inlog  | tail -1 | awk '{print $6}'`
  set a1 = `grep -F "Period of  365.250 days" $inlog | tail -1 | awk '{print $12}'`   ## sin amplitude annual period
  set a2 = `grep -F "Period of  182.625 days" $inlog | tail -1 | awk '{print $12}'`   ## cos amplitude annual period
  set b1 = `grep -F "Period of  365.250 days" $inlog | tail -1 | awk '{print $7}'`    ## sin amplitude semiannual period
  set b2 = `grep -F "Period of  182.625 days" $inlog | tail -1 | awk '{print $7}'`    ## cos amplitude semiannual period

  if ($#v  == 0) set v  = 0
  if ($#a1 == 0) set a1 = 0
  if ($#a2 == 0) set a2 = 0
  if ($#b1 == 0) set b1 = 0
  if ($#b2 == 0) set b2 = 0

  echo $first $b $v $a1 $a2 $b1 $b2 > input.param

  cat $infile | awk '{printf"%10.5f\n",$1+($2/365.25)}' > input1  ## epochs
  cat $infile | awk '{print $5}' > input2  ## observed
  cat $infile | awk '{print $4}' > input3  ## model

  ./postseismic.m 

  #echo time obs mod > $outfile
  #tail -n +6 output | awk '{if ($1 > 0) printf "%10.5f %10.3f %10.3f\n",$1,$2,$3}' >> $outfile
  echo year doy obs mod > $outfile
  cat $infile | awk '{print $1,$2}' > tmp1.$$
  tail -n +6 output | awk '{if ($1 > 0) print $2,$3}' >> tmp2.$$
  paste tmp1.$$ tmp2.$$ | awk '{if ($1 > 0) printf "%10.4f%12.5f %15.3f %15.3f\n",$1,$2,$3,$4}' >> $outfile


  echo $outfile created

  rm input1 input2 input3 input.param output tmp?.$$
end
exit
