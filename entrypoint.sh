#!/bin/bash

# Substitute environment variables in config
cp /etc/onetime/config{,.bak}
envsubst < /etc/onetime/config.bak > /etc/onetime/config

# remove redis password and change to default port
if grep -q "redis://user:CHANGEME@127.0.0.1:7179" /etc/onetime/config; then
  cp /etc/onetime/config{,.bak}
  sed "s/redis:\/\/user:CHANGEME@127\.0\.0\.1:7179/redis:\/\/127\.0\.0\.1:6379/" /etc/onetime/config.bak > /etc/onetime/config
fi

# change default sender name in automated emails
# (even better, create and mount your own email templates at the locations below)
if [[ -n ${OTS_NAME+x} ]]; then
  echo "Setting email sender name to $OTS_NAME"
  sed -i.bak "s/Delano/$OTS_NAME/" /var/lib/onetime/templates/email/password_request.mustache
  sed -i.bak "s/Delano/$OTS_NAME/" /var/lib/onetime/templates/email/welcome.mustache
fi

# start Redis
/etc/init.d/redis-server start

# start OTS
cd /var/lib/onetime && bundle exec thin -e dev -R config.ru -p 7143 start
