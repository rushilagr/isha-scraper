require 'sinatra'
require 'dotenv/load'
require 'nokogiri'
require 'restclient'
require 'mailgun-ruby'
require 'roadie'
require 'haml'
require 'slim'


require "./methods.rb"
include Methods

get "/" do
	bsp_present = scrape_bsp
	shoonya_present = scrape_shoonya
	html = generate_html(bsp: bsp_present, shoonya: shoonya_present)
	ENV['MAILGUN_API_KEY']
	# send_email(content:html, recipients: ['rushil.agrawal@gmail.com'])
end

# TODO ---------------------------
# Add for naga also
# Add recipients for mom and avantika
# Save API keys in secret env variables
# Deploy app to cloud 
# Configure CRON
# Ensure Mail works