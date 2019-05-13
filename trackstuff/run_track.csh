#! /bin/bash

if [ "$#" -eq 0 ] ; then
  echo ./run_track.sh year doy
  exit
fi

cmd=cmd.$$

y=$1
yy=`echo $y | cut -c 3-4`
d=`echo $2 | awk '{printf"%03d\n",$1}'`

w=`doy $1 $2 | grep "GPS Week" | awk '{print $3}' | sed -e 's/,//'`
wd=`doy $1 $2 | grep "GPS Week" | awk '{print $3$7}' | sed -e 's/,//'`

ftporb=ftp://cddis.nasa.gov/gnss/products/$w
ftprnx=ftp://ftp.geonet.org.nz/gnss/rinex/$y/$d


if [ ! -e orbits/igr${wd}.sp3 ] ; then
  curl -O ${ftporb}/igr${wd}.sp3.Z
  gunzip igr${wd}.sp3.Z
  mv igr${wd}.sp3 orbits/.
fi


cat track-30s.cmd | sed -e 's/DDD/'${d}'/g' -e 's/YY/'${yy}'/g' -e 's/WWWW/'${wd}'/g' > $cmd

track -f $cmd > fox1-${d}.log

rm *.$$

  
