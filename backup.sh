#!/bin/bash
DATE=$(date +%Y-%m-%d-%H%M%S)

# pfad sollte nicht mit "/" enden!
BACKUP_DIR="$HOME/backup"

while IFS='' read -r line || [[ -n "$line" ]]; do
    tmp_array=($line)
    tar -cjpf $BACKUP_DIR/${tmp_array[0]}-$DATE.tar.bz2 ${tmp_array[1]}
done < "/home/armbruster/scripts/backupfiles"