#!/bin/bash

#server test
#CIT-470 Advanced Network & System Administration
#Spring 2020
#Group 3 Project 3
#Kevin Irwin, Garrett Turin, Thomas Ryan

echo "Installing stress" &&
yum -y install stress &&
echo "Let's break some stuff" &&

#Test with stress
echo "Breaking the CPU"
stress --vm-bytes 256MB --cpu 100 --timeout 60s >& 1 >> /var/log/client-test.log
monit summary | grep localhost
echo "Maybe now the fans will be quieter"

#Test hard drive
echo "Filling up the disk"
dd if=/dev/zero of=/dev/diskhog bs=1M count=100000 >& 1 >> /var/log/client-test.log
sleep 60
monit summary | grep Home
monit summary | grep Root
monit summary | grep Var
rm /dev/diskhog -f >& 1 >> /var/log/client-test.log
echo "Disk should be normal now"

#Test syslog
echo "Breaking syslog..."
systemctl stop rsyslog
sleep 120
monit summary | grep rsyslog

#Test SSH
echo "Breaking SSH..."
systemctl stop sshd
sleep 120
monit summary | grep ssh
echo "SSH should be back"

#Test NFS-Client
echo "Breaking NFS"
systemctl stop nfs
sleep 120
monit summary | grep nfs
echo "NFS should be back"

#Test LDAP-Client
echo "Breaking LDAP client..."
systemctl stop nslcd
sleep 120
monit summary | grep nslcd
echo "LDAP should be back"

#Test Apache
echo "Testing Apache..."
systemctl stop httpd
sleep 120
monit summary | grep httpd
echo "The Apache testing is complete!"
