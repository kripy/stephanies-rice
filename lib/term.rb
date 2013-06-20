class Term
	include Mongoid::Document
	
	field :term,	:type => String
	field :result,	:type => Integer

	def self.update(the_term, the_result)
		e = Term.new
		e.term = the_term
		e.result = the_result
		e.save
	end

	def self.flush()
		Term.delete_all
	end

	def self.get_search_result(str_rice)
		e = Term.where(term: str_rice)
	end
end