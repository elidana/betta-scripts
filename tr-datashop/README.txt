These scripts are to order automatically rinex data from Trimble server

##########################################################################
### --- add a new station

   station list to be downloaded are listed in the $postati3 file
   if you want to add/change stations to be downloaded, modify the file
     > post-files/station_selection.post
   adding a row for the desired station

##########################################################################
### --- manual download a day

   to download a specific day, edit the file todownload.list
   with year, month and day of month to be downloaded 

   Ex.: to download doy 304 of 2013:
     a. on the command line type
        $> jday 304 2013
        and you get the mmddyyyy (10312013)
     b. edit todownload.list adding
        $> vi todownload.list
        insert a row with:   2013 10 31
     c. on the command line
        $> ./rinex_shop.csh
     d. wait until the order is complete (you may check on Trimble website)
     e. When the file creation is complete (wait 10 min at least) on 
        the command line type:
        $> ./rinex_download.csh
