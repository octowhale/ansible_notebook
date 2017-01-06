# ע������

�ο� [defaults/main.yml]

```yaml
# ��������
# �� yaml �﷨��, `-` ��ʾָ������һ���б��ʽ, ���ֵ�� key ������ʱ����������.
# 
# --------------------------------
# ���µ�����, 
# server �� file_name λ����ͬ�㼶
# --------------------------------
# - server:
#   file_name: site3
#   listen: 10101
#   server_name: nginx_playbook
#   root: "/tmp/site3"
```

## �ֵ�д��

��������д���ȼ�

�ο� [main.yml]

```yaml
# 01 ����д��
file: path=/etc/nginx/{{ item }} state=directory owner=root group=root mode=0755

# 02 ����д��
file: >
      path=/etc/nginx/{{ item }} 
      state=directory 
      owner=root 
      group=root 
      mode=0755
      
# 03 yaml �﷨
file:
  path: "/etc/nginx/{{ item }}"
  state: directory 
  owner: root 
  group: root 
  mode: 0755
```

## ��������

�ο� [main.yml]

```yaml
# ʹ�����Ž�����������. ansible 2.2.0.0
vars:
  redhat_pkg:
  - nginx
  - python
tasks:
  - name: install python
    # yum: name=python
    yum: name={{ item }} state=present
    # githubԭ����������Բ�ͨ��
    # with_items: redhat_pkg  
    # ʹ�����Ž�����������. ansible 2.2.0.0
    with_items: "{{ redhat_pkg }}"
    when: ansible_os_family == "RedHat"
```

## �����ж�

```yaml
# ʹ�� when ���������ж�
# ʹ�� and / or ������������
when: ansible_os_family == "RedHat" and ansible_distribution_major_version == "6"
```

## ʹ�� root �û�

[become.rst](https://github.com/ansible/ansible/blob/0f4ca877ac91aa4cf56103f967afec65cca629e1/docsite/rst/become.rst)

```yaml

# 01 ʹ�� root �û�����
remote_user: root

# 02 ʹ����ͨ�û����Ӳ�ʹ�� sudo
# REMOTE_USER ��Ҫ���� sudo Ȩ��
# ���ڽ���ʹ�� sudo ģ��, ʹ�� become ģ�����
remote_user: REMOTE_USER
become: True
# sudo: True

# 03 �л��������û�ִ��
become_user: BECOME_USER

```

## jekyll2 �﷨

[templates/site.j2]

```jinja

server {

# ����һ�� j2 �﷨�� vhost ģ���ļ�
# ������ defaults/main.yml


# ����� item ��Ӧ nginx_sites, ͨ�� tasks ����
{% if nginx_separate_logs_per_site == True %}
# ��� nginx_separate_logs_per_site ����Ϊ��, �ⵥ��Ϊ vhost ������־�ļ�
	access_log {{ nginx_log_dir}}/{{ item.server.server_name}}-{{ nginx_access_log_name}};
	error_log {{ nginx_log_dir}}/{{ item.server.server_name}}-{{ nginx_error_log_name}};
{% endif %}


# ��һ��д��
{% for k,v in item.server.iteritems() %}
# ���� nginx_sites.server �µ� key-value ����ֵ�� k,v
{% if k.find('location') == -1 and k != 'file_name' %}
# ��� k ��û�� location �ֶ��� k ��ֵ��Ϊ file_name
{{ k }} {{ v }};
{% endif %}
{% endfor %} 


# �ڶ���д��
{% for k,v in item.server.iteritems() if k.find('location') != -1 %}
# ���� nginx_sites.server �µ� key-value ����ֵ�� k,v �� ��� k �а��� location �ֶ�
  location {{ v.name }} {
{% for x,y in v.iteritems() if x != 'name' %} 
      {{ x }} {{ y }};
{% endfor %}
  }
{% endfor %}
}

```