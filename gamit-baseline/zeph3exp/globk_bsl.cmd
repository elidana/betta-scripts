* GLOBK command file to generate daily time from the baseline experiment
            
* This group of commands must appear before any others:                                                       
 srt_file @.srt 
 srt_dir +1

* ITRF2008 augmented by now-defunct sites and recent IGS solutions;
# matched to itrf08_comb.eq 
 apr_file ../tables/zephyr3test.apr
 
* Invoke glorg
 org_cmd glorg_bsl.cmd

* Print file options    
 crt_opt NOPR
 prt_opt NOPR
 org_opt PSUM CMDS BLEN GEOD PSUM
                                       
* For local or regional analysis with lack of good reference sites
 apr_svs all 0.1 0.1 0.1 0.01 0.01 0.01 F F F F F F F F F
 apr_wob .25 .25 .1 .1 
 apr_ut1 .25 .1
 mar_wob 22.8 22.8 3.65 3.65
 mar_ut1 22.8 3.65
 del_scra yes

 use_site clear
 use_site avln avl2 avl3 avl4 avl5

 apr_neu   all  20 20 20 0 0 0
 apr_neu   AVL5 F F F 0 0 0

x apr_neu AVLN F F F 0 0 0
x apr_neu 1REF F F F 0 0 0
x apr_neu AVLN 0.001 0.001 0.01 0 0 0
