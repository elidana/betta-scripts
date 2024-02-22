#! /bin/csh -f

#### prepare and plot files for comparison  (all transformed to cm)

if ($#argv < 1) then
	 echo "unireno....csh site "
	  exit
  endif


set sta = `echo $1 | awk '{print toupper($1)}'`


set address = http://fits.geonet.org.nz/observation
set b = "siteID=${sta}"

if (! -e gamit.${sta}.n) then
    foreach comp (e n u)
      curl -o tmp.$$ ${address}'?&'${b}'&typeID='${comp}
      tail -n+2 tmp.$$ | cut -c 1-10,25-50 | sed -e 's/,/ /g' > tmp1.$$
      set off = `grep 2016 tmp1.$$ | head -1 | awk '{print $2}'`
      echo $off
      awk -v a=$off '{print $1,($2-a),$3}' tmp1.$$ > gamit.${sta}.${comp}
    end
endif


## - Gipsy from UniNevada (measure unit = m)
set file = ${sta}.tenv3
set ftp = http://geodesy.unr.edu/gps_timeseries/tenv3/IGS14
if (! -e gipsy/${sta}.neu) then
  curl -O $ftp/$file
  set off = `tail -n +2 $file | awk '{if ($3 >= 2016) print $0}' | head -1 | awk '{print $11,$9,$13}'`
  foreach epoch (`tail -n +2 $file | awk '{print $2}'`)
    set date = `echo $epoch | awk '{print substr($1,6,2),substr($1,3,3),substr($1,1,2)}'`
    set date1 = `date +%Y-%m-%d -d ${date[1]}${date[2]}${date[3]}`
    set therest = `grep $epoch $file | awk -v a=$off[1] -v b=$off[2] -v c=$off[3] '{print ($11-a)*1000,$16*1000,($9-b)*1000,$15*1000,($13-c)*1000,$17*1000}'`
    echo $date1 $therest >> tmp2.$$
  end
  mv tmp2.$$ gipsy.${sta}.neu
  rm $file
endif


cat << EOF > plot.$$
set xdata time
set xlabel "time"
set ylabel "displacement (mm)"
set timefmt "%Y-%m-%d"
set title "${sta} North"
plot 'gipsy.${sta}.neu' using 1:2 title 'UniReno', 'gamit.${sta}.n' using 1:2 title 'GeoNet'
pause -1 "Hit return to continue"
set title "${sta} East"
plot 'gipsy.${sta}.neu' using 1:4 title 'UniReno', 'gamit.${sta}.e' using 1:2 title 'GeoNet'
pause -1 "Hit return to continue"
set title "${sta} Up"
plot 'gipsy.${sta}.neu' using 1:6 title 'UniReno', 'gamit.${sta}.u' using 1:2 title 'GeoNet'
pause -1 "Hit return to continue"
EOF

gnuplot plot.$$


rm *.$$
