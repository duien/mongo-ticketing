require 'mongo_mapper'
MongoMapper.database = 'many-many-test'

class User
  include MongoMapper::Document

  key :real_name, String
  key :user_name, String, :required => true, :unique => true, :index => true
  key :email, String, :unique => true, :index => true

  many :groups, :source => :users
end

class Group
  include MongoMapper::Document

  key :name, String, :required => true, :unique => true
  key :user_ids, Array

  many :users, :in => :user_ids
end

class Status
  include MongoMapper::Document
  key :name, String, :required => true, :unique => true
  # many :tickets
end

class Ticket
  include MongoMapper::Document
  
  key :status_id
  belongs_to :status

  many :relationships
  key :subject, String
end

class Relationship
  include MongoMapper::EmbeddedDocument

  key :role, String
  belongs_to :user
end


