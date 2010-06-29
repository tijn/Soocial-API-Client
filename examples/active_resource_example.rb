require File.expand_path('common', File.dirname(__FILE__))
require 'soocial/basic_client'
require 'soocial/active_resource'

CONSUMER_KEY = CONSUMER_KEY_ACQUIRED_BY_REGISTERING_YOUR_APP_ON_SOOCIAL
CONSUMER_SECRET = CONSUMER_SECRET_ACQUIRED_BY_REGISTERING_YOUR_APP_ON_SOOCIAL

THE_ACCESS_TOKEN_FOR_THIS_USER_THAT_I_HAD_STORED_SOMEWHERE = nil

# THE_ACCESS_TOKEN_FOR_THIS_USER_THAT_I_HAD_STORED_SOMEWHERE = OAuth::AccessToken.new(OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, { :site => Soocial::SITE }), "eCFDMbQTBn65xhi7iGxQ7g", "PaeC5f96mK1XoJ00mAL6TcowAJyDasvvXzoUD7ZM5u8")


if THE_ACCESS_TOKEN_FOR_THIS_USER_THAT_I_HAD_STORED_SOMEWHERE.nil?
  # let's use the CommandLineApp to gain an access token in this example, other methods are fine as well. The main thing is that we have to get an access token.
  foo = Soocial::CommandLineApp.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET
    )
  foo.authorize!
  access_token = foo.access_token
  # we really should save the access token now:
  puts '='*40, "token: #{access_token.token}", "secret: #{access_token.secret}", '='*40
else
  access_token = THE_ACCESS_TOKEN_FOR_THIS_USER_THAT_I_HAD_STORED_SOMEWHERE
end

soocial = Soocial.register(
    :consumer_key => CONSUMER_KEY,
    :consumer_secret => CONSUMER_SECRET,
    :access_token => access_token,
    :site => Soocial::SITE
  )
puts "Authorized and connected to Soocial!"

# soocial.Contact.find(:all).each do |c|
#   puts "#{c.id} => #{c.formatted_name}"
# end
# puts soocial.User


bert = soocial.Contact.find(:first)
puts "Le premier contact est: #{bert}"

# renaming a contact:
previous_name = bert.name.given
bert.name.given = "Bert"
bert.save
puts "I renamed #{previous_name} to #{bert.name.given}"
# okay okay, I'll revert it.
bert.name.given = previous_name
bert.save



# adding an email address
bert.emails.create(:address => "foo@example.com")

# updating an email address
bert.emails.reload
puts bert.emails.each {|x| x.inspect }
email = bert.emails.detect {|e| e.address == "foo@example.com" }
email.address = "foz@example.com"
email.save

# delete an email address
bert.emails.reload
email = bert.emails.detect {|e| e.address == "foz@example.com" }
email.destroy

# see, it's gone!
raise "oh dear!" unless bert.emails.reload.detect {|e| e.address == "foo@example.com" }.nil?




puts bert.telephones
# adding a telephone number
tel = bert.telephones.create(:number => "54-46") # That's my number

# updating a telephone number
# My number is...
tel.number = "2222 22 2" # I've got an answering machine that can talk to you
tel.save

puts bert.telephones.reload

# delete a telephone number
tel.destroy

# see, it's gone!
raise "oh dear!" unless bert.telephones.reload.detect {|e| e.number == "2222 22 2" }.nil?


puts bert.addresses
# adding an address
adr = bert.addresses.create(:street => "Penny Lane")

# moving...
adr.street = "Abbey Road"
adr.save

puts bert.addresses.reload

# delete an address
adr.destroy

# see, it's gone!
raise "oh dear!" unless bert.addresses.reload.detect {|e| e.street == "Abbey Road" }.nil?



puts bert.notes
# adding a note
note = bert.notes.create(:text => "See Ernie for address")

# updating...
note.text = "See Ernie for street address"
note.save

puts bert.notes.reload

# delete this note
note.destroy

# see, it's gone!
raise "blimey!" unless bert.notes.reload.detect {|e| e.text == "See Ernie for street address" }.nil?

