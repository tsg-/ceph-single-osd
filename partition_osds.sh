#!/bin/bash

skip_partitioning=0
if [ "$1" == "name" ]; then
        skip_partitioning=1
fi

DEVS=" \
/dev/nvme0n1  \
"

PARTED="parted -s"
SGDISK="sgdisk"

rm /dev/disk/by-partlabel/*
sleep 2

if [ ${skip_partitioning} == 0 ]; then
        for dev in ${DEVS}; do
                echo "Partitioning ${dev}"
                ${PARTED} ${dev} mklabel gpt
                sleep 2
                ${PARTED} ${dev} mkpart primary    0%    5GiB
                ${PARTED} ${dev} mkpart primary   5GiB  100%
        done
fi



partno=0
for dev in ${DEVS}; do
        echo "Setting name on ${dev}"
        ${SGDISK} -c 1:osd-device-${partno}-journal ${dev}
        ${SGDISK} -c 2:osd-device-${partno}-data ${dev}
        ((partno++))
done

