#! /bin/csh -f


if ($#argv < 1) then
 echo ""
 echo "   fitplot.csh site "
 echo ""
 exit
endif


set s   = `echo $1 | awk '{print toupper($1)}'`
set net = `echo $2 | awk '{print toupper($1)}'`


set address = https://fits.geonet.org.nz/observation

### ---
set tmpdir = tmpdir.$$
mkdir $tmpdir
cd $tmpdir

curl -o tmp.$$ ${address}'?siteID='${s}'&typeID=u'
tail -300 tmp.$$ | cut -c 1-10,25-50 | sed -e 's/,/ /g' > tmp1.$$
awk '{print $1,($2-a),$3}' tmp1.$$ > ${s}.u

## values for antenna swap
set c = `sort -nk 3 ${s}.u | awk '{print $3}' | tail -1`  ## max error
set a = `sort -nk 2 ${s}.u | head -1 | awk -v a=$c '{print $2-a}'`  ## min du+ err
set b = `sort -nk 2 ${s}.u | tail -1 | awk -v a=$c '{print $2+a}'`  ## max du+ err
set t = `grep $s /home/elidana/git/delta/install/antennas.csv | grep -F "TRM115000.00" | cut -d , -f 9 | head -1 | cut -d T -f 1`
echo $t

## calculate average 20 days before/after antenna swap
set lt11 = `sed -n '/'${t}'/=' ${s}.u | awk '{print $1-21}'`
set lt12 = `sed -n '/'${t}'/=' ${s}.u | awk '{print $1-1}'`
set lt21 = `sed -n '/'${t}'/=' ${s}.u | awk '{print $1+1}'`
set lt22 = `sed -n '/'${t}'/=' ${s}.u | awk '{print $1+21}'`

sed -n ''${lt11}','${lt12}'p' ${s}.u | awk '{print $2}' > ${s}.pre
sed -n ''${lt21}','${lt22}'p' ${s}.u | awk '{print $2}' > ${s}.post


### Plot

cat << EOF > ${s}.swap
$t $a
$t $b
EOF


cat << EOF > plot.$$
stats '${s}.pre' prefix 'PRE'
stats '${s}.post' prefix 'POST'
print PRE_mean
set title "$s"
set xlabel "time"
set ylabel "displacement (mm)"
set xdata time
set bars small
set timefmt "%Y-%m-%d"
plot '${s}.u' using 1:2:3 with errorbars title 'Up', '${s}.swap' using 1:2 with lines title 'antenna swap' linetype 5 lw 5, PRE_mean lw 2, POST_mean lw 2
pause -1 "Hit return to continue"
EOF


gnuplot plot.$$

cd ..
#rm -fr tmpdir.$$


