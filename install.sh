#!/bin/bash

# Define constants
PHP_FILE_URL="https://raw.githubusercontent.com/loic294/SynologyDDNSBunnyMultidomain/master/bunny.php"
PHP_FILE_DEST="/usr/syno/bin/ddns/bunny.php"
TEMP_FILE="/tmp/bunny.php"
DDNS_PROVIDER_CONF="/etc.defaults/ddns_provider.conf"
Bunny_ENTRY="[Bunny]\n  modulepath=/usr/syno/bin/ddns/bunny.php\n  queryurl=https://www.Bunny.com/\n"

print_message() {
    echo -e "\n[INFO] $1\n"
}

# Step 1: Download the PHP file to a temporary location
print_message "Downloading bunny.php..."
wget $PHP_FILE_URL -O $TEMP_FILE

# Step 2: Move the downloaded file to the destination
print_message "Copying bunny.php to $PHP_FILE_DEST..."
sudo cp $TEMP_FILE $PHP_FILE_DEST

# Step 3: Change permissions of the copied file
print_message "Changing permissions of bunny.php..."
sudo chmod 755 $PHP_FILE_DEST

# Step 4: Insert Bunny configuration into ddns_provider.conf
print_message "Adding Bunny configuration to ddns_provider.conf..."
if grep -q "\[Bunny\]" $DDNS_PROVIDER_CONF; then
    print_message "Bunny configuration already exists in ddns_provider.conf. Skipping..."
else
    sudo bash -c "echo -e \"$Bunny_ENTRY\" >> $DDNS_PROVIDER_CONF"
    print_message "Bunny configuration added successfully."
fi

# Clean up temporary file
rm $TEMP_FILE

# Step 5: Delete the script itself
print_message "Deleting the installation script..."
rm -- "$0"

print_message "Installation completed."