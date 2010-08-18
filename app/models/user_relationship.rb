class UserRelationship
  include MongoMapper::EmbeddedDocument
  
  TYPES = [ :owner, :requestor, :watcher ]
  
  def self.types
    TYPES
  end
  
  key :type, Symbol, :required => true
  key :user_id, :required => true
  belongs_to :user
  
  validates_inclusion_of :type, :within => types
  
end
