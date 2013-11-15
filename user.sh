#!/bin/bash

curl -L https://get.rvm.io | bash
source ~/.rvm/scripts/rvm
rvm install 2.0.0
rvm use 2.0.0
gem install bundler sinatra --no-ri --no-rdoc

./service.rb &