class Term
	include Mongoid::Document
	
	field :term,	:type => String
	field :result,	:type => Integer

	def self.update(str_term, str_result)
		#Rice.where(image_url: str_image_url, url: str_url).first_or_create
		Term.where(term: str_term, result: str_result).first_or_create
	end

	def self.flush()
		Term.delete_all
	end

	def self.get_search_result(str_rice)
		e = Term.where(term: str_rice)
	end
end