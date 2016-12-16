#!/bin/bash
#
# install ansible on CentOS6.8
#

yum -y install https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum clean all
yum -y install ansible
yum -y install gcc gcc-c++ make python-devel  python-setuptools  sshpass

