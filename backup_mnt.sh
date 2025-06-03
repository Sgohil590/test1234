
#!/bin/bash

# Set variables
SOURCE_DIR="/mnt"
DEST_DIR="/home/ubuntu"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="mnt_backup_$DATE.zip"
BACKUP_PATH="$DEST_DIR/$BACKUP_NAME"

# Check if zip is installed, if not, install it
if ! command -v zip &> /dev/null; then
    echo "zip not found. Installing zip..."
    apt update && apt install zip -y
    if [ $? -ne 0 ]; then
        echo "Failed to install zip. Exiting."
        exit 1
    fi
fi

# Create zip backup
echo "Starting backup of $SOURCE_DIR to $BACKUP_PATH..."
zip -r "$BACKUP_PATH" "$SOURCE_DIR" > /dev/null

# Check result
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_PATH"
else
    echo "Backup failed!"
    exit 1
fi
