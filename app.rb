require 'sinatra/base'
require 'sinatra/assetpack'
require 'compass'
require 'compass-h5bp'
require 'sinatra/support'
require 'mustache/sinatra'

require "open-uri"
require "json"
require "httparty"
require 'mongoid'
require 'mongo'
require 'bson'

require './app/lib/rice'

class App < Sinatra::Base
  base = File.dirname(__FILE__)
  set :root, base

  register Sinatra::AssetPack
  register Sinatra::CompassSupport
  register Mustache::Sinatra

  set :sass, Compass.sass_engine_options
  set :sass, { :load_paths => sass[:load_paths] + [ "#{base}/app/css" ] }

  assets do
    serve '/js',    from: 'app/js'
    serve '/css',   from: 'app/css'
    serve '/img',   from: 'app/img'

    css :app_css, [ '/css/*.css' ]
    js :app_js, [
      '/js/*.js',
      '/js/vendor/jquery-1.9.1.min.js',
    ]
    js :app_js_modernizr, [ '/js/vendor/modernizr-2.6.2.min.js' ]
  end

  require "#{base}/app/helpers"
  require "#{base}/app/views/layout"

  set :mustache, {
    :templates => "#{base}/app/templates",
    :views => "#{base}/app/views",
    :namespace => App
  }

  before do
    @css = css :app_css
    @js  = js  :app_js
    @js_modernizr = js :app_js_modernizr
  end

  configure do
    # Database setup.
    Mongoid.load!("./app/config/mongoid.yml")

    # Odd but true. Set up /public folder.
    set :root, File.dirname(__FILE__)
  end

  helpers do
    def get_image(str_rice)
      # Turns out the Google Search API only returns around 91 pages.
      # Which kind of sucks ... what's the point of having an API?
      # Get start / position.
      start = rand(1 ..91)
      position = rand(0..9)
      bln_rate_limited = false

      # Pull results.
      search_url = "https://www.googleapis.com/customsearch/v1?"
      search_url << "key=" + ENV["SR_KEY"] + "&cx=" + ENV["SR_CX"]
      search_url << %{&q=#{str_rice.gsub(" ", "+")}&imgSize=xxlarge&searchType=image&start=#{start.to_s()}&alt=json}

      response = HTTParty.get(search_url)
      parsed = JSON.parse(response.body)

      # Need to deal with API rate limiting.
      if parsed.length == 1
        # Have been rate limited.
        bln_rate_limited = true
        arr_rice = Rice.all
        str_rice = JSON.parse(arr_rice.sample.to_json)
        data = [str_rice["image_url"], str_rice["url"], bln_rate_limited]
      else
        # Save it.
        Rice.add_rice(parsed["items"][position]["link"], parsed["items"][position]["image"]["contextLink"])
        data = [parsed["items"][position]["link"], parsed["items"][position]["image"]["contextLink"], bln_rate_limited]
      end
    end

    def set_image(str_image_url, str_url)
      Rice.add_rice(str_image_url, str_url)
    end
  end

  # Function allows both get / post.
  def self.get_or_post(path, opts={}, &block)
    get(path, opts, &block)
    post(path, opts, &block)
  end

  # Global Variables?
  rice = %w( rice sushi fried\ rice risotto cute\ bento paella )

  # Need to change the message if we've been rate limited.
  get '/' do
    the_rice = rice.sample
    @rice = the_rice
    @image_name, @image_link, @rate_limit = get_image(the_rice)
    @page_title = 'Stephanie\'s Rice'
    
    mustache :index
  end

  get '/about' do
    the_rice = rice.sample
    @rice = the_rice
    @image_name, @image_link, @rate_limit = get_image(the_rice)
    @page_title = 'About Stephanie\'s Rice'

    mustache :about
  end
end