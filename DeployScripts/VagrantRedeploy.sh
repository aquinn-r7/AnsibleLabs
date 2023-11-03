#!/bin/bash

vagrant destroy --force
rm /opt/vagrant/files/Vagrantfile
vagrant init geerlingguy/centos7
vagrant up

#Obtain VM Information
vagrant_host=$(vagrant ssh-config | grep HostName | awk '{print $2 ":2222"}')
ssh_key=$(vagrant ssh-config | grep IdentityFile | awk '{print $2}')

chmod 600 $ssh_key
#Determine if argument was provided for ansible host name
if [ -z "$1" ]; then
    # Set a default value if no argument is provided
    ansible_host="testing"
else
    # Use the provided argument
    ansible_host="$1"
fi
echo -e "[$ansible_host]\n$vagrant_host ansible_ssh_private_key_file=$ssh_key" > /etc/ansible/hosts

#Add Ansible Playbook to VagrantFile
head -n -1 Vagrantfile > Vagrantfile2 && mv Vagrantfile2 Vagrantfile
echo -e '\nconfig.vm.provision "ansible" do |ansible|\n  ansible.playbook = "ansible.yml"\nend\nend'  >> Vagrantfile
