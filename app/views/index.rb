class App
  module Views
    class Index < Layout
   	  def image_name
   	  	@image_name
   	  end      	

   	  def rice
   	  	@rice
   	  end

      def image_link
        @image_link
      end 

      def rate_limit
        @rate_limit
      end 
    end
  end
end