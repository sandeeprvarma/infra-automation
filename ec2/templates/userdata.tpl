#!/bin/bash

# bash strict and verbose mode
set -o pipefail -e -u -x

# wait for system apt-get update to complete before starting to install
# any additional debian packages.
lock="/var/lib/dpkg/lock"
lock_released="false"
count=0
while [ $lock_released == "false" ]; do
    if fuser -s $lock; then
        echo "lock $lock in use, retry $count"
        sleep 10
        let "count = count + 1"
    else
        lock_released="true"
    fi
done

# installing Ansible
echo "Installing Ansible" >> terraform_progress.txt
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y
echo "Ansible Installed on" >> terraform_progress.txt
