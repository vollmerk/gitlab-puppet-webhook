Gitlab Puppet Webhook
=======

An open source gitlab hook used to update puppet environments pulled from a
single repo after receiving a gitlab push notification. This is a stop-gap
measure before I'm able move to something like r10k

---
#### Concept
This script expects you to have all of your puppet manifests located in a single
repo, which is then forked or branched by the developers of your manifests. 
When a user push's to the configured project the script will check to see if 
there is an existing git repo clone in the configured puppet environment 
location. If there isn't it will clone the repo. If there is it will do a git pull. 

Operations are all logged to /var/log/webhook-puppet.log by default. In order for
this to work the user that is running the HTTP server must have its SSH Key listed
as a 'deploy' key on all of the repos that it will need to clone. 

---
#### REPO mode
In `REPO` mode the expectation is you have a production repo (group owned repo) and
the developers have forked the repo into their own namespace (username)/(repo). When
a git PUSH happens the webhook will check for a directory within your puppet environment
path that matches the namespace of the repo (username). If the namespace matches the 
configured production env it will look for a `production` environment. 

EXAMPLE - Repo: vollmerk/puppet Branch: Incident-4231

The script will do the following

`
if /etc/puppet/environments/vollmerk exists then
 git checkout Incident-4231`
 git pull
else
 git clone -b Incident-4231 [SSH] /etc/puppet/environments/vollmerk
`

---
#### Branch mode
In `BRANCH` mode the expectation is there is a single repo (group owned) and
the developers do all of their work in branches. When a git PUSH happens the webhook
will check for a directory within your puppet environment path that matches the
name of the branch. If the branch name matches the configured production env it will look for 
a `production` environment. 

EXAMPLE - Repo: sysadmin/puppet Branch: Incident4231

The script will do the following
`if /etc/puppet/environments/Incident4231 exists then`
`git checkout Incident4231`
`git pull`
`else`
`git clone -b Incident4231 [SSH] /etc/puppet/environments/Incident4231`

---
#### gitlab-puppet-webhook
  Starts up a proper linux Daemon that is listening on TCP 7010 for incoming
  Gitlab JSON. Can be started and stopped with the included startup scripts

#### Required Modules
  Almost all imported modules should be part of the core Python 2.7 install, the following additional modules
  may need to be installed

 * python-daemon


#### Installing on Centos6

  yum -y install python-pip
  pip install --upgrade python-daemon

#### Using Puppet Installer

  Look at /installer/README.md for instructions on using the provided puppet installer

#### Startup Scripts
  Currently only SysVinitD scripts are included, you will need to modify the path to your script
  before the init.d script will work properly
