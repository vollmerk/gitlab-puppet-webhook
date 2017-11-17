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

Operations are all logged to /var/log/webhook-puppet.log by default. In order for
this to work the user that is running the HTTP server must have its SSH Key listed
as a 'deploy' key on all of the repos that it will need to clone, and must have
SSL certificates. 

If you enable multimaster mode, this python app can attempt to SSH as the user
its running as to the specified servers, and launch R10k on the remote servers
this is a poor mans version of the Puppet Enterprise "Compile Master" functionality
it's not a replacement, but it's good enough for our purposes. 

---
#### Multimaster Support
You can specify a list of comma seperated IP's/DNS names the webhook will attempt to SSH as the user that
it is running as to each server listed and run the same R10k command that it ran on the local server. The
assumption is made that R10k and everything is identical on all servers as there is no way to specify
an alternative command per server. 

This module does not take care of, or account for the requirements of access between the two servers
though it's expected that you would use a passwordless ssh key restricted to the "MoM" ip address and the
exact R10k command. 

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
 * psutil

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
