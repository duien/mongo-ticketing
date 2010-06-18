class UserRelationship
  include MongoMapper::EmbeddedDocument
  
  TYPES = [ :owner, :requestor, :watcher ]
  
  def self.types
    TYPES
  end
  
  key :type, :required => true
  key :user_id, :required => true
  belongs_to :user
  
  validates_inclusion_of :user, :within => types
  before_validation :typecast_type
  
  def typecast_type
    # why the hell do I have to do this?
    self.type = self.type.to_sym
  end
end
