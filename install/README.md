### gitlab-puppet-webhook Puppet installer

This directory contains a puppet based installer for thie webhook. In order to use it please copy `settings.pp.dist` to `settings.pp` and
update it accordingly. Then run `puppet apply install.pp --modulepath=./modules`
