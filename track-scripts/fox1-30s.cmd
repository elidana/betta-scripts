* template TRACK command file for 10Hz data
* run with
*    $> track -f track.cmd -d doy -w week

 
 obs_file
   waka rinex/wakaDDD0.YYo F
   fox1 rinex/fox1DDD0.YYo K

 nav_file orbits/igrWWWW.sp3 sp3

 pos_root fox1-DDD
 sum_file fox1-DDD

* Apriori coordinates file from xl doc included in grad v package
 site_pos        
   vexa -4552669.37655 811510.67413 -4380078.33981
x   fox1 -4563712.69930 800675.36210 -4370315.56072 
   fox1 -4563712.50381   800673.73077 -4370320.00321
   waka -4556546.49920 812850.11341 -4375701.03569

 out_type DHU

##stats all 0 for additional fixed sites
 site_stats
   all   10.0 10.0 10.0 1 1 1 
   waka  0.0 0.0 0.0 0.0 0.0 0.0
x   ktia  0.0 0.0 0.0 0.0 0.0 0.0
x   wark  0.0 0.0 0.0 0.0 0.0 0.0

 atm_stats
   all   0.20 0.00010 0.000   ! Unit m/sqrt(sec) -> 0.0001 = 0.03 m/sqrt(day)
   VEXA  0.00 0.00000 0.000
   WAKA  0.00 0.00000 0.000


 ante_off
    vexa 0.0000 0.0000 0.0550 TRM115000.00 NONE C
    waka 0.0000 0.0000 0.0550 TRM115000.00 NONE C
    fox1 0.0000 0.0000 0.0000 TRM115000.00 NONE C

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
 
