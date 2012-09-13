path = File.expand_path "../", __FILE__

require 'rubygems'
require 'sinatra'
require "#{path}/simple_blog"
require "#{path}/lib/post"
require "#{path}/lib/comment"

run Sinatra::Application
