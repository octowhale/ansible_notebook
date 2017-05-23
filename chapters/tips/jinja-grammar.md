# jinja 语法

```jinja

server {

# 这是一个 j2 语法的 vhost 模板文件
# 变量在 defaults/main.yml


# 这里的 item 对应 nginx_sites, 通过 tasks 传入
{% if nginx_separate_logs_per_site == True %}
# 如果 nginx_separate_logs_per_site 变量为真, 这单独为 vhost 配置日志文件
	access_log {{ nginx_log_dir}}/{{ item.server.server_name}}-{{ nginx_access_log_name}};
	error_log {{ nginx_log_dir}}/{{ item.server.server_name}}-{{ nginx_error_log_name}};
{% endif %}


# 第一种写法
{% for k,v in item.server.iteritems() %}
# 遍历 nginx_sites.server 下的 key-value 并赋值给 k,v
{% if k.find('location') == -1 and k != 'file_name' %}
# 如果 k 中没有 location 字段且 k 的值不为 file_name
{{ k }} {{ v }};
{% endif %}
{% endfor %} 


# 第二种写法
{% for k,v in item.server.iteritems() if k.find('location') != -1 %}
# 遍历 nginx_sites.server 下的 key-value 并赋值给 k,v 且 如果 k 中包含 location 字段
  location {{ v.name }} {
{% for x,y in v.iteritems() if x != 'name' %} 
      {{ x }} {{ y }};
{% endfor %}
  }
{% endfor %}
}

```