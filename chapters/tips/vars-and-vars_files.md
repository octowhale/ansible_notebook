# 变量文件

通过 `vars_files` 指定变量文件位置

```
- name: install MySQL57
  hosts: mysql-server
  remote_user: root
  
  vars_files:
    - vars/dbserver.yml
    
  roles:
    - db
```