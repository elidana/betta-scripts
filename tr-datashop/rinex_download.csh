#! /bin/csh -f


#### -----------------------------------------------------------------------
####
#### Eli Dana , July 2013
####
#### script to order automatically rinex data from Trimble server
#### station list to be downloaded are listed in the $postati3 file
#### if you want to add/change stations to be downloaded, modify this file
####
#### -----------------------------------------------------------------------

setenv PATH $HOME/bin:/usr/local/gmt/GMT4.5.5/bin:$PATH

set bindir = /home/elidana/sbin/geosystem
set outdir = /home/elidana/work/geosystem_rnx-download


### --- login info

set address = http://www.vrs.net.nz

set org = GNS
set user = nevillep
set pass = gnsscience

set infile = ${bindir}/geosystem.station.list

### --- local files
set postati1 = ${bindir}/post-files/login.post
set postati2 = ${bindir}/post-files/download1.post
set postati3 = ${bindir}/post-files/download2.post

set orderlist = ${bindir}/order.list

cp $orderlist ${orderlist}.old

set orderid = `head -1 $orderlist`

cd $outdir

### --- temporary variables
set cookie  = cookie1.txt


### -- LOGIN
curl -c cookie0.txt -o login1.aspx ${address}/Login.aspx

#set view = `grep VIEWSTATE login1.aspx | sed -e 's:<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="::' -e 's:" />::' | sed -e 's:/:%2F:' -e 's:+:%2B:' -e 's:=:%3D:' -e 's:?:%3F:'`
#set event = `grep EVENTVALIDATION login1.aspx | sed -e 's:<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="::' -e 's:" />::' | sed -e 's:/:%2F:' -e 's:+:%2B:' -e 's:=:%3D:' -e 's:?:%3F:'`

cat $postati1 > postati1.$$

cat << END >> postati1.$$
&ctl00%24ContentPlaceHolder1%24m_Login%24Organization=${org}
&ctl00%24ContentPlaceHolder1%24m_Login%24UserName=${user}
&ctl00%24ContentPlaceHolder1%24m_Login%24Password=${pass}
&ctl00%24ContentPlaceHolder1%24m_Login%24LoginButton=Login
&uDate=-720
END


curl -c $cookie -o login2.aspx \
  --data @postati1.$$ \
  --referer ${address}/Login.aspx --location \
  ${address}/Login.aspx


### --- Go to Reference Data Shop

curl -b $cookie -o shop1.aspx \
  --referer ${address}/default.aspx \
  ${address}/MemberPages/RefDataShop/Overview.aspx

curl -b $cookie -o overview1.aspx \
  --referer ${address}/MemberPages/RefDataShop/Overview.aspx \
  --location \
  -d @$postati2 \
  ${address}/MemberPages/RefDataShop/Overview.aspx 


### --- Get the overview order page

curl -b $cookie -o order1.aspx \
  --referer ${address}/MemberPages/RefDataShop/Overview.aspx \
  ${address}/MemberPages/RefDataShop/Order.aspx'?OrderID='$orderid

curl -b $cookie -o order.zip \
  --referer ${address}/MemberPages/RefDataShop/Order.aspx'?OrderID='$orderid \
  -d @$postati3 \
  ${address}/MemberPages/RefDataShop/Order.aspx'?OrderID='$orderid

 
sed -e /$orderid/d $orderlist > tmp.$$
mv tmp.$$ $orderlist

### -----------------------------------------------------------------------------
### create rinex files
### -----------------------------------------------------------------------------

 unzip order.zip
 rm order.zip

 foreach file (????????.??o)
  set s1 = `echo $file | cut -c 1-4`
  set s = `grep $s1 $infile | awk '{print tolower($2)}'`
  set S = `grep $s1 $infile | awk '{print $2}'`
  set d = `echo $file | cut -c 5-7`
  set y = `echo $file | cut -c 10-11`
  echo working on $file to extract ${s}${d}0.${y}d.Z
  teqc -O.mo $S $file > ${s}${d}0.${y}o
  rnx2crz -d -f ${s}${d}0.${y}o
  rm ${file:r}.txt ${file:r}.${y}g ${file:r}.${y}n  ${file:r}.${y}o
 end


rm *.$$ *.aspx cookie?.txt
