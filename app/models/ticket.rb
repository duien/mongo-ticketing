class Ticket
  include MongoMapper::Document

  key :subject, String
  many :change_sets
  timestamps!
  
  before_save :create_change_set

  def create_change_set
    unless new_record?
      what_changed = changes
      change_time = what_changed.delete('updated_at')
      change_sets.build( :what_changed => what_changed, :changed_at => change_time )
    end
  end
    
end
