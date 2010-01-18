class Ticket
  include MongoMapper::Document
  include ChangeDetection

  key :subject, String
  many :change_sets
  many :comments
  timestamps!

  detect_changes_for :comments
  
  before_update :detect_changes
  before_update :create_change_set

  def create_change_set
    what_changed = changes
    change_time = what_changed.delete('updated_at')[1]
    change_sets.build( :what_changed => what_changed, :changed_at => change_time )
  end
    
end
