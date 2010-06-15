class User
  include MongoMapper::Document

  timestamps!

  devise :database_authenticatable, 
         :recoverable, 
         :rememberable,
         :registerable,
         :trackable,
         :validatable
end