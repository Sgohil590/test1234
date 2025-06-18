

#Note this is script use for only create sudoers users with password authentication in ubuntu.
#for run this sudo ./setup-user.sh 
#!/bin/bash

# Ensure script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

# Prompt for username and password
read -p "Enter the new username: " USERNAME
read -s -p "Enter password for $USERNAME: " PASSWORD
echo

# Check if the user exists
if id "$USERNAME" &>/dev/null; then
  echo "User '$USERNAME' already exists. Skipping user creation."
else
  # Create the user and set the password
  adduser --disabled-password --gecos "" "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd

  # Add to the sudo group
  usermod -aG sudo "$USERNAME"
  echo "User '$USERNAME' created and added to the sudo group."
fi

# Define SSH configuration files
FILES_TO_UPDATE=(
  "/etc/ssh/ssh_config"
  "/etc/ssh/sshd_config"
  "/etc/ssh/sshd_config.d/60-cloudimg-settings.conf"
)

echo "Updating SSH configuration files to allow password login..."

for file in "${FILES_TO_UPDATE[@]}"; do
  if [ -f "$file" ]; then
    # Backup original file
    cp "$file" "$file.bak"

    # Set PasswordAuthentication to yes (if not already set)
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' "$file"

    # Remove any line with AuthenticationMethods (if exists)
    sed -i '/^AuthenticationMethods/d' "$file"

    # Ensure ChallengeResponseAuthentication is set to no
    sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "$file"

  else
    echo "File $file not found, skipping..."
  fi
done

# Restart SSH service to apply changes
echo "Restarting SSH service..."
systemctl restart ssh

echo "Setup complete. You can now log in as '$USERNAME' using SSH with password."

