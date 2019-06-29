#!/usr/bin/env bash

cp /vagrant/etc/systemd/system/httpd@.service /etc/systemd/system/httpd@.service
cp /vagrant/etc/sysconfig/httpd-first /etc/sysconfig/httpd-first
cp /vagrant/etc/sysconfig/httpd-second /etc/sysconfig/httpd-second
cp /vagrant/etc/httpd/conf/first.conf /etc/httpd/conf/first.conf
cp /vagrant/etc/httpd/conf/second.conf /etc/httpd/conf/second.conf
systemctl start httpd@first
systemctl start httpd@second