Gitlab Puppet Webhook
=======

An open source gitlab hook used to update puppet environments using r10k with
legacy support for a single repo after receiving a gitlab push notification. 

---
#### Concept
This application expects you to be using R10K to sync your puppet environments.
It receives a Gitlab webhook post and acts on the relevant R10K environment(s)
as well as looking for commit messages which may relate to [Footprints](http://www.bmcsoftware.ca/it-solutions/footprints-service-core.html) ticketing
system or the [OTRS](https://www.otrs.com/) ticketing system and attempting to update
the tickets based on the commit message. 

This application also helps you transition from a monolithic repo to the R10K 
module profile/role methodology by supporting a 'legacy' repo that is checked out
into a defined directory within the environment when it's update. So that you can
smoothly transition from one to the other. 

Environments are based on branch name, however in legacy mode the 'production' branch
of the legacy environment is always pulled regardless of committed branch. 

Operations are all logged to /var/log/webhook-puppet.log by default. In order for
this to work the user that is running the HTTP server must have its SSH Key listed
as a 'deploy' key on all of the repos that it will need to clone, and must have
SSL certificates. 

---
#### REPO mode **NOT COMPATIBLE WITH R10K**
In `REPO` mode the expectation is you have a production repo (group owned repo) and
the developers have forked the repo into their own namespace (username)/(repo). When
a git PUSH happens the webhook will check for a directory within your puppet environment
path that matches the namespace of the repo (username). If the namespace matches the 
configured production env it will look for a `production` environment. 

EXAMPLE - Repo: vollmerk/puppet Branch: Incident-4231

The script will do the following

```
if /etc/puppet/environments/vollmerk exists then
  git checkout Incident-4231`
  git pull
else
  git clone -b Incident-4231 [SSH] /etc/puppet/environments/vollmerk
```

---
#### Branch mode 
In `BRANCH` mode the expectation is there is a single repo (group owned) and
the developers do all of their work in branches. When a git PUSH happens the webhook
will check for a directory within your puppet environment path that matches the
name of the branch. If the branch name matches the configured production env it will look for 
a `production` environment. 

EXAMPLE - Repo: sysadmin/puppet Branch: Incident4231

This method uses R10K to deploy and maintain the code bases, R10K will be triggered via the R10K command as configured

---
#### E-mail to Ticket system support
  The webhook can cause specially formatted e-mails to be sent to the configured location
  currently Footprints is the only ticketing system supported, with full OTRS support coming soon. 
  
  Relevent configuration options are as follows

  [email] method - Determines when e-mail's are sent to the ticket system
  [email] from - the FROM: address for e-mails

  Footprints related configuration options

  [footprints] project - Workspace # in footprints
  [footprints] to - the TO: address for e-mails
  [footprints] closed_status - Status that tickets should be set to if "FIX #[TICKETID]" is found in commit message

  OTRS configuration settings are listed under [otrs]

---
#### gitlab-puppet-webhook
  Starts up a proper linux Daemon that is listening on TCP 7010 for incoming
  Gitlab JSON. Can be started and stopped with the included startup scripts

#### Required Modules
  Almost all imported modules should be part of the core Python 2.7 install, the following additional modules
  may need to be installed

 * python-daemon
 * slackweb


#### Installing on Centos6

  `yum -y install python-pip`

  `pip install --upgrade python-daemon`

#### Installing with Puppet

  Use the Puppetforge Module vollmerk/gitlabr10khook https://forge.puppet.com/vollmerk/gitlabr10khook/readme

  `mod 'vollmerk-gitlabr10khook'`

  In your Puppetfile

#### Startup Scripts
  Currently only SysVinitD scripts are included, you will need to modify the path to your script
  before the init.d script will work properly
