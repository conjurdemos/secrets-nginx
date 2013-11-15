#!/bin/bash
set -e
set -x

if [[ ! -e /usr/local/nginx ]] ; then
  ./install-nginx-lua.sh
fi

ln -sf /vagrant/nginx.conf /usr/local/nginx/conf/nginx.conf
service nginx restart

cp /vagrant/.netrc /root

su vagrant
curl -L https://get.rvm.io | bash
source ~/.rvm/scripts/rvm
rvm install 2.0.0
rvm use 2.0.0
gem install bundler sinatra --no-ri --no-rdoc

./service.rb &



