class User
  include MongoMapper::Document

  key :email, :unique => true
  key :real_name
  key :display_name, :unique => true
  timestamps!

end
