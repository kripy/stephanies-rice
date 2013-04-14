require 'sinatra/base'
require 'open-uri'
require 'json'
require 'httparty'

class App < Sinatra::Base

	configure do
		# Odd but true. Set up /public folder.
		set :root, File.dirname(__FILE__)
	end

	helpers do

	end

	# Function allows both get / post.
	def self.get_or_post(path, opts={}, &block)
	  get(path, opts, &block)
	  post(path, opts, &block)
	end		

	get '/' do
		# Save image to disk.
		#image_name = 'welcome_logo.gif'		
		#@image_name = image_name
		#open('public/img/' + image_name, 'wb') do |file|
  		#	file << open('http://hartasandcraig.com.au/img/welcome_logo.gif').read
		#end

		start = rand(1 ..60)
		position = rand(0..3)
		puts 'start: ' + start.to_s() + ', position: ' + position.to_s()

		search_url = 'https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=rice&start=' + start.to_s() + '&imgsz=xxlarge&userip=' + request.ip
		response = HTTParty.get(search_url)
		parsed = JSON.parse(response.body)
		@image_name = parsed['responseData']['results'][position]['url']

		erb :index
	end

	get '/about' do
		start = rand(1 ..60)
		position = rand(0..3)
		puts 'start: ' + start.to_s() + ', position: ' + position.to_s()

		search_url = 'https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=rice&start=' + start.to_s() + '&imgsz=xxlarge&userip=' + request.ip
		response = HTTParty.get(search_url)
		parsed = JSON.parse(response.body)
		@image_name = parsed['responseData']['results'][position]['url']

		erb :about
	end	
end