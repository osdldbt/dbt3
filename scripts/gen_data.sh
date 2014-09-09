#!/bin/sh

DIR=`dirname $0`
. ${DIR}/dbt3_profile || exit 1

SRCDIR=${DBT3_HOME}

if [ $# -ne 1 ]; then
	echo "usage: gen_data.sh <scale factore>"
fi

SF=$1

$DBGEN -f -s $SF -T c &
$DBGEN -f -s $SF -T L &
$DBGEN -f -s $SF -T n &
$DBGEN -f -s $SF -T O &
$DBGEN -f -s $SF -T P &
$DBGEN -f -s $SF -T r &
$DBGEN -f -s $SF -T s &
$DBGEN -f -s $SF -T S &

wait
