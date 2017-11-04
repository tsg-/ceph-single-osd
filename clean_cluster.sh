#!/bin/bash

i=0

ceph osd down $i
ceph osd rm $i
ceph auth del osd.$i
ceph osd crush remove osd.$i
umount /dev/disk/by-partlabel/osd-device-${i}-data

sudo pkill -9 ceph
sudo rm -rf /tmp/cbt/
sudo rm -rf /tmp/cbt_reuse/

sudo service rbdmap stop
sudo killall -9 massif-amd64-li
sudo killall -9 memcheck-amd64-
sudo pkill -9 ceph-osd
sudo killall -9 ceph-osd
sudo killall -9 ceph-mon
sudo killall -9 ceph-mds
sudo killall -9 rados
sudo killall -9 rest-bench
sudo killall -9 radosgw
sudo killall -9 radosgw-admin
sudo /etc/init.d/apache2 stop
sudo killall -9 pdsh
pkill -SIGINT -f collectl
sudo pkill -SIGINT -f perf_3.6
sudo pkill -SIGINT -f blktrace
sudo umount /tmpcbt/mnt/*
sudo rm -rf /tmp/cbt/
sudo rm -rf /tmp/cbt_reuse/0*

for i in `seq 1 2`; do 
	pkill -9 fio; 
	pkill -9 collectl; 
	pkill -9 iostat; 
	pkill -9 sar; 
	pkill -9 collectl; 
	pkill -9 iostat; 
	pkill -9 sar; 
done
