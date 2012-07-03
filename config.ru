#coding: utf-8
require 'sinatra'
set :public_folder, File.dirname(__FILE__) + '/webroot'
set :environment, :production
get('/') { open('webroot/index.html').read }
run Sinatra::Application
