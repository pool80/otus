#!/usr/bin/env bash

cp /vagrant/etc/sysconfig/spawn-fcgi /etc/sysconfig/spawn-fcgi
cp /vagrant/etc/systemd/system/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service
systemctl daemon-reload
systemctl start spawn-fcgi