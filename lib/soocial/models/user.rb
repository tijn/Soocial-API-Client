module Soocial
  module Models

    class User < Base
      has_many :contacts
    end

  end
end
