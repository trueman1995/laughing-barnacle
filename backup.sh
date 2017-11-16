#!/bin/bash
DATE=$(date +%Y-%m-%d-%H%M%S)

# pfad sollte nicht mit "/" enden!
BACKUP_DIR="$HOME/backup"

# Hier Verzeichnisse auflisten, die gesichert werden sollen.
# Pfade sollte nicht mit "/" enden!
PATCHES="/local/armbruster/hg/Jamaica-8/jamaica/.hg/patches"
ECLIPSE_WORKSPACE="/local/armbruster/eclipse-workspace"

tar -cjpf $BACKUP_DIR/backup_patches-$DATE.tar.bz2 $PATCHES
tar -cjpf $BACKUP_DIR/backup_eclipse_workspace-$DATE.tar.bz2 $ECLIPSE_WORKSPACE