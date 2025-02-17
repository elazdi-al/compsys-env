#!/bin/bash
# backup_volumes.sh - Backup Docker volumes for persistent data

set -e

# List of volumes to backup (as defined in docker-compose.yml)
VOLUMES=("code_data" "nvchad_config")

# Create a backup directory with a timestamp
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
BACKUP_DIR="docker_backup_${TIMESTAMP}"
mkdir -p "$BACKUP_DIR"

# Backup each volume using a temporary Alpine container
for V in "${VOLUMES[@]}"; do
  echo "Backing up volume: $V"
  docker run --rm \
    -v "${V}":/volume \
    -v "$(pwd)/${BACKUP_DIR}":/backup \
    alpine \
    sh -c "tar czf /backup/${V}.tar.gz -C /volume ."
done

echo "Backup completed. Files are saved in: ${BACKUP_DIR}"

