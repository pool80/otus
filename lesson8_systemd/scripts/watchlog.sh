#!/usr/bin/env bash

cp /vagrant/etc/sysconfig/watchlog /etc/sysconfig/watchlog 
cp /vagrant/var/log/watchlog.log /var/log/watchlog.log
cp /vagrant/opt/watchlog.sh /opt/watchlog.sh
chmod +x /opt/watchlog.sh
cp /vagrant/etc/systemd/system/watchlog.service /etc/systemd/system/watchlog.service
cp /vagrant/etc/systemd/system/watchlog.timer /etc/systemd/system/watchlog.timer
systemctl start watchlog.service
systemctl start watchlog.timer