#! /bin/csh -f


if ($#argv < 1) then
 echo "trackplot.csh file"
 exit
endif


set file = $1


### ---
set tmpdir = tmpdir.$$
set input = input.$$
mkdir $tmpdir
tail -n +3 $file | awk '{printf "%04i-%02i-%02iT%02i:%02i:%5.3f %10.2f %10.2f %10.2f %10.2f %10.2f\n",$1,$2,$3,$4,$5,$6,$7,$9,$11,$8,$10,$12,$15,$16}' > ${tmpdir}/${input}
cd $tmpdir

cat << EOF > plot.$$
set title "$file"
set xlabel "time (hh:mm)"
set ylabel "displ (mm)"
set xdata time
set timefmt "%Y-%m-%dT%H:%M:%S"
plot '$input' using 1:4 title 'Up' lt 3, '$input' using 1:2 title 'N' lt 1, '$input' using 1:3 title 'E' lt 2
pause -1 "Hit return to continue"
plot '$input' using 1:4 title 'Up' lt 3 with lines, '$input' using 1:2 title 'N' lt 1 with lines, '$input' using 1:3 title 'E' lt 2 with lines
pause -1 "Hit return to continue"
plot '$input' using 1:2 title 'N' lt 1
pause -1 "Hit return to continue"
plot '$input' using 1:3 title 'E' lt 1
pause -1 "Hit return to continue"
plot '$input' using 1:5:6 title 'Atm' lt 4
pause -1 "Hit return to continue"
EOF



gnuplot plot.$$

cd ..
rm -fr tmpdir.$$


