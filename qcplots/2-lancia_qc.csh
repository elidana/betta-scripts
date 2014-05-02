#! /bin/csh -f

foreach file (rnx/????????.??o)
 set n = `echo $file:t | cut -c 5-7`
 set y = `echo $file:t | cut -c 10-11`
 if (! -e nav/auto${n}0.${y}n ) then
  get_navig $n $n $y
  gunzip auto${n}0.${y}n.Z
  mv auto${n}0.${y}n nav/.
 endif
 teqc +qc -R -nav nav/auto${n}0.${y}n $file 
end


mv rnx/????????.??S sum/.
#mv rnx/????????.??S sum_network/.

echo ""
echo ""
echo " DAJE, che i qc so pronti"
echo " cancella i rinex copiati qui"
