#!/bin/bash
#
#Vars
echo Install Gdrive ...
wget -O /usr/src/gdrive https://raw.githubusercontent.com/kmille36/Linux-to-Windows-with-QEMU/master/gdrive-linux-x64 >/dev/null 2>&1
chmod +x /usr/src/gdrive >/dev/null 2>&1
sudo install /usr/src/gdrive /usr/local/bin/gdrive >/dev/null 2>&1
wget -O ngrok-stable-linux-amd64.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && unzip ngrok-stable-linux-amd64.zip
clear
read -p "Paste authtoken here (Copy and Right-click to paste): " CRP
./ngrok authtoken $CRP 
##nohup ./ngrok tcp --region ap 30889 &>/dev/null &
# installing required Ubuntu packages
dist=$(hostnamectl | egrep "Operating System" | cut -f2 -d":" | cut -f2 -d " ")
if [ $dist = "CentOS" ] ; then
	printf "Y\n" | yum install sudo -y
	sudo yum install wget vim curl genisoimage screen -y
	# Downloading Portable QEMU-KVM
	echo "Downloading QEMU"
	umount /dev/mapper/centos-home
        yes|lvreduce -L 2G /dev/mapper/centos-home
        lvextend -r -l+100%FREE /dev/mapper/centos-root
	##sudo yum remove xorg* -y
	##sudo yum remove gnome* -y
	##yum remove xrdp -y
	##sudo yum update -y
	sudo yum install -y qemu-kvm
	sudo yum install libguestfs-tools -y
	##curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
	##sudo yum install -y powershell
elif [ $dist = "Ubuntu" -o $dist = "Debian" ] ; then
	printf "Y\n" | apt-get install sudo -y
	sudo apt-get install vim curl genisoimage -y
	sudo mkdir /etc/powershell
	sudo wget -P /etc/powershell https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb
	sudo dpkg -i /etc/powershell/packages-microsoft-prod.deb
	# Downloading Portable QEMU-KVM
	echo "Downloading QEMU"
	sudo apt-get update
        dpkg-reconfigure debconf -f noninteractive -p critical
        UCF_FORCE_CONFFOLD=YES apt -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" -y dist-upgrade 
	sudo apt-get install -y qemu-kvm
	sudo apt-get install -y libguestfs-tools 
	sudo apt-get install -y screen 
	##sudo apt-get install -y powershell
fi
sudo ln -s /usr/bin/genisoimage /usr/bin/mkisofs
# Downloading resources

linkgz=https://dl.dropboxusercontent.com/s/20ltkmk7fyht31p/HoangLong-Windows2012R2.gz
[ -s windows2012r2.raw ] || wget -q --show-progress --no-check-certificate -O- $linkgz | gunzip | dd of=windows2012r2.raw bs=1M

dist=$(hostnamectl | egrep "Operating System" | cut -f2 -d":" | cut -f2 -d " ")
if [ $dist	= "CentOS" ] ; then
	qemupath=$(whereis qemu-kvm | sed "s/ /\n/g" | egrep "^/usr/libexec/")
	#b=($(lsblk | egrep "part"  |  tr -s '[:space:]' | cut -f1 -d" " | tr -cd "[:print:]\n" | sed 's/^/\/dev\//'))
else
	qemupath=$(whereis qemu-system-x86_64 | cut -f2 -d" ")
	#b=($(fdisk -l | grep "^/dev/" | tr -d "*" | tr -s '[:space:]' | cut -f1 -d" "))
fi
echo $qemupath >qemupath.txt
wget -O QEMU_CreateVM.sh https://github.com/kmille36/Linux-to-Windows-with-QEMU/raw/master/QEMU-KVM/QEMU_CreateVM.sh
wget -O QEMU_StartVM.sh https://github.com/kmille36/Linux-to-Windows-with-QEMU/raw/master/QEMU-KVM/QEMU_StartVM.sh
wget -O QEMU_KillVM.sh https://github.com/kmille36/Linux-to-Windows-with-QEMU/raw/master/QEMU-KVM/QEMU_KillVM.sh
wget -O QEMU_DeleteVM.sh https://github.com/kmille36/Linux-to-Windows-with-QEMU/raw/master/QEMU-KVM/QEMU_DeleteVM.sh
chmod +x QEMU_CreateVM.sh
chmod +x QEMU_StartVM.sh
chmod +x QEMU_KillVM.sh
chmod +x QEMU_DeleteVM.sh
clear
echo Coder by: fb.com/thuong.hai.581
echo Coder by: fb.com/thuong.hai.581 > instruction.txt
echo Done! Original QCOW2 disk downloaded in  current directory
echo Done! Original QCOW2 disk downloaded in  current directory >> instruction.txt
echo Use screen then ./QEMU_CreateVM.sh to start create VM. 
echo Use screen then ./QEMU_CreateVM.sh to start create VM. >> instruction.txt
echo Use screen then ./QEMU_StartVM.sh to start VM if it shutdown. 
echo Use screen then ./QEMU_StartVM.sh to start VM if it shutdown. >> instruction.txt
echo Use screen then ./QEMU_KillVM.sh to kill VM process. 
echo Use screen then ./QEMU_KillVM.sh to kill VM process. >> instruction.txt
echo Use screen then ./QEMU_DeleteVM.sh to delete VM disk. 
echo Use screen then ./QEMU_DeleteVM.sh to delete VM disk. >> instruction.txt
echo RDP User: Administrator
echo RDP User: Administrator >> instruction.txt
echo RDP Password: Thuonghai001
echo RDP Password: Thuonghai001 >> instruction.txt
echo Intruction also save in instruction.txt
echo Intruction also save in instruction.txt >> instruction.txt
fi
