#! /bin/csh -f

set a = `docker ps -a -q`

if ($#a != 0) then
  echo "-- stopping --"
  docker stop $a
  echo "-- removing --"
  docker rm $a
else
  echo "  nothing to clean "
endif
