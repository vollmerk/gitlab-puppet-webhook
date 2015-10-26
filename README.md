Gitlab Puppet Webhook
=======

An open source gitlab hook used to update puppet environments pulled from a
single repo after receiving a gitlab push notification. This is a stop-gap
measure before I'm able move to something like r10k

#### gitlab-puppet-webhook
  Starts up an HTTP server listening on a default of TCP 7010

#### Required Modules
  Almost all imported modules should be part of the core Python 2.7 install, the following additional modules
  may need to be installed

 * python-daemon


