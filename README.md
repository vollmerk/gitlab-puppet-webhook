Gitlab Puppet Webhook
=======

An open source gitlab hook used to update puppet environments pulled from a
single repo after receiving a gitlab push notification. This is a stop-gap
measure before I'm able move to something like r10k

---
#### Concept
This script expects you to have all of your puppet manifests located in a single
repo, which is then forked by the developers of your manifests. When a user push's
to the configured project the script will check to see if there is an existing
git repo clone in the configured puppet environment location. If there isn't it
will clone the repo. If there is it will do a git pull. 

Operations are all logged to /var/log/webhook-puppet.log by default. In order for
this to work the user that is running the HTTP server must have its SSH Key listed
as a 'deploy' key on all of the repos that it will need to clone. 

---
#### gitlab-puppet-webhook
  Starts up a proper linux Daemon that is listening on TCP 7010 for incoming
  Gitlab JSON. Can be started and stopped with the included startup scripts

#### Required Modules
  Almost all imported modules should be part of the core Python 2.7 install, the following additional modules
  may need to be installed

 * python-daemon

#### Startup Scripts
  Currently only SysVinitD scripts are included, you will need to modify the path to your script
  before the init.d script will work properly
