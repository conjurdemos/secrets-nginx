#!/bin/bash
set -e
set -x

if [[ ! -e /usr/local/nginx ]] ; then
  /vagrant/install-nginx-lua.sh
fi

ln -sf /vagrant/nginx.conf /usr/local/nginx/conf/nginx.conf
service nginx restart

cp /vagrant/.netrc /root

su vagrant -c /vagrant/user.sh



