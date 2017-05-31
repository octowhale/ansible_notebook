# with_items 循环引用 

`with_items` 并不是一个模块，但是与模块平级。

在 ansible 中，可是使用 `with_items` 进行循环处理。这是一个非常方便的功能，可以让你少些很多个 task。
但是，在使用 `with_items` 的时候需要注意一些小细节。

## 字符串变量引用

在引用变量的时候，要使用引号 `"{{ item }}"`，虽然没有说必须使用引号括起来，但是大部分常见变量报错，可以通过使用引号解决。  另外，官方也说，在使用『以变量开头』的值时，使用引号括起来 。`Always quote template expression brackets when they start a value.`

例如，下面是一个安装软件的 yaml 文件。

```yaml

- name: install some required packages 
  yum: 
    name: "{{ item }}"
    state: latest
  with_items:
    - lrzsz
    - python
    - python-devel
    - ntpdate
    - nmap

```


## 字典变量引用

字典变量引用常见于 `file`, `copy`, `template` 等模块。这类模块经常需要同时指定 src 和 dest 的值。

在使用的过程中，有几个注意事项。

+ 花括号：字典的语法，是一组花括号 `{}`。 两组花括号 `{{}}` 是变量。当使用两组花括号的时候，报错会输出变量相关的错误信息。但是别忘记检查是否字典语法使用错误
+ 空格: 在字典中，两个字段中间需要使用逗号和空格 `, ` 进行分割。如果缺少逗号，会报错。
+ 变量的引用："{{ items.src }}", "{{ items.dest }}"。 `src,dest` 就是字典里面的列名。虽然没有要求必须使用这两只值，但习惯上还是这样写。

```yaml
- name: push monitor slave files
  copy:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: zabbix
    group: zabbix
    mode: 0644
  with_items:
    - { src: "monitor_slave/lld-mysqls.sh", dest: "/usr/local/zabbix/scripts/lld-mysqls.sh" }
    - { src: "monitor_slave/generate_slaveport.sh", dest: "/usr/local/zabbix/scripts/generate_slaveport.sh" }
    - { src: "monitor_slave/userparameter_slavestats.conf", dest: "/usr/local/zabbix/etc/zabbix_agentd.conf.d/userparameter_slavestats.conf" }
  notify: 
    - restart zabbix_agentd service
```

下面就是将字典语法写成变量语法是的报错信息

```bash
fatal: [123.206.57.169]: FAILED! => {"failed": true, "reason": "Syntax Error while loading YAML.


The error appears to have been in '/path/2/playbook_roles/sync_zbx_scripts/tasks/mysql_slave_monitor.yaml': line 16, column 8, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

  with_items:
    - {{ src: \"monitor_slave/check_slave_status.sh.j2\", dest: \"/usr/local/zabbix/scripts/check_slave_status.sh\" }}
       ^ here
We could be wrong, but this one looks like it might be an issue with
missing quotes.  Always quote template expression brackets when they
start a value. For instance:

    with_items:
      - {{ foo }}

Should be written as:

    with_items:
      - \"{{ foo }}\"
"}
```
