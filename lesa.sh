#!/bin/bash

echo '======================================================='
echo '    __    ___________ ___ '
echo '   / /   / ____/ ___//   |'
echo '  / /   / __/  \__ \/ /| |'
echo ' / /___/ /___ ___/ / ___ |'
echo '/_____/_____//____/_/  |_|' 
echo ''                  
echo '- Linux Endpoint Security Assessment [LESA] - '
echo ''
echo 'Please remember to enable unlimited scrollback in your terminal'
echo '======================================================='
printf "\n"
echo 'LESA works with either Debian-based systems or Fedora-based systems.'
printf "\n"
printf "\n"
echo '1. Debian family  2. Fedora family  3. Type 3 to skip update and service list [1/2/3]'
read answer 

if [ $answer == 1 ] 
then
	sudo apt-get update
	printf "\n"
	sudo apt-get upgrade 
	printf "\n"
	sudo apt-get clean
	printf "\n"
	echo '--------------------------------------------------'
	printf "\n"
	echo 'List of running services'
	echo '--------------------------------------------------'
	sudo service --status-all
elif [ $answer == 2 ]
then
	sudo dnf update
	printf "\n"
	sudo dnf upgrade
	printf "\n"
	echo '--------------------------------------------------'
	printf "\n"
	echo 'List of running services'
	printf "------------------------"
	sudo chkconfig --list
	echo 'Use sudo systemctl list-unit-files to get a more in-depth view of the running services'
else
	echo 'Skipping...'
	read -p 'Press [Enter] key to start the script'
fi
echo '--------------------------------------------------'
printf "\n"	
	
	


echo 'List of failed login attempts'
printf "\n"
faillog -a
echo '--------------------------------------------------'
printf "\n"

echo 'List of accounts with no password'
printf "\n"
sudo awk -F: '($2 == "") {print}' /etc/shadow
echo '--------------------------------------------------'
printf "\n"

echo 'List of non-root accounts that have UID set to 0'
printf "\n"
awk -F: '($3 == "0") {print}' /etc/passwd
echo '--------------------------------------------------'
printf "\n"

echo 'Listening network ports'
printf "\n"
netstat -tulpn
echo '--------------------------------------------------'
printf "\n"

echo 'Netstat Output - (netstat -ano)'
printf "\n"
netstat -ano
echo '--------------------------------------------------'
printf "\n"

echo 'Current IPTables'
printf "\n"
sudo iptables -L
echo '--------------------------------------------------'
printf "\n"

echo 'List of all files with SUID Set'
printf "\n"
find / -perm /4000 
echo '--------------------------------------------------'
printf "\n"

echo 'List of all files with SGID Set'
printf "\n"
find / -perm /2000 
echo '--------------------------------------------------'
printf "\n"

echo 'List of world-writable files'
printf "\n"
find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print
echo '--------------------------------------------------'
printf "\n"

echo 'List of no-owner files'
printf "\n"
find / -nouser
echo '--------------------------------------------------'
printf "\n"

echo 'List of ungrouped files/directories'
printf "\n"
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup
echo '--------------------------------------------------'
printf "\n"

echo 'List of installed packages (head and tail of list)'
printf "\n"
dpkg --list | head & dpkg --list | tail
echo '--------------------------------------------------'
printf "\n"

echo 'Current running processes'
printf "\n"
ps -e
echo '--------------------------------------------------'
printf "\n"

echo 'Peak into the SSH config'
printf "\n"
cat /etc/ssh/sshd_config | grep 'PermitRoot'
cat /etc/ssh/sshd_config | grep 'X11'
cat /etc/ssh/sshd_config | grep 'PermitEmptyPasswords'
cat /etc/ssh/sshd_config | grep 'Port'
cat /etc/ssh/sshd_config | grep 'AllowUsers'
cat /etc/ssh/sshd_config | grep 'Protocol'
echo '--------------------------------------------------'
echo ''


if [ $answer == 2 ]
then 
	echo 'SELinux Configuartions'
	printf "\n"
	cat /etc/selinux/config
	echo '--------------------------------------------------'
fi

printf "\n"

echo 'Cron.Deny'
printf "\n"
sudo cat /etc/cron.deny 
echo '--------------------------------------------------'
printf "\n"

echo 'View' $USER 'aging information'
printf "\n"
sudo chage -l $USER
echo '--------------------------------------------------'
printf "\n"

echo 'Tail of system logs'
printf "\n"
cat /var/log/syslog | tail
printf "\n"
cat /var/log/message | tail
echo '--------------------------------------------------'
printf "\n"

echo 'Tail of authentication logs'
printf "\n"
cat /var/log/auth.log | tail
echo '--------------------------------------------------'
printf "\n"

echo 'User Umask (027 or more restrictive)'
printf "\n"
grep "umask" /etc/bashrc
grep "umask" /etc/profile /etc/profile.d/*.sh
echo '--------------------------------------------------'
printf "\n"

echo 'Restriction of su command'
printf "\n"
grep pam_wheel.so /etc/pam.d/su
grep wheel /etc/group
echo '--------------------------------------------------'
printf "\n"

echo 'Permissions on /etc/passwd , /etc/shadow , /etc/group'
printf "\n"
stat /etc/passwd
stat /etc/shadow
stat /etc/group
echo '--------------------------------------------------'
printf "\n"

echo 'Accounts with no password'
printf "\n"
sudo awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow
echo '--------------------------------------------------'
printf "\n"

if [ $answer == 1 ]
then	
		sudo apt-get install chkrootkit -y
		sudo chkrootkit 
		echo '--------------------------------------------------'
elif [ $answer == 2 ]
then
		sudo dnf install chkrootkit
		sudo chkrootkit
		echo '--------------------------------------------------'
elif [ $answer == 3 ]
then
		printf "You need to manually install Chkrootkit...\n"
fi

printf "\n"

if [ $answer == 1 ]
then	
		sudo apt-get install clamav -y
		sudo freshclam 
		echo 'Scanning the home directory ... will take a few minutes'
		printf "\n"
		sudo clamscan -r --bell -i /home
		echo '--------------------------------------------------'
elif [ $answer == 2 ]
then
		sudo dnf install clamav -y
		printf "\n"
		sudo freshclam
		printf "\n"
		echo 'Scanning the home directory ... will take a few minutes'
		sudo clamscan -r --bell -i /home
		echo '--------------------------------------------------'
elif [ $answer == 3 ]
then
	printf "You need to manually install ClamAV...\n"
fi


sleep 3s
echo '=============================================================='
printf "Dont forget some of these common security practices \n\n"
printf "Remove any unused programs/services/applications/etc  \n"
printf "Disable IPv6 if youre not using it. \n"
printf "Ignore ICMP or broadcast requests if possible  \n"
printf "Possibly disable CTRL+ALT+DEL "
printf "Enforce strong passwords and two-step authentication where possible \n "
printf "Restrict certain users to cron and other sensitive resources  \n"
printf "Dont forget to consider tools like Fail2Ban, LogWatch, TripWire, etc. \n"
printf "and many more... \n"
echo '=============================================================='
