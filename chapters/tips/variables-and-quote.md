# 变量与引号

两个变量链接的时候，需要使用双引号括起来。
部分变量（如 url）在使用的时候，可能需要使用双引号括起来。

```
- name: Download gogs package {{ gogs_package_version }}
  # command: wget -c http://7d9nal.com2.z0.glb.qiniucdn.com/gogs_v0.9.113_linux_amd64.tar.gz -O /opt/gogs_v0.9.113_linux_amd64.tar.gz
  # [WARNING]: Consider using get_url or uri module rather than running wget
  get_url: 
    url: "{{ gogs_package_url }}"
    dest: "{{ gogs_package_store_dir }}/{{ gogs_package_version }}"
```

# 变量引用

参考 [main.yml]

```yaml
# 使用引号将变量括起来. ansible 2.2.0.0
vars:
  redhat_pkg:
  - nginx
  - python
tasks:
  - name: install python
    # yum: name=python
    yum: name={{ item }} state=present
    # github原文中这里测试不通过
    # with_items: redhat_pkg  
    # 使用引号将变量括起来. ansible 2.2.0.0
    with_items: "{{ redhat_pkg }}"
    when: ansible_os_family == "RedHat"
```
