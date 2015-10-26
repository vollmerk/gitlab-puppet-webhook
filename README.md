#### gitlab-webhook-puppet
This hook is used to update a puppet environment after receiving a 'push' notification from gitlab
it attempts to handle branches in a way that allows you not only to create/destroy environments
based on user but also branches. This script will by default run as a daemon and disconnect from 
the terminal. You can use the included startup scripts to add it to systemd or init.d

#### Required Modules
Almost all imported modules should be part of the core Python 2.7 install, the following additional modules
may need to be installed

 * python-daemon


