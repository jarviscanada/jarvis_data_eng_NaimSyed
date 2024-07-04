#!/bin/bash

#1. Assign positional arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi     

export PGPASSWORD=$psql_password
#2. Parse host hardware specs using bash cmds and assign to variables
lscpu_out=$(lscpu)

hostname=$(hostname -f)
cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep 'Architecture:' |awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "Model name:" | awk -F ": " '{print $2}' | xargs)
cpu_mhz=$(echo "$cpu_model" | awk '{print substr($5,1,4) * 1000}')
L2_cache=$(echo "$lscpu_out" | awk '/^L2 cache:/ {print $3}' | xargs)
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
#3. Create Insert Statement
insert_stmt="INSERT INTO host_info (hostname,cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem, timestamp) VALUES ('$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$L2_cache', '$total_mem', '$timestamp')"
#4. Execute Insert Statement
psql -h "$psql_host" -p "$psql_port" -U "$psql_user"  -d "$db_name" -c "$insert_stmt"
psql_status=$?

if [ $psql_status -ne 0 ]; then
  echo 'psql failed'
  exit 1
fi

exit 0