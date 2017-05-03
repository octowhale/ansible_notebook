---
layout: post
title: "使用 ansible 修改 sysctl 的值"
categories: [ansible]
description: "使用 ansible 修改 sysctl 的值"
keywords: playbook, tips
---

```yaml
---

# http://docs.ansible.com/ansible/sysctl_module.html
# http://docs.ansible.com/ansible/replace_module.html

# 更新 net.ipv4.tcp_keepalive_time 的值
# update the value net.ipv4.tcp_keepalive_time to 120 
# 虽然执行 sysctl 模块时返归结果可能是 failed，但是实际修改的值得会生效，并写入 sysctl.conf 文件，如果不是failed内容中的信息。
# 
#
# 如果使用非默认路径的 sysctl.conf 
# 可以使用 replace 模块
# 

# http://man.linuxde.net/sysctl
# http://www.centoscn.com/CentOS/config/2015/0618/5685.html



- name: set net.ipv4.tcp_keepalive_time = 120 
  hosts: all

  tasks:
      
    - name: update value to 120 via sysctl module
      sysctl:
        name: net.ipv4.tcp_keepalive_time
        value: 120
        state: present
        # ignore_errors: yes
        # ignore_errors 只能用在command,shell 等模块后面，报错提示中会注明
        
    # - name: update value to 120 via replace module
      # replace:
        # dest: /etc/sysctl.conf
        # regexp: 'net.ipv4.tcp_keepalive_time = .*'
        # replace: 'net.ipv4.tcp_keepalive_time = 1200'
        # validate: 'sysctl -p %s'
      
    # - name: reload sysctl
      # command: 'sysctl -p '
      # ignore_errors: yes
      
```