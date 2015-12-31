require 'net/http'
require 'optparse'
require 'timeout'
require 'openssl'
require 'securerandom'
require 'awesome_print'
require 'json'
require 'optparse'
require './lib/oauth_signature.rb'
require './lib/tweet_parser.rb'
require './lib/tweet_streamer.rb'
require './lib/main.rb'

home_folder = ENV['HOME'] || `echo $HOME`
envfile = File.join(home_folder, '.env')
readme = "see README.md for more details"

if !File.exists?(envfile) 
  puts "Please create .env file in your '#{home_folder}' folder #{readme}"
  exit
end

if !File.read(envfile).match(/key|access|secret/i)
  puts "Missing Twitter API credentials #{readme}"
  exit
end

load envfile  
Main.new.run
