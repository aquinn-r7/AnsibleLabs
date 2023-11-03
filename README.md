# AnsibleLabs
A repository of notes and scripts useful for setting up an Ansible lab environment.

For anyone wanting to experiment with Ansible and learn how to use it, I made a script to set up a Baremetal Kali machine to install Ansible, Vagrant, and Virtualbox.  After everything is set up, it will deploy a  CentOS 7 VM and automatically adjust the Vagrantfile to allow for provisioning commands from a created ansible.yml playbook.  If you would rather use a VM Kali instance, you will need to deploy your testing machine manually within AWS.  After doing so, you can run the AWS Deploy script and provide the arguments listed within the comments to configure Ansible to properly access the host.  If you already have Ansible installed and would like to use an AWS server for the lab, please use the AWS Redeploy script.

The host reference in Ansible will be either testing if no argument is provided to the script, or whatever argument you provide to the script.  I've also included scripts to easily nuke and redeploy the testing machine for both AWS and Vagrant.
