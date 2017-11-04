sudo pkill -9 ceph-mon 
sudo pkill -9 ceph-mgr
sleep 3

base_dir=`pwd`
ceph_conf=${base_dir}/ceph.conf
pid_dir=${base_dir}/ceph/pid
mon_dir=${base_dir}/ceph/mon.a/

sudo ceph-run sudo sh -c "ulimit -n 16384 && ulimit -c unlimited && exec ceph-mon -c ${ceph_conf} -i a --keyring=${base_dir}/ceph/keyring --pid-file=${base_dir}/ceph/pid/root@`hostname`.pid --mon-data=${mon_dir}"

sudo sh -c "ulimit -n 16384 && ulimit -c unlimited && exec ceph-run ceph-mgr -i a"

name='a'

sudo ceph auth get-or-create mgr.$name mon 'allow profile mgr' osd 'allow *' mds 'allow *'
sudo sh -c "ulimit -n 16384 && ulimit -c unlimited && exec ceph-run ceph-mgr -i $name"

cp -f ceph/keyring /etc/ceph
