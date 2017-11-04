#!/bin/bash
set -x

fsid='f63d5a41-82f1-44df-81ca-067d9fd261cd'
base_dir=`pwd`
mon_ip=192.168.142.241
mon_dir=${base_dir}/ceph/mon.a/
mgr_dir=${base_dir}/ceph/mgr.a/
pid_dir=${base_dir}/ceph/pid
ceph_conf=${base_dir}/ceph.conf
name='a'

sudo pkill -9 ceph-mon 
sudo pkill -9 ceph-mgr
rm -rf ${mon_dir} ${mgr_dir} ${pid_dir}
sleep 1

mkdir -p ${pid_dir} ${mgr_dir}

ceph-authtool --create-keyring --gen-key --name=mon. ${base_dir}/ceph/keyring --cap mon 'allow *'
ceph-authtool --gen-key --name=client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *' ${base_dir}/ceph/keyring
monmaptool --create --clobber --add ${name} ${mon_ip}:6789 --print ${base_dir}/ceph/monmap
sudo sh -c "ulimit -c unlimited && exec ceph-mon --mkfs -c ${ceph_conf} -i ${name} --monmap=${base_dir}/ceph/monmap --keyring=${base_dir}/ceph/keyring --mon-data=${mon_dir}"

cp -a ${base_dir}/ceph/keyring ${mon_dir}/keyring
cp -a ${base_dir}/ceph/keyring ${mgr_dir}/keyring
#cp -a ${base_dir}/ceph/keyring /etc/ceph
#cp -a ${base_dir}/ceph.conf /etc/ceph

sudo ceph-run sudo sh -c "ulimit -n 16384 && ulimit -c unlimited && exec ceph-mon -c ${ceph_conf} -i ${name} --keyring=${mon_dir}/keyring --pid-file=${base_dir}/ceph/pid/root@`hostname`_mon.pid --mon-data=${mon_dir}"

#sudo ceph auth get-or-create mgr.$name mon 'allow profile mgr' osd 'allow *' mds 'allow *'
sudo ceph-run sudo sh -c "ulimit -n 16384 && ulimit -c unlimited && exec ceph-mgr -i ${name} --keyring=${mgr_dir}/keyring --pid-file=${base_dir}/ceph/pid/root@`hostname`_mgr.pid --mgr-data=${mgr_dir}"

