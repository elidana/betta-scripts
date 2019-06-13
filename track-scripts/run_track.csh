#! /bin/bash

if [ "$#" -eq 0 ] ; then
cat << ENDHELP

   ./run_track.sh  track.cmd  year   doy 
  

   first download rinex and save in rinex directory :
   aws s3 sync --profile prod_archiveread s3://geonet-archive/gnss/rinex/2019/ . --exclude "*" --include "1[1-3]?/waka*"

ENDHELP
  exit
fi

cmd=cmd.$$

y=$2
yy=`echo $y | cut -c 3-4`
d=`echo $3 | awk '{printf"%03d\n",$1}'`

w=`doy $2 $3 | grep "GPS Week" | awk '{print $3}' | sed -e 's/,//'`
wd=`doy $2 $3 | grep "GPS Week" | awk '{print $3$7}' | sed -e 's/,//'`

ftporb=ftp://cddis.nasa.gov/gnss/products/$w
ftprnx=ftp://ftp.geonet.org.nz/gnss/rinex/$y/$d

if [ ! -d orbits ] ; then mkdir orbits ; fi
if [ ! -e orbits/igr${wd}.sp3 ] ; then
  curl -O ${ftporb}/igr${wd}.sp3.Z
  gunzip igr${wd}.sp3.Z
  mv igr${wd}.sp3 orbits/.
fi



cat $1 | sed -e 's/DDD/'${d}'/g' -e 's/YY/'${yy}'/g' -e 's/WWWW/'${wd}'/g' > $cmd

track -f $cmd > fox1-${d}.log

rm *.$$

  
