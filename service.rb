#!/usr/bin/env ruby
require 'sinatra'

get '/' do
  "The secret is: #{env['HTTP_X_CONJUR_SECRET']}\n"
end