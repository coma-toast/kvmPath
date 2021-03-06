#!/bin/bash
# Steve Homick
# 2017
# Easy way to install kvm/libvirt on Debian Based Linux Distributions.

set -o pipefail   # If a command anywhere in the set of piped commands failed, the whole line should fail
set -u  # Uninitialized variables should cause an error
set -e # Exit the script if any command fails


#Color Schemes
RESETTXT="\e[0m"
GREENTXT="\e[1m\e[32m"
REDTXT="\e[1m\e[31m"
BLUETXT="\e[1m\e[34m"

if [ $(id -u) != 0 ] ; then
  printf "$REDTEXT[X]$RESETTXT Script must be run as root/sudo \n"
  printf "Exiting."
  exit 1
fi

(command -v dpkg || printf "[X] You are currently not utilizing a Debian Based Linux distro. \n \n " ; cat /etc/issue)

echo -e " $GREENTXT[*]$RESETTXT Debian / Ubuntu[*] check"
echo -e " $GREENTXT[*]$RESETTXT root[*] check."

#sys variables
cpuname=$(cat /proc/cpuinfo | grep 'model name' | uniq)
cores=$(egrep -c '(vmx|svm)' /proc/cpuinfo)

read -p "If you are ready to install libvirt/kvm please press Enter or press CTRL+C to cancel"

kvm_prereqs()
{
#hostcpu=$(egrep -c '(vmx|svm)' /proc/cpuinfo)

if [ $cores -lt '1' ] ; then
  printf "This machine does not support virtualization. \n exiting"
  printf "https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Virtualization/chap-Virtualization-System_requirements.html \n \n"
  printf "https://askubuntu.com/questions/806532/getting-information-about-cpu \n \n"
  cpuname=$(cat /proc/cpuinfo | grep 'model name' | uniq)

  exit 1
fi #if [ $cores -lt '1' ]

if [ $cores -gt '1' ] ; then
  printf "We're good to go. You have $(egrep -c '(vmx|svm)' /proc/cpuinfo) cores. "
  printf "KVM Ready to install. \n \n"
  printf "Installing \n \n "
  kvm_install
fi #if [ $cores -gt '1' ]
# comments

}


kvm_install(){
  (apt-get -y update && apt-get -y install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils && apt-get -y install virt-manager) && printf "\n \n Please reboot machine to establish libvirt / qemu connection \n \n"
  kvm-ok
  command -v virsh ; dpkg -l | grep -i libvirt
  read -p "Reboot now :> (CTRL+C to cancel, Enter to reboot)"
  sudo reboot now

}
kvm_prereqs
