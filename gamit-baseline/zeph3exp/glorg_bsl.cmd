* Glorg command file for short baseline processing
    
* Parameters to be estimated                                             
 pos_org  xtran ytran ztran

* Downweight of height relative to horizontal (default is 10)
#   Heavy downweight if reference frame robust and heights suspect
x  cnd_hgt  1000    
  cnd_hgtv 10 10 4 4
 
* Controls for removing sites from the stabilization 
#   Vary these to make the stabilization more robust or more precise                                             
x stab_it 4 0.8 3.0
 stab_it 4 0.5 4.0                                      
   
* A priori coordinates
#  ITRF2008 may be replaced by an apr file from a priori velocity solution         
  apr_file ../tables/zephyr3test.apr

  apr_neu all 20 20 20 0 0 0
  apr_neu 1REF F F F 0 0 0
  apr_neu AVLN F F F 0 0 0
x  apr_neu AVLN 0.001 0.001 0.01 0 0 0
 
* List of stabilization sites
#   This should match the well-determined sites in the apr_file
x  use_site clear
x  use_site 1ref avln

