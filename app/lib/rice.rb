class Rice
	include Mongoid::Document
	
	field :image_url,	:type => String
	field :url,	:type => String

	def self.add_rice(str_image_url, str_url)
		Rice.where(image_url: str_image_url, url: str_url).first_or_create
	end
end