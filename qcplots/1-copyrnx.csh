#! /bin/csh -f

if ($#argv == 0) then
cat << END

   1-copyrnx.csh   site   year

END
exit
endif

set s = $1
set yy = $2

echo dehatanako dentro rnx

cd rnx

crz2rnx -c /geonet/gps/rinex/$yy/0??/${s}????.??d.Z
#crz2rnx -c /geonet/gps/rinex/$yy/1??/${s}????.??d.Z
#crz2rnx -c /geonet/gps/rinex/$yy/2??/${s}????.??d.Z

##foreach s (auck quar kara)
## echo $s ---
## cp /geonet/gps/rinex/$yy/0??/${s}*d.Z rnx/.
## cp /geonet/gps/rinex/$yy/1??/${s}*d.Z rnx/.
## cp /geonet/gps/rinex/$yy/2??/${s}*d.Z rnx/.
## cp /geonet/gps/rinex/$yy/3??/${s}*d.Z rnx/.
##end

echo "DAJE, che i rinex so pronti"
