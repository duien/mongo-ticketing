class Ticket
  include MongoMapper::Document
  include ChangeDetection

  key :subject, String
  key :status, Symbol, :required => true, :default => :new
  key :description, String
  many :change_sets
  many :comments
  timestamps!

  detect_changes_for :comments
  
  before_update :detect_changes
  before_update :create_change_set

  def create_change_set
    what_changed = changes
    change_time = what_changed.delete('updated_at')[1]
    what_changed.each do |key, values|
      if self.class.associations.has_key? key
        simple_values = values.collect do |value|
          value.collect { |item| item.id }
        end
        what_changed[key] = simple_values
      end
    end
    change_sets.build( :what_changed => what_changed, :changed_at => change_time ) unless what_changed.empty?
  end
    
end
