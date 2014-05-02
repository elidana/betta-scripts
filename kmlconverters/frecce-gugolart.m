#! /usr/bin/octave -qf
### 
### calcola size e rotation per plottare frecce con ArcGis
###  Betta 10/10/2011
###
# ve = east  velocity (mm/yr)
# vn = north velocity (mm/yr)

A = load input;
ve = A(1);
vn = A(2);

filename = "output";
fid = fopen (filename, "w");

vx = sqrt ((ve*ve)+(vn*vn));

 if ( ve>=0 & vn>=0 )
  r = asin(ve/vx)*(360/pi);
 elseif ( ve>=0 & vn<0 )
  r = (90+(90-(asin(ve/vx)*(360/pi))));
 elseif ( ve<0 & vn<0 )
  r = (180-(asin(ve/vx)*(360/pi)));
 else ( ve<0 & vn>=0 )
  r = (360+(asin(ve/vx)*(360/pi)));
 endif

 if ( r<=180 )
  r1 = r+180
 elseif ( r>180 )
  r1 = r-180
 endif

fprintf (fid,"%9.3f%9.3f\n",vx,r1);

fclose (fid);
