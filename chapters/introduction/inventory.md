# inventory

```ini
[group_name]
host_alias_name ansible_host=127.0.0.1 ansible_port=22
192.168.1.1     ansible_user=root ansible_password=ROOTPASSWORD

[group_name:vars]
# 组变量
ansible_private_key_file=/root/.ssh/id_rsa

```

## 制定主机信息

```ini
ansible_host=127.0.0.1
ansible_port=22
```

## 指定用户

> 在 ansible `2.4.2.0` 中测试通过

```ini
ansible_user=root
ansible_password=ROOTPASSWORD
ansible_private_key_file=/root/.ssh/id_rsa
```
