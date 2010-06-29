# A Ruby wrapper for the Soocial API
#
#
# Author:: Tijn Schuurmans (tijn@soocial.com)
# based on the work of Johannes Wagener (http://github.com/jwagener) (johannes@wagener.cc) for the Soundcloud API


module Soocial
  module Models

    class Base < OAuthActiveResource::Resource #:nodoc:
      headers['Accept'] = 'application/xml'

      def element_name
        self.class.to_s.split("::").last.downcase.to_s
      end
    end

  end
end


module OAuthActiveResource


  class UniqueResourceArray < UniqueArray
    # create a new item of the type that is stored in this UniqueResourceArray
    def create(options = {})
      item = @resource.new(options)
      response = @connection.handle_response( @connection.post(@collection_path, item.to_xml) )
      # puts response.body # so you can actually see what's going on
      item = @resource.new(@connection.format.decode(response.body))
      self << item
      item
    end
  end


end
