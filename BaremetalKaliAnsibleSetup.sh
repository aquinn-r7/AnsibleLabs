!#/bin/bash

#Perform System Updates
apt-get update
apt-get full-upgrade -y

#Install Ansible
apt-add-repository -ppa:ansible/ansible
apt-get update
apt-get install -y ansible

#Install Vagrant
#For Kali, Add Ubuntu package repo to sources

echo 'deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com kinetic main' | sudo tee /etc/apt/sources.list.d/hashicorp.list
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
apt update && apt install vagrant

# Install VirtualBox

curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox_2016.gpg
curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bullseye contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
apt update && sudo apt install -y dkms
apt install -y virtualbox virtualbox-ext-pack

#Make Vagrant Folder and Install CentOS VM

mkdir -p /opt/vagrant/files
cd /opt/vagrant/files
vagrant box add geerlingguy/centos7
vagrant init geerlingguy/centos7
vagrant up

#Obtain VM Information
vagrant_host=$(vagrant ssh-config | grep HostName | awk '{print $2 ":2222"}')
ssh_key=$(vagrant ssh-config | grep IdentityFile | awk '{print $2}')

#Make hosts and add initial server
mkdir /etc/ansible
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
touch ansible.yml
