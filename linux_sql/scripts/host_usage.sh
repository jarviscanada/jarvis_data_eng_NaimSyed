#!/bin/bash

#1. Assign Arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ $# -ne 5 ]; then
  echo 'illegal number of arguments'
  exit 1
fi 

export PGPASSWORD=$psql_password
#Parse Data
hostname=$(hostname -f)
memory_free=$(vmstat --unit M | tail -1 | awk -v col="4" '{print $col}')
cpu_idle=$(vmstat --unit M | tail -1 | awk '{print $15}')
cpu_kernel=$(vmstat -t | tail -1 | awk '{print($14)}')
disk_io=$(vmstat -d | tail -1 | awk '{print($10)}')
disk_available=$(df -BM --total | egrep '/$' | awk '{print $4}' | grep -o '[0-9]\+')
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

insert_stmt="INSERT INTO host_usage(timestamp, host_id, disk_available, memory_free, cpu_idle, cpu_kernel, disk_io) VALUES ('$timestamp', (SELECT id FROM host_info WHERE hostname='$hostname'), '$disk_available', '$memory_free', '$cpu_idle', '$cpu_kernel', '$disk_io')"

psql -h "$psql_host" -p "$psql_port" -U "$psql_user" -d "$db_name" -c "$insert_stmt"
psql_status=$?
if [ $psql_status -ne 0 ]; then
  echo 'psql failed'
  exit 1
fi

exit 0