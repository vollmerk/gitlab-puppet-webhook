### Using the systemctl sergice file
This assumes that you have installed it in the default location
if you haven't you will need to modify the systemd.conf and the
.service file as well to correct the paths

* cp gitlab-puppet-webhook.service /etc/systemd/system
* systemctl enable gitlab-puppet-webhook
* systemctl start gitlab-puppet-webhook

