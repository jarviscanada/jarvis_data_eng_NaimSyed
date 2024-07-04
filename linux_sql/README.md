# Introduction
(about 100-150 words)
This project provides a minimal viable product that can support the resource planning of a cluster of Linux machines with real time data. 
A psql instance is built on a docker container and a database is set up to store the hardware specifications and usage data. 
Shell scripts will parse through bash commands utilizing regex for data collection and inserted into the database. 
A crontab command can then be used to run the scripts for real time data. 

# Quick Start
- Start a psql instance using psql_docker.sh
```
bash psql_docker.sh start|stop|create db_username db_password
```
- Create tables using ddl.sql
```
bash ddl.sql
```
- Insert hardware specs data into the DB using host_info.sh
```
bash scripts/host_info.sh psql_host psql_port db_name psql_user psql_password
```
- Insert hardware usage data into the DB using host_usage.sh
```
bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
```
- Crontab setup
```
bash crontab -e 
***** bash /host_usage_filepath psql_host psql_port db_name psql_user psql_password > /tmp/host_usage.log
```
# Implemenation
Discuss how you implement the project.
## Architecture
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to the `assets` directory.

## Scripts
Shell script description and usage (use markdown code block for script usage)
- psql_docker.sh
- host_info.sh
- host_usage.sh
- crontab
- queries.sql (describe what business problem you are trying to resolve)

## Database Modeling
Describe the schema of each table using markdown table syntax (do not put any sql code)
- `host_info`
- `host_usage`

# Test
How did you test your bash scripts DDL? What was the result?

# Deployment
How did you deploy your app? (e.g. Github, crontab, docker)

# Improvements
Write at least three things you want to improve
e.g.
- handle hardware updates
- blah
- blah