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
		def get_image(str_rice)
			start = rand(1 ..60)
			position = rand(0..3)
			puts 'start: ' + start.to_s() + ', position: ' + position.to_s()

			search_url = 'https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=' + str_rice.gsub(' ', '+') + '&start=' + start.to_s() + '&imgsz=xxlarge&userip=' + request.ip
			response = HTTParty.get(search_url)
			parsed = JSON.parse(response.body)

			data = parsed['responseData']['results'][position]['url']
		end

		def image_test(str_image)
			response = HTTParty.get(str_image)
			response = response.code
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
	rice = %w( rice sushi fried\ rice risotto cute\ bento )

	get '/' do
		#http://www.tylermcpeak.com/wp-content/uploads/Brown_rice.jpg
		#@image_name = 'http://www.tylermcpeak.com/wp-content/uploads/Brown_rice.jpg'
		the_rice = rice.sample
		@rice = the_rice
		@image_name = get_image(the_rice)
		@title = 'Stephanie\'s Rice'
		erb :index
	end

	get '/about' do
		the_rice = rice.sample
		@rice = the_rice
		@image_name = get_image(the_rice)
		@title = 'About Stephanie\'s Rice'
		erb :about
	end	
end