class ChangeSet
  include MongoMapper::EmbeddedDocument
  key :what_changed, Hash
  key :changed_at, Time

  def changed_keys
    what_changed.keys
  end

end
