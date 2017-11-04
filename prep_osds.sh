#!/bin/bash
set -x

base_dir=`pwd`
ceph_conf=${base_dir}/ceph.conf
mnt_dir=${base_dir}/ceph/mnt

for i in {0..0}; do
    mnt_pt=${mnt_dir}/osd-device-${i}-data/
    mkdir -p ${mnt_pt}
    mkfs.xfs /dev/disk/by-partlabel/osd-device-${i}-data
    mount /dev/disk/by-partlabel/osd-device-${i}-data ${mnt_pt}
done
