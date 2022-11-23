#!/bin/bash
export TIMEFORMAT='%3R'

awsout=downloads/aws/
httpout=downloads/http
mkdir -p $awsout $httpout

### single sta download
echo "----------------------- GNSS single file ---------------"
file=gnss/rinex/2022/100/whng1000.22o.gz
echo aws
time aws s3 --no-sign-request --quiet cp s3://geonet-open-data/gnss/rinex/2022/100/whng1000.22o.gz .
echo ""
echo http
time curl --silent -O https://data.geonet.org.nz/$file 
echo ""
echo "-------------------------------------------------------"


### folder download
echo "----------------------- GNSS 1day, all network --------------------"
echo "folder from aws"
time aws s3 --no-sign-request --quiet sync s3://geonet-open-data/gnss/rinex/2022/100/ $awsout
echo ""
#
echo "folder from https"
http=https://data.geonet.org.nz
dir=gnss/rinex/2022/100/
time (
    curl --silent -l ${http}/${dir}/ | grep -o 'href=".*">' | sed 's/href="//;s/\/">//;s/">//' > tmp.$$
    for sta in $(cat tmp.$$ | tail -n +2); do
        curl --silent -o ${httpout}/${sta} ${http}/${dir}/${sta}
    done
)
echo ""
echo "-------------------------------------------------------"

### 10 days
echo "----------------------- GNSS 10 days, all network --------------------"
echo "10days from aws"
time aws s3 --no-sign-request --quiet sync --exclude "*" --include "10?/*" s3://geonet-open-data/gnss/rinex/2022/ $awsout
echo ""

echo "10days from https"
http=https://data.geonet.org.nz
dir=gnss/rinex/2022/
time (
    #for n in 100 101 102 103 104 105 106 107 108 109; do
    for n in 101 102; do
        curl --silent -l ${http}/${dir}/${n}/ | grep -o 'href=".*">' | sed 's/href="//;s/\/">//;s/">//' > tmp.$$
        for sta in $(cat tmp.$$ | tail -n +2); do
            curl --silent -o ${httpout}/${sta} ${http}/${dir}/${n}/${sta}
        done
    done
)
echo ""
echo "-------------------------------------------------------"


rm tmp.$$

