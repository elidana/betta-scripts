#!/bin/bash
export TIMEFORMAT='%3R'

awsout=downloads/aws/
fdsnout=downloads/fdsn/
mkdir -p $awsout $fdsnout

### single sta download
echo "----------------------- seismic station single file ---------------"
echo aws
time aws s3 sync --no-sign-request --quiet s3://geonet-open-data/waveforms/miniseed/2022/2022.245/PUZ.NZ/ $awsout --exclude "*" --include "*10-HHE.*"
echo ""
echo FDSN
cat << EOF > post_input.txt
NZ PUZ 10 HHE 2022-01-09T00:00:00 2022-01-09T23:59:59
EOF
time curl --silent --data-binary @post_input.txt http://service.geonet.org.nz/fdsnws/dataselect/1/query -o ${fdsnout}/test_post.mseed
echo ""
echo "-------------------------------------------------------"


### folder download
echo "------------------ miniseed, 1 day, 7 stations, all ?n? channels --------------------"
echo "7 stations from aws"
time aws s3 sync --quiet --no-sign-request s3://geonet-open-data/waveforms/miniseed/2022/2022.245/  $awsout --exclude "*" --include "D*.NZ/*-HNZ.*"
echo ""
#
echo "7 stations from FDSN"
cat << EOF > post_input.txt
NZ DALS 20 HNZ 2022-01-09T00:00:00 2022-01-09T23:59:59
NZ DCZ  20 HNZ 2022-01-09T00:00:00 2022-01-09T23:59:59
NZ DFHS 20 HNZ 2022-01-09T00:00:00 2022-01-09T23:59:59
NZ DHSS 20 HNZ 2022-01-09T00:00:00 2022-01-09T23:59:59
NZ DORC 20 HNZ 2022-01-09T00:00:00 2022-01-09T23:59:59
NZ DSZ  21 HNZ 2022-01-09T00:00:00 2022-01-09T23:59:59
NZ DUWZ 20 HNZ 2022-01-09T00:00:00 2022-01-09T23:59:59
EOF
time curl --silent --data-binary @post_input.txt http://service.geonet.org.nz/fdsnws/dataselect/1/query -o ${fdsnout}/test_post.mseed
echo ""
echo "-------------------------------------------------------"
