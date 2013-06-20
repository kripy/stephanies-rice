require "sinatra/base"
require "mustache/sinatra"
require "open-uri"
require "json"
require "httparty"
require 'mongoid'
require 'mongo'
require 'bson'

require './lib/term'

class App < Sinatra::Base
	register Mustache::Sinatra
	require "./views/layout"

	set :mustache, {
		:views     => "./views/",
		:templates => "./templates/"
	}

	configure do
		# Database setup.
		Mongoid.load!("config/mongoid.yml")

		# Odd but true. Set up /public folder.
		set :root, File.dirname(__FILE__)
	end

	configure :production do
	  require "newrelic_rpm"
	end

	helpers do
		def get_image(str_rice)
			start = rand(1 ..60)
			position = rand(0..3)
			search_url = %{https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=}
			search_url << %{#{str_rice.gsub(" ", "+")}&start=#{start.to_s()}&imgsz=xxlarge&userip=#{request.ip}}
			response = HTTParty.get(search_url)
			parsed = JSON.parse(response.body)

			puts parsed

			# This is probably a pretty dodgy thing to do.
			data = [parsed["responseData"]["results"][position]["url"], parsed["responseData"]["results"][position]["originalContextUrl"]]
		end

		def get_image_new(str_rice)
			# Get results from Mongo.
			# Turns out the Google Search API only returns around 91 pages.
			#the_result = JSON.parse(Term.get_search_result(str_rice).to_json)
			#start = the_result[0]['result'].to_i / 10

			# Get start / position.
			start = rand(1 ..91)
			position = rand(0..10)

			# Pull results.
			search_url = "https://www.googleapis.com/customsearch/v1?"
			search_url << "key=AIzaSyAXFS8cZOLCUOvwRiGudDOSjPv3rc1dmcw&cx=001106702494312142376:5_pgyrj_apm"
			search_url << %{&q=#{str_rice.gsub(" ", "+")}&imgSize=xxlarge&searchType=image&start=#{start.to_s()}&alt=json}

			# Same as.
			response = HTTParty.get(search_url)
			parsed = JSON.parse(response.body)

			#puts parsed["items"][0]["title"]
			#puts parsed["items"][0]["link"]
			#puts parsed["items"][0]["image"]["contextLink"]

			# This is probably a pretty dodgy thing to do.
			data = [parsed["items"][0]["link"], parsed["items"][0]["image"]["contextLink"]]
		end		

		def set_search_result(str_rice)
			search_url = "https://www.googleapis.com/customsearch/v1?"
			search_url << "key=AIzaSyAXFS8cZOLCUOvwRiGudDOSjPv3rc1dmcw&cx=001106702494312142376:5_pgyrj_apm"
			search_url << %{&q=#{str_rice.gsub(" ", "+")}&imgSize=xxlarge&searchType=image&alt=json}						

			puts search_url

			response = HTTParty.get(search_url)
			parsed = JSON.parse(response.body)    

			puts parsed

			result = parsed['searchInformation']['totalResults']

			#Term.update(str_rice, result)
		end

		# Save image to disk.
		#image_name = 'welcome_logo.gif'		
		#@image_name = image_name
		#open('public/img/' + image_name, 'wb') do |file|
  		#	file << open('http://hartasandcraig.com.au/img/welcome_logo.gif').read
		#end
	end

	# Function allows both get / post.
	def self.get_or_post(path, opts={}, &block)
	  get(path, opts, &block)
	  post(path, opts, &block)
	end		

	# Global Variables?
	rice = %w( rice sushi fried\ rice risotto cute\ bento paella )

	get '/' do
		the_rice = rice.sample
		@rice = the_rice
		@image_name, @image_link = get_image(the_rice)
		@page_title = 'Stephanie\'s Rice'
		
		mustache :index
	end

	get '/about' do
		the_rice = rice.sample
		@rice = the_rice
		@image_name, @image_link = get_image(the_rice)
		@page_title = 'About Stephanie\'s Rice'

		mustache :about
	end	

	get '/load' do
		# Flust the collection as we're updating all of them.
		Term.flush
		rice.each { |x| set_search_result(x) }
	end

	get '/run' do
		the_rice = rice.sample
		get_image_new(the_rice)
		#set_search_result(the_rice)
	end	
end