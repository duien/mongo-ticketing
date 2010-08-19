class User
  include MongoMapper::Document

  key :email, :unique => true
  key :real_name
  key :display_name, :unique => true
  timestamps!

  def self.authenticate(email, password)
    where(:email => email).first
  end

end
