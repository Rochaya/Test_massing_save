require 'bundler'
require 'nokogiri'
require 'open-uri'
require 'json'
Bundler.require

require_relative 'lib/scrapper.rb'
require_relative 'db/emails.json'
ScrapperMails.new.perform()
