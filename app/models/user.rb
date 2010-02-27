class User
  include MongoMapper::Document
  
  key :name, String
  key :email, String, :required => true
  key :username, String, :required => true
  key :nickname, String
  
  validates_uniqueness_of :email,    :case_sensitive => false
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :nickname, :allow_blank    => true, 
                                     :case_sensitive => false
  
end
