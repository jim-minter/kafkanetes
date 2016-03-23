#!/bin/bash -e
# usage: zookeper-server-start-multiple.sh zookeeper.properties hostname-prefix myid maxid

echo $3 >/tmp/zookeeper/myid
for ((i=1; i<=$4; i++)); do
  if [ $i -eq $3 ]; then
    echo server.$i=0.0.0.0:2888:3888
  else
    echo server.$i=$2-$i:2888:3888
  fi
done >>$1
cat >>$1 <<EOF
tickTime=2000
initLimit=10
syncLimit=5
EOF

exec bin/zookeeper-server-start.sh $1
