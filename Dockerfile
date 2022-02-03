# Dockerfile for One-Time Secret
# http://onetimesecret.com

FROM ruby:2.3

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install -y \
    build-essential \
    redis-server \
    gettext-base \
  && rm -rf /var/lib/apt/lists/*

# Download and install OTS version 0.10.x
RUN set -ex && \
  mkdir -p /etc/onetime /var/log/onetime /var/run/onetime /var/lib/onetime && \
  wget https://github.com/onetimesecret/onetimesecret/archive/refs/tags/v0.10.1.tar.gz -O /tmp/ots.tar.gz && \
  tar xzf /tmp/ots.tar.gz -C /var/lib/onetime --strip-components=1 && \
  rm /tmp/ots.tar.gz && \
  cd /var/lib/onetime && \
  bundle install --frozen --deployment --without=dev && \
  cp -R etc/* /etc/onetime/

ADD entrypoint.sh /usr/bin/

# Add default OTP config
ADD config.example /etc/onetime/config

# Override OTP routes and links
ADD routes.example /var/lib/onetime/lib/onetime/app/web/routes
ADD footer.mustache.example /var/lib/onetime/templates/web/footer.mustache

# Append to OTP site CSS
ADD main_append.css /ect/onetime/
RUN cat /ect/onetime/main_append.css >> /var/lib/onetime/public/web/css/main.css

# Append to Redis config
ADD redis_append.conf /ect/onetime/
RUN cat /ect/onetime/redis_append.conf >> /etc/redis/redis.conf

VOLUME /etc/onetime /var/run/redis

EXPOSE 7143/tcp

ENTRYPOINT /usr/bin/entrypoint.sh
