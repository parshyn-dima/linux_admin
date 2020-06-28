#!/usr/bin/env bash

LOCKFILE=/tmp/lockfile
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "already running"
    exit
fi

# Make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

# Configure backup
BACKUP_HOST='backup'
BACKUP_USER='borg'
BACKUP_REPO=$(hostname)-etc

## Вывод в файл журнала
##

echo $BACKUP_REPO

# Make backup
borg create \
  --stats --progress \
  ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_REPO}::"etc-{now:%Y-%m-%d_%H:%M:%S}" \
  /etc

# Prune backup
borg prune \
  -v --list \
  ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_REPO} \
  --keep-within=30d \
  --keep-monthly=-2

# Delete lockfile
rm -f ${LOCKFILE}