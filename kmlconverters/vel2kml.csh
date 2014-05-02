#! /bin/csh -f

## Betta settembre 2012
##  plotta velocita in gugolart

if ($#argv == 0) then
 echo vel2kml file_vel
 exit
endif

set in  = $1

set excl = exclude.sta
set out = ${in}.kml

set tmp1 = tmp1.$$

cat <<END > $out
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
END

foreach s ( `cat $in | egrep -vf $excl | awk '{print $8}'` )
 set xy = `grep $s $in | awk 'BEGIN {OFS=","}{print $1,$2}'`
 set y  = `grep $s $in | awk '{if ($9 >= 2.5) print 1; else print 0}'`
 set n  = `grep $s $in | awk '{print $4}'`
 set e  = `grep $s $in | awk '{print $3}'`
 if ($y == 1) then
  echo $e $n > input
  ./frecce-gugolart.m
  set size = `cat output | awk '{print $1/4}'`
  set rot  = `cat output | awk '{print $2}'`
#  echo $xy $size $rot $s $y | awk '{if ($6 >= 2.5) printf "%10.5f%10.5f%10.2f%10.2f%8s%9.2f\n",$1,$2,$3,$4,$5,$6}' >> $tmp1

  # placemark gugolart
cat <<END >> $out
    <Style id="${s}">
    <IconStyle>
     <color> ff66ffcc</color>
     <scale>${size}</scale>
     <heading>${rot}</heading>
     <Icon>
       <href>http://maps.google.com/mapfiles/kml/shapes/arrow.png</href>
     </Icon>
    </IconStyle>
  </Style>
  <Placemark>
    <description> ${s} </description>
    <styleUrl> ${s}</styleUrl>
    <Point>
      <coordinates>${xy},0</coordinates>
    </Point>
  </Placemark>
END


### tolto il nome, se si vuole rimettere aggiungere nella riga dopo <Placemark>
##    <name>${s}</name>

 endif
end

cat <<END >> $out
</Document>
</kml>
END

#mv $tmp1 ${out}.tabella



