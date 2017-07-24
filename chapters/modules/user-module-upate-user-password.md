# 使用 user 模块创建用户和修改密码

在 ansible 中，提供了一个 [ user 模块 ](http://docs.ansible.com/ansible/latest/user_module.html) 用于管理用户信息。


## 新建用户

```yaml
# Add the user 'johnd' with a specific uid and a primary group of 'admin'
# 新建用户 johnd ，并为其制定一个 uid 并附件到 admin 组。
- user:
    name: johnd
    comment: "John Doe"
    uid: 1040
    group: admin

# Add the user 'james' with a bash shell, appending the group 'admins' and 'developers' to the user's groups
# 新建用 james ，shell 为 bash， 并附加到 admins 组合 developers 组。
- user:
    name: james
    shell: /bin/bash
    groups: admins,developers
    append: yes

# Remove the user 'johnd'
# 删除用户 johnd
- user:
    name: johnd
    state: absent
    remove: yes

# Create a 2048-bit SSH key for user jsmith in ~jsmith/.ssh/id_rsa
# 为用户 jsmith 创建一个秘钥
- user:
    name: jsmith
    generate_ssh_key: yes
    ssh_key_bits: 2048
    ssh_key_file: .ssh/id_rsa

# added a consultant whose account you want to expire
# 创建一个用户 james18 并设置为其设置账户到期时间
- user:
    name: james18
    shell: /bin/zsh
    groups: developers
    expires: 1422403387
```

## 修改用户密码

在 playbook 中，必须使用密文作为 `password` 的值。
生成密文密码的方式一般有一下几种

### 使用 `openssl` 生成密码

```
openssl passwd  -1 "Abc123456"` 
# 使用自己的密码替换 Abc123456。

````

### 使用 python + passlib 生成密码

```
pip install passlib

python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.using(rounds=5000).hash(getpass.getpass())"

```

### 设置登录秘钥与修改密码

```yaml
---

# set authorized_key
# 为目标机用户设置登录秘钥

- name: Set authorized key for user(root) copying it from current user
  authorized_key:
    user: root
    state: present
    key: "{{ lookup('file', lookup('env','HOME') + '/.ssh/id_rsa.pub') }}"

    
# 修改目标机用户密码
- name: change password
  user:
    name: root
    password: $1$xcyZbDXO$pou6NvlbFjMKiDtsstpfR0
    # always : 只要密码不一样，就更新
    update_password: always  
  
    # http://docs.ansible.com/ansible/faq.html#how-do-i-generate-crypted-passwords-for-the-user-module
    # https://my.oschina.net/tacg/blog/660624
    # openssl passwd  -1 "Abc123456"
    # $1$eN0FcgEb$UpVT3PznPdNs4FI2TSapw1
    
```

