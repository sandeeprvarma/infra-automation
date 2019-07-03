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

echo "creating and moving to epgs-setup folder" >> terraform_progress.txt
mkdir epgs-setup
cd epgs-setup

sudo git clone -b ${brach_name} ${git_repo_url} epgs
cd epgs

echo "Ansible Git-Repo ${brach_name} branch fetched on" >> terraform_progress.txt
echo "Provided permission to the user" >> terraform_progress.txt
sudo chown -R ubuntu:ubuntu .

echo "Ansible started" >> terraform_progress.txt
sudo ansible-playbook -c local ansible/${provision_file} --inventory-file=ansible/inventory/${inventory} --limit="${host_name}" --extra-vars "run_without_cron=1" >> terraform_progress.txt
echo "Completed ansible setup" >> terraform_progress.txt

echo "All done" >> terraform_progress.txt