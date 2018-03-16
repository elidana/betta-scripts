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
                                       
 apr_wob .25 .25 .1 .1 
 del_scra yes
 apr_svs all 0.1 0.1 0.1 0.01 0.01 0.01 F F F F F F F F F

 apr_neu   all  20 20 20 0 0 0
