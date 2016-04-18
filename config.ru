$:.unshift File.expand_path("./../lib", __FILE__)

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require 'app'

run IdeaPadApp
