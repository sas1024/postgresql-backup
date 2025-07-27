#!/bin/bash


BASE_PATH=$(dirname $0)
BASE_PATH=$(realpath ${BASE_PATH})
DUMP_DATE=$(date "+%Y-%m-%d-%H%M")
DUMP_DIR="sql"
BZIP="/usr/bin/bzip2"
MAX_DAYS=${KEEP:-1}
PGSQL_DUMP="/usr/bin/pg_dump"
PARAMETERS="${PGSQL_DUMP} -O"

if [ ! -f /secrets/pg_data.env ]; then
  echo "PG data variables file wasn't found"
  exit 1
fi 

source /secrets/pg_data.env

for pg_server in "${!pg_servers[@]}"; do
  pgdata="${pg_servers[$pg_server]}"
  eval "$pgdata"

# use PGHOST, PGPORT, PGDATABASE ,PGUSER, PGPASSWORD variables for database connection

  export PGHOST=$PGHOST
  export PGPORT=$PGPORT
  export PGDATABASE=$PGDATABASE
  export PGUSER=$PGUSER
  export PGPASSWORD=$PGPASSWORD

  mkdir -p ${BASE_PATH}/${DUMP_DIR}/${pg_server}

  # Clear Useless DB
  clear_useless() {
    find ${BASE_PATH}/${DUMP_DIR}/${pg_server} -name "*.bz2" -type f -atime +${MAX_DAYS} -exec rm {} \;
    return 0
  }

  # Run Backup
  run_backup() {
    if [ -z ${PGDATABASE} ]; then
      echo "PGDATABASE variable wasn't found"
      return 1
    fi
  
    echo "Starting dumping"
    DUMP_FILENAME="${BASE_PATH}/${DUMP_DIR}/${pg_server}/${PGDATABASE}_${DUMP_DATE}.sql"
    DUMP_CMD=${PARAMETERS}
  
    echo "Processing ${PGDATABASE}. "
    ${DUMP_CMD} >${DUMP_FILENAME}
  
    if [ -f ${DUMP_FILENAME} ]; then
      ${BZIP} ${DUMP_FILENAME}
    else
      echo "File ${DUMP_FILENAME} doesn't exist"
      exit 1
    fi
    echo "Dumping postgres roles"
    pg_dumpall --roles-only > ${BASE_PATH}/${DUMP_DIR}/${pg_server}/${PGDATABASE}-roles.sql
  }
  
  # Run Backup
  run_backup

  # Cleanup
  clear_useless

done

