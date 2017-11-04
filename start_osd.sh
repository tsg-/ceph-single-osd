sudo pkill -9 ceph-osd
sleep 2

base_dir=`pwd`
ceph_conf=${base_dir}/ceph.conf
pid_dir=${base_dir}/ceph/pid

mkdir -p ${pid_dir}
env -i TCMALLOC_MAX_TOTAL_THREAD_CACHE_BYTES=134217728 /usr/local/bin/ceph-osd -c ${ceph_conf} -i 0 --pid-file=${pid_dir}/ceph-osd.0.pid

