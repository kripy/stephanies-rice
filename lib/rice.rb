class Rice
	include Mongoid::Document
	
	field :message, 		:type => String


	def self.enter(the_message, the_date)
		e = Entry.new
		e.message = the_message
		e.entry_date = the_date
		e.save
	end

	def self.entries_by_date()
		map = "function() { day = Date.UTC(this.entry_date.getFullYear(), this.entry_date.getMonth(), this.entry_date.getDate()); emit(new Date(day), 1); }"
		reduce = "function(key, values) { var count = 0; values.forEach(function(v) { count += v; }); return count; }"
		Entry.map_reduce(map, reduce).out(replace: "counts").counts
	end
end