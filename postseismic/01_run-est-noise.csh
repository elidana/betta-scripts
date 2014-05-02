#! /bin/csh -f

if ($#argv == 0) then
 cat << End_of_usage
  
 Usage:
  run-est-noise.csh -s site -i [raw/filt/local] 
                   [ -noper ] [ -norate ] [ -w ]
                   [ -comp [n/e/u] ] [ -out string ]
                   [ -off  [c/g/cg] ] 
                   [ -post [c/g/cg] ] [ -exp [e/o/m] ] [ -tau XX] ]

  to see extensive usage type:   run-est-noise.csh help

End_of_usage
exit

else if ($#argv == 1) then
 cat << End_of_help
 
 run est_noise6ac on site (after Langbein, 2004; 2008)
 program to estimate noise model, rate, offset, postseismic functions, ecc.
 
 Usage:
  run-est-noise.csh -s site -i [raw/filt/local] 
                   [ -comp [n/e/u] ] [ -out string ]
                   [ -noper ] [ -norate ] 
                   [ -off  [c/g/cg] ] 
                   [ -post [c/g/cg] ] [ -exp [e/o/m] ] [ -tau XX] ]

    -s site = site code (case insensitive)

    -i [raw/filt/local]  = if input time series does not exist in local 
               directory, will be created from GeoNet timeseries (look for 
               /geonet/gps/solutions/plotfiles dir on your system)
               raw   = raw time series (Bernese output)
               filt  = regionally filtered time series (IgorPro output)
               local = .plt files are in the current directory
 
  Options:
    -out string = if selected, will add string as output name subfix

    -comp [n/e/u]  = if present, run est-noise only on selected component
               n = North component
               e = East  component
               u = Up    component

    -noper  = don't estimate annual  period (useful for short time series)
              by default, will estimate annual(365.25 days) and 
              semiannual(182.625 days) periods

    -norate = do not estimate secular rate (by default secular rate is estimated)

    -w      = error is only white noise 
              (by default it will estimate white noise + power law error)

    -off [c/g/cg]   coseismic offsets (no coseismic offset estimated by default)
               c  = 1 offset,  Cook Strait earthquake
               g  = 1 offset,  Lake Grassmere earthquake  offset
               cg = 2 offsets, Cook and Lake Grassmere offset

    -post [c/g/cg]  postseismic decay to be estimated (no decay estimated by default)
               c  = 1 postseismic decay due to Cook      earthquake
               g  = 1 postseismic decay due to Grassmere earthquake
               cg = 2 postseismic decays to be estimated (Cook + Grassmere)

    -exp [e/o/m]  if exponential has to be estimated, choose on between 
               e = 1-exp(-t/tau)    [exponential]     [default]
               o = log10(tau+t)     [logarithmic]
               m = log10(1 + t/tau) [simplified Omori's law]

    -tau val   initial value of the time constant of the exponential function  [default = 1]

    ------------------------------------------------------------------------------------------
    Examples: 
       1) short time series input file from regionally filtered, two offsets, 
          two postseismic exponential decays
          run-est-noise.csh -s cmbl -i filt -off cg -post cg -exp e -nop -norate

       2) long time series input from raw time series, one offset, one postseismic log decay
          run-est-noise.csh -s cmbl -i raw  -off g -post g -exp o
 
End_of_help
exit
endif

echo start `date`

## ----
set k = 1
set p_info = 1
set n_off = 0
set exp = e
set t_info = 0 
set tau = 1
set rate_info = y
set components = "n e u"
set time_format = otr  #could be otr (year-julian day) or otx (year-month-day)
set wn = 1
set reg_info = 0
## ----

while ($k <= $#argv)
 switch ($argv[$k])

  case -i:
   @ k++
   set idir = $argv[$k]
   if ($idir == raw) then
    set input_dir = /geonet/gps/solutions/plotfiles
   else if ($idir == filt ) then
    set input_dir = /geonet/gps/solutions/plotfiles/regional-filtered
    set reg_info = 1
   else if ($idir == local) then
    set input_dir = `pwd`
   else if ($idir != filt && $idir != raw) then
    echo bad digit of input dir , choose between "raw" and "filt"
    exit
   endif
   @ k++
  breaksw

  case -s:
   @ k++
   set site = `echo $argv[$k] | awk '{print toupper($1)}'`
   @ k++
  breaksw

  case -noper:
   @ k++
    set p_info = 0
  breaksw

  case -w:
   @ k++
    set wn = 0
  breaksw

  case -off:
   @ k++
   set n_off = $argv[$k]
   @ k++
  breaksw

  case -comp:
   @ k++
    set components = $argv[$k]
    if ($components != n && $components != e && $components != u) then
     echo "Error: bad digit of -comp option (must be one of [n/e/u])"
     exit
    endif
   @ k++
  breaksw

  case -post:
   @ k++
   set t_info = $argv[$k]
   @ k++
  breaksw

  case -exp:
   @ k++
   set exp = $argv[$k]
   @ k++
  breaksw

  case -norate:
   @ k++
   set rate_info = n
  breaksw

  case -tau:
   @ k++
   set tau = $argv[$k]
   @ k++
  breaksw

  case -out:
   @ k++
   set outfix = $argv[$k]
   @ k++
  breaksw

 endsw
end

###-------------------
###-------------------


### --- earthquakes ---------------------------------------------------------------
# cook 2013-07-21 05:09:30 UTC
set eqd = "2013-07-21"
set eqh = "05 09 30"
set day = `date -u +"%Y %j" -d $eqd`
set hour = `echo $eqh | awk 'BEGIN {FS=":"} {printf"%10.5f\n",($1/24)+($2/1440)+($3/86400)}'`
set cook = `echo $day $hour | awk '{printf"%4i%10.5f\n", $1,($2+$3)}'`
# grassmere  2013-08-16 02:31:05 UTC
set eqd = "2013-08-16"
set eqh = "02 31 05"
set day = `date -u +"%Y %j" -d $eqd`
set hour = `echo $eqh | awk 'BEGIN {FS=":"} {printf"%10.5f\n",($1/24)+($2/1440)+($3/86400)}'`
set grass = `echo $day $hour | awk '{printf"%4i%10.5f\n", $1,($2+$3)}'`
### ---------------------------------------------------------------------------------

set tmp_dir = tmp.$$
mkdir $tmp_dir


foreach comp ($components)
  echo --------------------------------------
  set outname = ${site}_${comp}.out
  if ($?outfix == 1) then
   set outname = ${site}_${comp}.${outfix}.out
  endif
  set in = ${site}_${comp}.input

  ### -------------------------------------------------------------------------------------------------------------
  ##  Create input file from GeoNet CGPS time series (you can choose between Bernese output or regionally filtered)
  ##    check if time series is from regionally filtered or not. If ts is regionally filtered get error value from
  ##    non regionally filtered time series (reg filt does not have associated error)
  if (! -e $in) then
    if ($?idir == 0) then
      echo "Error: must select input dir (-i option)"
      exit
    endif
    set input1 = ${input_dir}/${site}_${comp}.plt
    if ($reg_info == 1) then
      set input2 = /geonet/gps/solutions/plotfiles/${site}_${comp}.plt    #if filtered ts is used, take error value from raw ts
      set tmp2 = tmp2.$$
      tail -n +2 $input2 > $tmp2
    endif
    set tmp1 = tmp1.$$
    echo creating input from $input1
    tail -n +2 $input1 > $tmp1
    foreach time (`cat $tmp1 | awk '{print $1}'`)
      set yeardoy = `date -u +"%Y %j" -d '1970-01-01 '$time' sec'`
      ## if you use regional-filtered tseries error is taken from non-filtered time series
      if ($reg_info == 1) then
        set time1 = `echo $time | awk '{print substr($1,1,5)}'`
        set val = `grep $time  $tmp1 | awk '{print $2}'`
        set err = `grep $time1 $tmp2 | awk '{print $3}'`
        echo $yeardoy $val $err | awk '{printf"%6i%20.9f%12.4f%12.2f\n",$1,$2,$3,$4}' >> $in
      ## if you use "normal" time series (non regionally filtered)
      else if ($reg_info == 0) then
        set val = `grep $time $tmp1 | awk '{print $2,$3}'`
        echo $yeardoy $val | awk '{printf"%6i%20.9f%12.4f%12.2f\n",$1,$2,$3,$4}' >> $in
      endif
    end
  endif
  ### ----------------------------------------------------------------------------------------

  cd tmp.$$
  ln -s ../$in

  echo working on $site - $comp component

  ### -----------------------------------------------------
  ###  Prepare input file for est_noise6ac 
   ## -- intervallo dati
   set ymin = `head -1 $in | awk '{print $1}'`
   set dmin = `head -1 $in | awk '{print $2}'`
   set ymax = `tail -1 $in | awk '{print $1}'`
   set dmax = `tail -1 $in | awk '{print $2}'`

   echo $time_format            >  junk.in            ## data format (year - julian day)
   echo 1                       >> junk.in            ## number of time series
   echo $ymin $dmin $ymax $dmax >> junk.in            ## tseries time interval (start-end)
   echo $rate_info              >> junk.in            ## estimate secular rate
   echo 0                       >> junk.in            ## number of rate change (if > 0 provide other parameters)
   if ($p_info == 1) then
    echo 2                      >> junk.in            ## number of periods 
    echo 365.25                 >> junk.in            ## period in days of period n.1
    echo 182.625                >> junk.in            ## period in days of period n.2
   else if ($p_info == 0) then
    echo 0                      >> junk.in
   endif

   ### coseismic offsets to be estimated earthquakes
   if ($n_off == 0) then
    echo 0                      >> junk.in
   else if ($n_off == c) then
    echo 1                       >> junk.in            ## number of offsets
    echo $cook                   >> junk.in
   else if ($n_off == g) then
    echo 1                       >> junk.in            ## number of offsets
    echo $grass                  >> junk.in
   else if ($n_off == cg) then
    echo 2                       >> junk.in            ## number of offsets
    echo $cook                   >> junk.in
    echo $grass                  >> junk.in
   else if ($n_off != 0 || $n_off != c || $n_off != g || $n_off != cg) then
    echo "Error: bad digit of coseismic offset choice (-off option)"
    exit
   endif
  
   ## exponential decay to be estimated
   if ($t_info == 0 ) then
    echo 0                      >> junk.in
   else if ($t_info == c) then
    echo 1                      >> junk.in
    echo $cook                  >> junk.in                    ## time of exponential due to 2013 Cook earthquake
    echo $tau float             >> junk.in                    ## time constant in year (float = estimate)
    echo $exp                   >> junk.in                    ## type of exp function (choose between  e = exponential o = log  m = Omori )
   else if ($t_info == g) then
    echo 1                      >> junk.in
    echo $grass                 >> junk.in                    ## time of exponential due to 2013 Cook earthquake
    echo $tau float             >> junk.in                    ## time constant in year (float = estimate)
    echo $exp                   >> junk.in                    ## type of exp function (choose between  e = exponential o = log  m = Omori )
   else if ($t_info == cg) then
    echo 2                      >> junk.in
    echo $cook                  >> junk.in                    ## time of exponential due to 2013 Cook earthquake
    echo $tau float             >> junk.in                    ## time constant in year (float = estimate)
    echo $exp                   >> junk.in                    ## type of exp function (choose between  e = exponential o = log  m = Omori )
    echo $grass                 >> junk.in                    ## time of exponential due to 2013 Cook earthquake
    echo $tau float             >> junk.in                    ## time constant in year (float = estimate)
    echo $exp                   >> junk.in                    ## type of exp function (choose between  e = exponential o = log  m = Omori )
   else if ($t_info != 0 || $t_info != c || $t_info != g || $t_info != cg) then
    echo "Error: bad digit of postseismic decay choice (-post option)"
    exit
   endif

   echo $time_format            >> junk.in
   echo $in                     >> junk.in
   echo 0                       >> junk.in                        ## pressure auxiliary data (normally set to 0)
   echo 1                       >> junk.in                        ## minumum samplig interval in days  (ok 1 also for epoch-by epoch)
   echo n                       >> junk.in                        ## Do you want to get rid of "redundent" data? y/n
   echo n                       >> junk.in                        ## Do you want to substitute real data with random numbers? y/n
   echo 0                       >> junk.in                        ## decimation (choose between 0-4)
  
   ## -- white noise error
   echo 10 float                >> junk.in                        ## white noise instrument precision (float = estimate)
   ## -- power law error
   if ($wn == 1) then
    echo 10 float                >> junk.in                       ## amplitude first Power law function and fix/float
    echo 1  float                >> junk.in                       ## exponent 1 < n < 3 and fix/float - power law index (1=flicker 2=random walk) 
   else if ($wn == 0) then
    echo 1  fix                  >> junk.in                       ## amplitude first Power law function and fix/float
    echo 0  fix                  >> junk.in                       ## exponent 1 < n < 3 and fix/float - power law index (1=flicker 2=random walk) 
   endif
   ## -- other errors
   echo 0 fix                   >> junk.in                        ## Gauss-Markov
   echo 0.5 2.0                 >> junk.in                        ## pass band filter bound (cycles/year)
   echo 1                       >> junk.in                        ## number of poles
   echo 0 fix                   >> junk.in                        ## amplitude of BP noise
   echo 2 fix                   >> junk.in                        ## second power law index
   echo 0 fix                   >> junk.in                        ## second power law amplitude
   echo 0                       >> junk.in                        ## white noise to be added

   rm -f seed.dat
   echo 82789427 > seed.dat

   echo est-noise on $in - see ${outname}.log for details
   time est_noise6ac < junk.in > ${outname}.log

  cat resid.out | awk '{printf"%12.5f%10.2f%10.2f%10.2f\n",($1+($2/365.25)),$3,$4,$5}' > ${outname}
  mv ${outname}.log ../.
  mv ${outname} ../.

  echo est_noise run finished, files created are
  echo "  " $outname
  echo "  " ${outname}.log

cd ..
end

rm -fr $tmp_dir
rm *.$$
echo end `date`

