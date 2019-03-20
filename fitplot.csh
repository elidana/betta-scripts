#! /bin/csh -f


if ($#argv < 1) then
 echo ""
 echo "   fitplot.csh site "
 echo ""
 exit
endif


set s   = `echo $1 | awk '{print toupper($1)}'`
set net = `echo $2 | awk '{print toupper($1)}'`


set address = http://fits.geonet.org.nz/observation

### ---
set tmpdir = tmpdir.$$
mkdir $tmpdir
cd $tmpdir

foreach comp (e n u)
  curl -o tmp.$$ ${address}'?siteID='${s}'&typeID='${comp} 
  tail -n+2 tmp.$$ | cut -c 1-10,25-50 | sed -e 's/,/ /g' > tmp1.$$
  set off = `head -1 tmp1.$$ | awk '{print $2}'`
  awk -v a=$off '{print $1,($2-a),$3}' tmp1.$$ > ${s}.${comp}
end

#set format x "%Y/%m"

cat << EOF > plot.$$
set title "$s"
set xlabel "time"
set ylabel "displ (mm)"
set xdata time
set timefmt "%Y-%m-%d"
plot '${s}.u' using 1:2:3 with errorbars title 'Up', '${s}.n' using 1:2:3 with errorbars title 'N', '${s}.e' using 1:2:3 with errorbars title 'E'
pause -1 "Hit return to continue"
EOF


gnuplot plot.$$

cd ..
rm -fr tmpdir.$$


