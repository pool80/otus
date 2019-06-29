#!/usr/bin/env bash

yum makecache
yum install -y epel-release
yum makecache
yum install -y python34-pip
pip3 install asciinema
#asciinema auth
mkdir -p /root/.config/asciinema/
echo 9cf88e15-33f3-4706-a75e-b1819236dd33 >> /root/.config/asciinema/install-id