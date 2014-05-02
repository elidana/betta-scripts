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


set bindir = /home/elidana/sbin/geosystem
set outdir = /home/elidana/work/geosystem_rnx-download

set address = http://www.vrs.net.nz

set org = GNS
set user = nevillep
set pass = gnsscience

set orderlist = ${bindir}/order.list

set todo = ${bindir}/todownload.list

set postati1 = ${bindir}/post-files/login.post
set postati3 = ${bindir}/post-files/station_selection.post
set postati4 = ${bindir}/post-files/time_selection.post
set postati5 = ${bindir}/post-files/order_submit1.post
set postati6 = ${bindir}/post-files/order_submit2.post

cd $outdir 

### -- date and time of data to be downloaded (yesterday)
set year   = `date -u +%Y`
set month  = `date -u +%m`
set day    = `date -u +%d | awk '{printf"%02s\n",($1-1)}'`

if (! -z $todo) then
 set month = `head -1 $todo | awk '{print $1}'`
 set day   = `head -1 $todo | awk '{print $2}'`
 echo creating order for $year/$month/$day
 tail -n +2 $todo > tmp1.$$
 mv tmp1.$$ $todo
endif

set month1 = `echo $month | awk '{print int($1)}'`
set day1   = `echo $day   | awk '{print int($1)}'`


set stalist = tmp.$$
set cookie  = cookie1.txt
set ordtmp  = order.$$

#echo Picton   > $stalist
#echo Tawa     >> $stalist
#echo Waikanae >> $stalist


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

set view = `grep VIEWSTATE shop1.aspx | sed -e 's:<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="::' -e 's:" />::' | sed -e 's:/:%2F:' -e 's:+:%2B:' -e 's:=:%3D:' -e 's:?:%3F:'`
set event = `grep EVENTVALIDATION shop1.aspx | sed -e 's:<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value="::' -e 's:" />::' | sed -e 's:/:%2F:' -e 's:+:%2B:' -e 's:=:%3D:' -e 's:?:%3F:'`

cat << END > postati2.$$
m_NavigationTreeView_ExpandState=ennnennnennnnnnn
&m_NavigationTreeView_SelectedNode=m_NavigationTreeViewt7
&__EVENTTARGET=
&__EVENTARGUMENT=
&m_NavigationTreeView_PopulateLog=
&__LASTFOCUS=
&__VIEWSTATE=${view}
&__EVENTVALIDATION=${event}
&ctl00%24m_HiddenFieldPageGuid=3ffb3797-071d-7b2d-fa85-b832c828d60a
&ctl00%24ContentPlaceHolder1%24m_BtnNewOrder=Start+new+order
&ctl00%24ContentPlaceHolder1%24m_DdlDownloaded=NotDownloaded
END

curl -b $cookie -o overview1.aspx \
  --data @postati2.$$ \
  --referer ${address}/MemberPages/RefDataShop/Overview.aspx --location \
  ${address}/MemberPages/RefDataShop/Overview.aspx


### --- Select Station Type
###     due to very long VIEWSTATE and EVENTVALIDATION values, in this case I've saved
###     externally the post-data file, and use it every time

curl -b $cookie -o station1.aspx \
  --referer ${address}/MemberPages/RefDataShop/Overview.aspx \
  ${address}/MemberPages/RefDataShop/StationType.aspx'?OrderID=-1'

curl -b $cookie -o station2.aspx \
  --referer ${address}/MemberPages/RefDataShop/StationType.aspx'?OrderID=-1' \
  ${address}/MemberPages/RefDataShop/RefStations.aspx'?OrderID=-1'

#### -- non funge
#curl -b $cookie -o station3.aspx \
#  --referer ${address}/MemberPages/RefDataShop/RefStations.aspx'?OrderID=-1' \
#  -d "{loginId: 292}" \
#  ${address}/MemberPages/RefDataShop/GetStationList 

curl -b $cookie -o station4.aspx \
  --referer ${address}/MemberPages/RefDataShop/RefStations.aspx'?OrderID=-1' --location \
  -d @$postati3 \
  ${address}/MemberPages/RefDataShop/RefStations.aspx'?OrderID=-1'


### --- Date and Time selection

cat $postati4 > postati4.$$

cat << END >> postati4.$$
&ctl00%24ContentPlaceHolder1%24m_DateTimeSelectionDate_hidden=%253CDateChooser%2520ShowDropDown%253D%2522false%2522%2520Value%253D%2522${year}x${month1}x${day1}%2522%253E%253C%2FDateChooser%253E
&ctl00%24ContentPlaceHolder1%24mxDateTimeSelectionDate_input=${day}%2F${month}%2F${year}
&ctl00%24ContentPlaceHolder1%24m_StartTimeHour=0
&ctl00%24ContentPlaceHolder1%24m_StartTimeMinute=0
&ctl00%24ContentPlaceHolder1%24m_StartTimeSecond=0
&ctl00%24ContentPlaceHolder1%24m_DurationHour=23
&ctl00%24ContentPlaceHolder1%24m_DurationMinute=59
&ctl00%24ContentPlaceHolder1%24m_IntervalDropDownList=30
&ctl00%24ContentPlaceHolder1%24NextToOrderButton=Next%3A+Add+to+order+%3E%3E
&ContentPlaceHolder1_m_DateTimeSelectionDate_DrpPnl_Calendar1=%253Cx%2520PostData%253D%2522${year}x${month1}x${year}x${month1}x${day1}%2522%253E%253C%2Fx%253E
END


curl -b $cookie -o time1.aspx \
  --referer ${address}/MemberPages/RefDataShop/TimeSelection.aspx'?OrderID=-1' --location \
  -d @postati4.$$ \
  ${address}/MemberPages/RefDataShop/TimeSelection.aspx'?OrderID=-1'

set nodata = `grep "No data is available" time1.aspx`
if ($#nodata != 0) then
 echo ===============================================================================
 echo WARNING:
 echo "No data available for $year/$month/$day on Trimble Website"
 echo ===============================================================================
 rm *.$$ *.aspx cookie?.txt
 exit
endif
 

set orderid = `grep OrderID time1.aspx | grep "form method" | sed -e 's:<form method="post" action="Order.aspx?OrderID=::' -e 's/" id="form1" style="margin: 0px;">//' | awk '{print int($1)}'`

echo ==================
echo Order id is $orderid
echo ==================


## --- submit order - step1

curl -b $cookie -o order1.aspx \
  ${address}/MemberPages/RefDataShop/Order.aspx'?OrderID='$orderid


curl -b $cookie -o order2.aspx \
  --referer ${address}/MemberPages/RefDataShop/Order.aspx'?OrderID='$orderid \
  -d @$postati5 \
  ${address}/MemberPages/RefDataShop/Order.aspx'?OrderID='$orderid



## -- submit order - step 2
curl -b $cookie -o order3.aspx \
  --referer ${address}/MemberPages/RefDataShop/Delivery.aspx'?OrderID='$orderid \
  --location \
  -d @$postati6 \
  ${address}/MemberPages/RefDataShop/Delivery.aspx'?OrderID='$orderid


echo $orderid >> $orderlist



rm *.$$ *.aspx cookie?.txt
