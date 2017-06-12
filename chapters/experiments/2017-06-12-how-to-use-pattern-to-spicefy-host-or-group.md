# 使用正则表达式标识主机
# how to use ansible pattern 

> http://docs.ansible.com/ansible/intro_patterns.html


## 总结

### 特殊符号的含义

+ `:` : 并集 OR
+ `&` : 交集 AND
+ `!` : 非   NOT


### pattern 的位置

正则 `pattern` 标识主机或主机组时，可以用在任何标识主机的地方。如下面 `group_or_host` 的位置
+ 命令行中：
  + `ansible -i pattern.hosts group_or_host -m ping `
  + `--limit=group_or_host`
+ playbook 中：
  + `hosts: group_or_host`
  
### 特殊符号的转义

由于 `&` 与 `!` 在 linux 命令行中有特殊含义。因此，在使用正则表达式的时候，需要对这两个符号做特殊处理。
+ 在不引用引号或使用双引号的时候，需要进行转移
  + `grp_02:\&grp_01`
  + `"grp_02:\&grp_01"`
+ 在使用单引号的时候，不能再转义
  + `'grp_02:&grp_01'`
  + `'grp_02:!grp_01'`
  + `'grp_02:\!grp_01'`   # 错误用法


## 正则在 playbook 中的位置

```yaml
---

- name: ping host
  
  gather_facts: false
  
  # ansible -i pattern.hosts pingpong.yaml  # ok 
  hosts: all
  # ansible -i pattern.hosts pingpong.yaml  # ok 
  hosts: grp_02:!grp_01  
  # ansible -i pattern.hosts pingpong.yaml  # ok 
  hosts: 'grp_02:&grp_01' 
  
  # ansible -i pattern.hosts pingpong.yaml -e "gs_name=svr1918"    # ok 
  hosts: grp_02:!{{ gs_name }}  
  hosts: "grp_02:!{{ gs_name }}"  
  
  tasks:
  
    - name: ping pong 
      ping:

```


## pattern 在 commandline 中的位置

```bash
ansible -i pattern.hosts all -m ping
ansible -i pattern.hosts grp_01 -m ping
ansible -i pattern.hosts 'grp_01:grp_02' -m ping
ansible -i pattern.hosts 'grp_01:&grp_02' -m ping
ansible -i pattern.hosts 'grp_01:!grp_02' -m ping
ansible -i pattern.hosts 'grp_01:!svr1916' -m ping
ansible -i pattern.hosts all -m ping --limit=svr1916
ansible -i pattern.hosts all -m ping --limit='grp_01:!svr1916'
ansible -i pattern.hosts all -m ping --limit='all:!svr1916'
ansible -i pattern.hosts all -m ping --limit='all:!svr1916:svr1917'
ansible -i pattern.hosts all -m ping --limit='all:!svr1916:!svr1917'
```

### 特殊符号说明

The following patterns address one or more groups. Groups separated by a colon indicate an “OR” configuration. This means the host may be in either one group or the other:

`webservers:dbservers`

You can exclude groups as well, for instance, all machines must be in the group webservers but not in the group phoenix:

`webservers:!phoenix`

You can also specify the intersection of two groups. This would mean the hosts must be in the group webservers and the host must also be in the group staging:

`webservers:&staging`

You can do combinations:

`webservers:dbservers:&staging:!phoenix`

The above configuration means “all machines in the groups ‘webservers’ and ‘dbservers’ are to be managed if they are in the group ‘staging’ also, but the machines are not to be managed if they are in the group ‘phoenix’ … whew!

You can also use variables if you want to pass some group specifiers via the “-e” argument to ansible-playbook, but this is uncommonly used:

`webservers:!{{excluded}}:&{{required}}`

You also don’t have to manage by strictly defined groups. Individual host names, IPs and groups, can also be referenced using **wildcards**

```
*.example.com
*.com
```

## 测试用例
  
```ini
# $ cat pattern.hosts 
[grp_01]
svr1916    serverid=1916    ansible_user=user01    ansible_host=xxx.xx.xx.xxx
svr1917    serverid=1917    ansible_user=user01    ansible_host=xxx.xx.xx.xxx
[grp_02]
svr1917    serverid=1917    ansible_user=user01    ansible_host=xxx.xx.xx.xxx
svr1918    serverid=1918    ansible_user=user01    ansible_host=xxx.xx.xx.xxx

# 错误语法
# [grp_quote_child:children]
# 'grp_02:&grp_01'

# [grp_no_quote_child:children]
# grp_02:!grp_01


# 不能识别主机
# [grp_quote]
# 'grp_02:&grp_01'

# [grp_no_quote]
# grp_02:!grp_01
```

```bash
$ ansible -i pattern.hosts all -m ping
svr1917 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
svr1918 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
svr1916 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
grp_02:!grp_01 | UNREACHABLE! => {
    "changed": false, 
    "msg": "Failed to connect to the host via ssh.", 
    "unreachable": true
}
grp_02:&grp_01 | UNREACHABLE! => {
    "changed": false, 
    "msg": "Failed to connect to the host via ssh.", 
    "unreachable": true
}
```


## pattern 的错误

```

$ ansible-playbook -i pattern.hosts  pingpong.yaml --limit=grp_02:!grp_01
-bash: !grp_01: event not found

$ ansible-playbook -i pattern.hosts  pingpong.yaml --limit=grp_02:&grp_01
[1] 13512
-bash: grp_01: command not found
[user01@localhost tmp]$ 
PLAY [ping host] ***************************************************************

TASK [ping pong] ***************************************************************
ok: [svr1917]
ok: [svr1918]

PLAY RECAP *********************************************************************
svr1917                     : ok=1    changed=0    unreachable=0    failed=0   
svr1918                     : ok=1    changed=0    unreachable=0    failed=0   


[1]+  Done                    ansible-playbook -i pattern.hosts pingpong.yaml --limit=grp_02:

```

## pattern 与 转义字符

```bash
$ ansible -i pattern.hosts all -m ping --limit=grp_02:\&grp_01
svr1917 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}

$ ansible -i pattern.hosts all -m ping --limit=grp_02:\!grp_01
svr1918 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}


$ ansible-playbook -i pattern.hosts  pingpong.yaml --limit=grp_02:\&grp_01

PLAY [ping host] ***************************************************************

TASK [ping pong] ***************************************************************
ok: [svr1917]

PLAY RECAP *********************************************************************
svr1917                     : ok=1    changed=0    unreachable=0    failed=0   

$ ansible-playbook -i pattern.hosts  pingpong.yaml --limit=grp_02:\!grp_01

PLAY [ping host] ***************************************************************

TASK [ping pong] ***************************************************************
ok: [svr1918]

PLAY RECAP *********************************************************************
svr1918                     : ok=1    changed=0    unreachable=0    failed=0  


```

## pattern 与引号

由于『双引号 `"` 』是弱引用，因此在使用双引号引用正则的时候。如果不对 `!` 和 `&` 进行转移，那么和使用引号效果一样

因此建议，在使用正则的时候，使用『单引号 `'` 』。


###  pattern 与 单引号

```bash
$ ansible -i pattern.hosts 'grp_02:!grp_01' -m ping
svr1918 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
$ ansible -i pattern.hosts 'grp_02:&grp_01' -m ping
svr1917 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}

# 使用了单引号之后，不能再进行转义
$ ansible -i pattern.hosts 'grp_01:\!grp_02' -m ping
svr1917 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
svr1916 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
$ ansible -i pattern.hosts 'grp_01:!grp_02' -m ping
svr1916 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

###  pattern 与 双引号

```bash

$ ansible-playbook -i pattern.hosts  pingpong.yaml --limit="grp_02:\&grp_01"

PLAY [ping host] ***************************************************************

TASK [ping pong] ***************************************************************
ok: [svr1918]

PLAY RECAP *********************************************************************
svr1918                     : ok=1    changed=0    unreachable=0    failed=0   

$ ansible-playbook -i pattern.hosts  pingpong.yaml --limit="grp_02:\!grp_01"

PLAY [ping host] ***************************************************************

TASK [ping pong] ***************************************************************
ok: [svr1918]

PLAY RECAP *********************************************************************
svr1918                     : ok=1    changed=0    unreachable=0    failed=0   


```

