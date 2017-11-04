#!/bin/bash
set -x

[ "x$1" == "x" ] && exit 1

pkill -9 ceph-osd
i=$1

base_dir=`pwd`
ceph_conf=${base_dir}/ceph.conf
mnt_dir=${base_dir}/ceph/mnt

ceph osd down $i
ceph osd rm $i
ceph auth del osd.$i
ceph osd crush remove osd.$i
umount /dev/disk/by-partlabel/osd-device-${i}-data
mkfs.xfs /dev/disk/by-partlabel/osd-device-${i}-data -f
mount /dev/disk/by-partlabel/osd-device-${i}-data ${mnt_dir}/osd-device-${i}-data/
