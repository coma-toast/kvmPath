#!/bin/bash
# Steve Homick
# 2017
# Easy way to install kvm/libvirt on Debian Based Linux Distributions.

#Color Schemes
RESETTXT="\e[0m"
GREENTXT="\e[1m\e[32m"
REDTXT="\e[1m\e[31m"
BLUETXT="\e[1m\e[34m"
(command -v apt || printf "[X] You are currently not utilizing a Debian Based Linux distro. \n \n " ; cat /etc/issue;  exit 1)
#sys variables
cpuname=$(cat /proc/cpuinfo | grep 'model name' | uniq)

if [ $(id -u) != 0 ] ; then
  printf "$REDTEXT[X]$RESETTXT Script must be run as root/sudo \n"
  printf "Exiting."
  exit 1
fi

echo -e " $GREENTXT[*]$RESETTXT Debian[*] check"
echo -e " $GREENTXT[*]$RESETTXT root[*] check."

read -p "If you are ready to install libvirt/kvm please press Enter. Or press CTRL+C to cancel"

kvm_prereqs()
{
#hostcpu=$(egrep -c '(vmx|svm)' /proc/cpuinfo)

if [ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -lt '1' ] ; then
  printf "This machine does not support virtualization. \n exiting"
  printf "https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Virtualization/chap-Virtualization-System_requirements.html \n \n"
  printf "https://askubuntu.com/questions/806532/getting-information-about-cpu \n \n"
  cpuname=$(cat /proc/cpuinfo | grep 'model name' | uniq)

  exit 1
fi

if [ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -gt '1' ] ; then
  printf "KVM Ready to install. \n \n"
  read -p "Press Enter to continue install, ctrl+c to exit."
  printf "Installing \n \n "
  kvm_install
fi


}


kvm_install(){
  (apt-get -y update && apt-get -y install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils && apt-get -y install virt-manager) && printf "\n \n Please reboot machine to establish libvirt / qemu connection \n \n"
  kvm-ok
  read -p "Reboot now :> (CTRL+C to quit, Enter to reboot)"
  sudo reboot

}
kvm_prereqs