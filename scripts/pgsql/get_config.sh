# get_config.sh: get dbt3 run configuration
#
# This file is released under the terms of the Artistic License.  Please see
# the file LICENSE, included in this package, for details.
#
# Copyright (C) 2003 Open Source Development Lab, Inc.
#
# Author: Jenny Zhang
# March 2003

#!/bin/sh

if [ $# -lt 5 ]; then
        echo "usage: $0.sh <scale_factor> <number of stream> <redirect_tmp> <redirect_xlog> <db_param> <output_dir>"
        exit
fi

scale_factor=$1
num_stream=$2
redirect_tmp=$3
redirect_xlog=$4
db_param=$5
output_dir=$6

kernel=`uname -r`
pgsql=`psql --version | grep PostgreSQL | awk '{print $3}'`
procps=`vmstat -V|grep version| awk '{print $3}'`
sar -V &> .sar.tmp
sysstat=`cat .sar.tmp |grep version | awk '{print $3}'`
rm .sar.tmp

NODE=`hostname`
CPUS=`grep -c '^processor' /proc/cpuinfo`
MHz=`grep 'cpu MHz' /proc/cpuinfo|head -n 1|awk -F: '{print $2}'`
model=`grep 'model name' /proc/cpuinfo|head -n 1|awk -F: '{print $2}'`

if [ -f /etc/redhat-release ]; then
	DISTRO=`cat /etc/redhat-release`
fi
if [ -f /etc/SuSE-release-release ]; then
	DISTRO=`cat /etc/SuSE-release-release`
fi
if [ -f /etc/miraclelinux-release ]; then
	DISTRO=`cat /etc/miraclelinux-release`
fi

memory=`grep 'MemTotal' /proc/meminfo | awk -F: '{print $2 $3}'`

shmmax_value=`/sbin/sysctl -e -a 2> /dev/null | grep shmmax | awk '{print $3}'`

echo "node: $NODE" > $output_dir/config.txt
echo "kernel: $kernel" >> $output_dir/config.txt
echo "distribution: $DISTRO" >> $output_dir/config.txt
echo "pgsql: $pgsql">> $output_dir/config.txt
echo "procps: $procps">> $output_dir/config.txt
echo "sysstat: $sysstat">> $output_dir/config.txt
echo "CPUS: $CPUS">> $output_dir/config.txt
echo "MHz: $MHz">> $output_dir/config.txt
echo "model: $model">> $output_dir/config.txt
echo "memory: $memory">> $output_dir/config.txt
echo "scale_factor: $scale_factor">> $output_dir/config.txt
echo "num_stream: $num_stream">> $output_dir/config.txt
echo "redirect_tmp: $redirect_tmp">> $output_dir/config.txt
echo "redirect_xlog: $redirect_xlog">> $output_dir/config.txt
echo "db_param: $db_param">> $output_dir/config.txt
echo "shmmax: $shmmax_value" >> $output_dir/config.txt
