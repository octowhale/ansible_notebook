# 使用 root 用户

[become.rst](https://github.com/ansible/ansible/blob/0f4ca877ac91aa4cf56103f967afec65cca629e1/docsite/rst/become.rst)

```yaml

# 01 使用 root 用户连接
remote_user: root

# 02 使用普通用户连接并使用 sudo
# REMOTE_USER 需要具有 sudo 权限
# 不在建议使用 sudo 模块, 使用 become 模块替代
remote_user: REMOTE_USER
become: True
# sudo: True

# 03 切换成其他用户执行
become_user: BECOME_USER

```
