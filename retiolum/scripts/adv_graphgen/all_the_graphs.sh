#!/bin/bash
echo "`date` begin all graphs" >> /tmp/build_graph
cd $(dirname $(readlink -f $0))
PATH=$PATH:../../../util/bin/
begin=`timer`
(./anonytize.sh /srv/http/pub/graphs/retiolum/ && echo "`date` anonytize done" >> /tmp/build_graph)&
(./sanitize.sh /srv/http/priv/graphs/retiolum/ && echo "`date` sanitize done" >> /tmp/build_graph)&
for job in `jobs -p`
do
  echo $job
  wait $job || echo "$job failed!"
done
statsc "graphs.buildtime:$(timer $begin)|ms"
