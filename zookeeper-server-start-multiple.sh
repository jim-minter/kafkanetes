#!/bin/bash -e

PROPERTIES=$1
PREFIX=$2
MYID=$3
MAXID=$4

echo $MYID >/tmp/zookeeper/myid
for ((i=1; i<=$MAXID; i++)); do
  if [ $i -eq $MYID ]; then
    echo server.$i=0.0.0.0:2888:3888
  else
    echo server.$i=$PREFIX-$i:2888:3888
  fi
done >>$PROPERTIES
cat >>$PROPERTIES <<EOF
tickTime=2000
initLimit=10
syncLimit=5
EOF

exec bin/zookeeper-server-start.sh $PROPERTIES
