#!/bin/bash
# A sample Bash script, by Ryan
echo Hello World!
#SULOG_FILE     /var/log/sulog
#PASS_MAX_DAYS   99999
#PASS_MIN_DAYS   0
#PASS_WARN_AGE   7

file=/etc/ssh/sshd_config
cp -p $file $file.old &&
awk '
$1=="PasswordAuthentication" {$2="yes"}
$1=="PubkeyAuthentication" {$2="yes"}
{print}
' $file.old > $file

file2=/etc/login.defs
cp -p $file2 $file2.old &&

awk '
$1=="PASS_MAX_DAYS" {$2="90"}
$1=="PASS_MIN_DAYS" {$2="1"}
$1=="PASS_WARN_AGE" {$2="5"}
{print}
' $file2.old > $file2



#! /bin/bash
sudo apt update -y && sudo apt upgrade -y
echo -e 'ubuntu\nubuntu' | sudo passwd ubuntu
echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/ubuntu
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo systemctl restart sshd.service




echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCHiLaX7RxcDIGxhB4KMisfAEw0j1C98e7dMBPmG0ynS3o
rNS4M9ub7d3V7RMxVwGzP1ixoqTxKUUnlg+QJvuqqVC0hVoubhhiN6KSwkJI0WJ+pYLgzFC4vbFqj0pXmBIzUF0Pn
5Xakk3G+EAixIU+5gz9z9CyZ8iE74bUB65zbWgzWqo4hPxiOA4yv1Ka4XDn2MSRtOAyMVgIhYbdxLm21DuWHYsJTf
h64dmn87ZynKrqdKNxjUqMsKuUsJ7Q0sjDT7eASebYVL9Y8GYIaH+DCdPO6rov+UUjm+sC24c+emqO0Am0KEDQOQ0
jTgFwDIMyj3d7JbBNCaxv90MD8uCjLY+aSeFh1F9HWlV8es7Vv4GSeZ+wM8F/7aT94w9laUe4j7e1xOCSAUNEZk7W
xTzXD0w/uii5EAR3bHV8WafnNqGugsYDMU0llNCohNdTkmJaAikZBqg+VBV/PUMOy++3NgFuOWif+FMqvl2fLbvyJ
zPEJLvvix7l/xHTuTiO6Vts= ubuntu@ip-172-31-87-168" > /var/lib/jenkins/.ssh/known_hosts




#!bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

if [ $UID -ne 0 ]
then
    echo "Please usage with sudo or as root"
    exit 1
fi

echo -e "${RED}Showing HOSTNAME and DATE of Running the script${ENDCOLOR}"

HOSTNAME=$(hostnamectl)
DATE=`timedatectl`
echo -e "${RED}variable HOST value: $HOSTNAME,${ENDCOLOR}"
echo -e "${RED}variable DATE value: $DATE,${ENDCOLOR}"

echo -e "Showing all Disks and mount Points in the $HOSTNAME at $DATE ${ENDCOLOR}"
df -Th

lsblk


echo -e "${RED}setup up LVM and scan for existing configurations ${ENDCOLOR}"
vgscan


echo -e "${RED}Creating the physical volumes ${ENDCOLOR}"
echo -e "${RED}Select the Physical Disk 1 ${ENDCOLOR}"
read -r PV1
pvcreate -v /dev/$PV1
echo -e "${RED}Select the Physical Disk 2 ${ENDCOLOR}"
read -r PV2
pvcreate -v /dev/$PV2


echo -e "${GREEN}this script builds a volume group with physical volume we created${ENDCOLOR}"
echo -e "${GREEN}Creating the VG group${ENDCOLOR}"
read -p "$( echo -e ${GREEN}Give VG name: ${ENDCOLOR})" vgname
vgcreate $vgname /dev/$PV1 /dev/$PV2 
vgdisplay $vgname

fstab=/etc/fstab

while true; do
    read -p "$( echo -e ${YELLOW}Give lvname: ${ENDCOLOR})" lvname
    read -p "$( echo -e ${YELLOW}Give lvsize: ${ENDCOLOR})" size
    lvcreate -L $size -n $lvname $vgname
    
    echo -e "${BLUE}Create a filesystem on logical volumes${ENDCOLOR}"
    echo -e "${BLUE}The -m option specifies the percentage reserved for the super-user, we can set this to 0 to use all the available space (the default is 5%).${ENDCOLOR}"
    read -p "$( echo -e ${BLUE}Give percentage reserved for the super-user: ${ENDCOLOR})" user
    mkfs.ext4 -m $user /dev/$vgname/$lvname

    read -p "$( echo -e ${YELLOW}Give Foldername: ${ENDCOLOR})" input
    mkdir -p /mnt/$input
    echo "folder created $input"

    mount /dev/$vgname/$lvname /mnt/$input>/dev/null
    echo "/dev/$vgname/$lvname /mnt/$input ext4 defaults 0 0">>/etc/fstab
    mount -a
    lsblk
done


#! /bin/bash
sudo apt update -y && sudo apt upgrade -y
sudo useradd devops
echo -e 'devops\ndevops' | sudo passwd devops
echo -e 'ubuntu\nubuntu' | sudo passwd ubuntu
echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/ubuntu
echo 'devops ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/devops
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo systemctl restart sshd.service
sudo apt install -y python3
sudo apt install -y vim
sudo apt install -y ansible
sudo apt install -y git
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
   /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install fontconfig openjdk-11-jre -y
sudo apt-get install jenkins -y
echo 'jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/jenkins
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y && sudo apt install terraform -y
sudo apt install docker.io -y
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service



#!/bin/bash


echo "Enter the eksclustername: " 
read eksclustername

echo "Enter the region: " 
read region

echo "Enter the Nodes: " 
read nodes

echo "Enter the Minimnum Nodes Required: " 
read min

echo "Enter the Maximun Nodes Required: " 
read max

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
which eksctl
eksctl version
# .<(eksctl completion bash)
sudo apt-get install bash-completion -y
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
eksctl create cluster  --region $region --nodes $nodes --nodes-min $min --nodes-max $max --name $eksclustername

curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

kubectl get nodes
kubectl get pods
# eksctl delete cluster kube --region us-east-1



#!/bin/bash

echo Hello!
file1=/etc/resolv.conf
file2=/etc/hosts
file3=/etc/ssh/sshd_config
file4=/etc/login.defs
file5=/etc/passwd
file6=/etc/group
file7=/etc/shadow
file8=/etc/pam.d/login
file9=/var/log/messages

if [ -f $file1 -a -f $file2 -a -f $file3 -a -f $file4 -a -f $file5 -a -f $file6 -a -f $file7 -a -f $file8 -a -f $file9 ]; then
    echo "files exist."
    else
    echo "all files doesnot exist"
fi

if [ -f /etc/resolv.conf -a -f /etc/hosts ]; then
    echo "Both files exist."
fi

# if [ cat /etc/ssh/sshd_config | grep -i "PermitRootLogin No" -eq 0 ];
#     then echo "file exists with Login"

#     else
#         echo "PermitRootLogin No" >> /etc/ssh/sshd_config

# fi


#!/usr/bin/env bash

while true; do
  read -p "Folder name:" input
#   [[ -z "$input" ]] && break
  mkdir -p "$input"
done

#!/bin/bash
# A sample Bash script, by Ryan
echo Hello World!
#SULOG_FILE     /var/log/sulog
#PASS_MAX_DAYS   99999
#PASS_MIN_DAYS   0
#PASS_WARN_AGE   7





file=/etc/ssh/sshd_config
cp -p $file $file.old &&
awk '
$1=="PasswordAuthentication" {$2="yes"}
$1=="PubkeyAuthentication" {$2="yes"}
{print}
' $file.old > $file

file2=/etc/login.defs
cp -p $file2 $file2.old &&

awk '
$1=="PASS_MAX_DAYS" {$2="90"}
$1=="PASS_MIN_DAYS" {$2="1"}
$1=="PASS_WARN_AGE" {$2="5"}
{print}
' $file2.old > $file2


sed -i '/SULOG_FILE/s/^#//g' $file2


echo "PermitRootLogin No" >> /etc/ssh/sshd_config
sort -u /etc/ssh/sshd_config


#!/bin/bash


echo "Enter the eksclustername: " 
read eksclustername

echo "Enter the region: " 
read region

echo "Enter the Nodes: " 
read nodes

echo "Enter the Minimnum Nodes Required: " 
read min

echo "Enter the Maximun Nodes Required: " 
read max

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
which eksctl
eksctl version
# .<(eksctl completion bash)
sudo apt-get install bash-completion -y
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
eksctl create cluster  --region $region --nodes $nodes --nodes-min $min --nodes-max $max --name $eksclustername

curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

kubectl get nodes
kubectl get pods
# eksctl delete cluster kube --region us-east-1


