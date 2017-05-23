# 字典写法

以下三种写法等价

参考 [main.yml]

```yaml
# 01 单行写法
file: path=/etc/nginx/{{ item }} state=directory owner=root group=root mode=0755

# 02 换行写法
file: >
      path=/etc/nginx/{{ item }} 
      state=directory 
      owner=root 
      group=root 
      mode=0755
      
# 03 yaml 语法
file:
  path: "/etc/nginx/{{ item }}"
  state: directory 
  owner: root 
  group: root 
  mode: 0755
```