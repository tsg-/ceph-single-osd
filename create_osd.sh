#!/bin/bash

[ "x$1" == "x" ] && echo "Usage: $0 [id:int]" && exit 1

i=$1

base_dir=`pwd`
ceph_conf=${base_dir}/ceph.conf
mnt_dir=${base_dir}/ceph/mnt

mkdir -p ${mnt_dir}

uuid=`uuidgen`
ceph -c ${ceph_conf} osd create ${uuid} $i
ceph-osd -c ${ceph_conf} -i $i --mkfs --mkkey --osd-uuid ${uuid}
ceph -c ${ceph_conf} osd crush add osd.${i} 1.0 host=`hostname` root=default
ceph -c ${ceph_conf} -i ${mnt_dir}/osd-device-${i}-data/keyring auth add osd.${i} osd "allow *" mon "allow profile osd" mgr "allow"
