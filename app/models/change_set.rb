class ChangeSet
  include MongoMapper::EmbeddedDocument
  key :what_changed, Hash
  key :changed_at, Time
  key :comment, String

end
