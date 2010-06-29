module Soocial
  module Models

    class Contact < Base
      has_many :addresses, :emails, :impps, :notes, :telephones
      self.site = "#{Soocial::SITE}"

      def to_s
        formatted_name
      end
    end

    # self.site = "contacts/:contact_id/etcetera" is not doing anything for resources accessed by the OAuth kludge, so I redefined two important methods
    class ContactField < Base
      belongs_to :contact

      def element_path(options = nil)
        # puts "/contacts/#{contact_id}/#{self.class.collection_name}/#{id}.xml"
        "/contacts/#{contact_id}/#{self.class.collection_name}/#{id}.xml"
      end

      def collection_path(options = nil)
        # puts "/contacts/#{contact_id}/#{self.class.collection_name}.xml"
        "/contacts/#{contact_id}/#{self.class.collection_name}.xml"
      end
    end


    class Address < ContactField
      self.site = "#{Soocial::SITE}/contacts/:contact_id/addresses"

      def to_s
        "#{street}, #{locality}, #{region}, #{postal_code}, #{country}, #{extended}, #{pobox}"
      end
    end


    class Email < ContactField
      self.site = "#{Soocial::SITE}/contacts/:contact_id/emails/"

      def to_s
        address
      end
    end


    class Impp < ContactField
      self.site = "#{Soocial::SITE}/contacts/:contact_id/impps/"

      def to_s
        "#{scheme} : #{address}"
      end
    end


    class Note < ContactField
      self.site = "#{Soocial::SITE}/contacts/:contact_id/notes/"

      def to_s
        text
      end
    end


    class Telephone < ContactField
      self.site = "#{Soocial::SITE}/contacts/:contact_id/telephones/"

      def to_s
        number
      end
    end

  end
end
