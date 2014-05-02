#! /bin/csh -f

set out  = geonet.lonlat
set out1 = linz.lonlat
set out2 = geonet.list


set xml  = tmp1.$$
set xml1 = tmp2.$$

## exctract coord file for ACTIVE geonet site from Delta WFS
curl -o $xml  http://magma.geonet.org.nz/ws-delta/site'?type=cgps&status=Operational'
curl -o $xml1 http://magma.geonet.org.nz/ws-delta/site'?type=cgps&status=Operational&networkName=LI'

## exctract coord file for ALL geonet site from Delta WFS
#curl -o $xml http://magma.geonet.org.nz/ws-delta/site'?type=cgps'


### extract only site name
grep "mark code" $xml | awk '{print $2}' | sed -e 's/code="//' -e 's/"//' | awk '{print tolower($1)}' | sort > $out2

### extract lon, lat, name 
grep "mark code" $xml  | awk 'BEGIN {FS="="} {print $5,$4,$2}' | sed -e 's/"//g' -e 's/opened//' -e 's/lon//' -e's/name//' \
 | awk '{printf"%15.5f%15.5f%10s\n",$1,$2,tolower($3)}' | sort -k3 > $out

grep "mark code" $xml1 | awk 'BEGIN {FS="="} {print $5,$4,$2}' | sed -e 's/"//g' -e 's/opened//' -e 's/lon//' -e's/name//' \
 | awk '{printf"%15.5f%15.5f%10s\n",$1,$2,tolower($3)}' | sort -k3 > $out1


rm *.$$

echo ""
echo ""
echo -------------------------
echo created $out and $out1 
echo "(and " $out2 ", only site names)"
exit


goto METODOKO
#### from sites info dir, non usato piu
set infodir = /home/elidana/sites
set linz = linz.list
foreach file (${infodir}/????.xml)
  set sta  = `echo $file:t:r`
  set lat  = `grep latitude  ${infodir}/${sta}.xml | sed -e 's:<latitude>::' -e 's:</latitude>::'`
  set lon  = `grep longitude ${infodir}/${sta}.xml | sed -e 's:<longitude>::' -e 's:</longitude>::'`
  set elev = `grep -F "<height>" ${infodir}/${sta}.xml | sed -e 's:<height>::' -e 's:</height>::'`
  echo $lon $lat $sta | awk '{printf"%15.5f%15.5f%10s\n",$1,$2,$3}' >> tmp.$$
  #echo $lon $lat $elev $sta | awk '{printf"%15.5f%15.5f%15.5f%10s\n",$1,$2,$3,$4}' >> tmp.$$
end
mv tmp.$$ $out
grep -f $linz $out > $out1
echo created $out and $out1
METODOKO:


