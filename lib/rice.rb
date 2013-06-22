class Rice
	include Mongoid::Document
	
	field :message, 		:type => String


	def self.add_rice(str_image, str_link)
		e = Entry.new
		e.image = str_image
		e.link = str_link
		e.save
	end
end