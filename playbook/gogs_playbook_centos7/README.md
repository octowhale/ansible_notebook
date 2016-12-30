# gogs installation on CentOS 7

Install an git management software on CentOS 7

[ gogs.io](https://gogs.io)

## configure your paraments

go into the vars directory and configure your paraments for the variables 

## configure hosts

open the hosts file and set your mysql and gogs srever info

## run command

```bash
ansible-playbook -i hosts main.yml
```

## some problems

due to some unknown problems. the gogs command **can not** run at backgroud as a daemon process.

+ when I use `command` module as `command: chdir={{ gogs_dir }} ./gogs web &`; the ansible controller can not close the running tips.
  + only to `ctrl+c` can exit and remote system will keep the gogs process.

+ when I use a shell `start-gogs.sh` to start gogs. the gogs process will be closed after the `start-gogs.sh` script runs out in remote system.
