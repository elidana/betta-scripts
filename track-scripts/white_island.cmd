* template TRACK command file for 10Hz data
* run with
*    $> track -f track.cmd -d doy -w week

 
 obs_file
   whkt rinex/whktDDD0.YYo F
   trng rinex/trngDDD0.YYo K
   hikb rinex/hikbDDD0.YYo K
   rgwc rinex/rgwcDDD0.YYo K
   rgwi rinex/rgwiDDD0.YYo K


 nav_file orbits/igrWWWW.sp3 sp3

 pos_root wi-DDD
 sum_file wi-DDD

* Apriori coordinates file from xl doc included in grad v package
 site_pos        
  whkt -5027028.54805 262234.33264 -3903984.18383
  trng -5040272.64207 329395.90134 -3881772.77754
  hikb -5060143.56362 149885.08015 -3867001.82349
  rgwc -5058709.93868 248077.99121 -3863729.10381
  rgwi -5059271.45849 249406.91888 -3863333.33933

 out_type DHU

##stats all 0 for additional fixed sites
 site_stats
   all   10.0 10.0 10.0 1 1 1 
   whkt  0.0 0.0 0.0 0.0 0.0 0.0
   trng  0.0 0.0 0.0 0.0 0.0 0.0
   hikb  0.0 0.0 0.0 0.0 0.0 0.0

 atm_stats
   all   0.20 0.00010 0.000   ! Unit m/sqrt(sec) -> 0.0001 = 0.03 m/sqrt(day)


 ante_off
    whkt 0.0000 0.0000 0.0020 TRM115000.00 NONE C
    trng 0.0000 0.0000 0.0550 TRM115000.00 NONE C
    hikb 0.0000 0.0000 0.0550 TRM115000.00 NONE C
    rgwi 0.0000 0.0000 0.0020 TRM57971.00  NONE C
    rgwc 0.0000 0.0000 0.0020 TRM57971.00  NONE C

 interval 30

 time_unit sec

 dcb_file ~/gg/tables/dcb.dat.gps

 antmod ~/gg/tables/antmod.dat

 mode long
 back smooth
 rms_edit 10.0
 bf_set 10
 float 1 1 LC    0.15 2.5 1.0 0.01 25 10
 DATA_TYPE LC
 min_tols 0.01 2000
 cut_off 10
 
xtype start dec type flsig WL_f Ion_f Max_fit rel
x float 1     1   LC   0.15 2.5  1.0   0.01    25 10
x FLOAT_TYPE 1 4 LC 0.15  2.5  0.1   0.01    25 10
 
