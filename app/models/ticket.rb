class Ticket
  include MongoMapper::Document
  include ChangeDetection

  STATUSES = [ :new, :open, :resolved, :closed ]
  
  def self.statuses
    STATUSES
  end

  key :subject, String
  key :status, Symbol, :required => true, :default => :new
  key :description, String
  key :comment, String
  many :change_sets
  timestamps!

  detect_changes_for :description
  validates_inclusion_of :status, :within => statuses
  
  before_update :detect_changes
  before_update :create_change_set
  before_validation :typecast_status
  
  def typecast_status
    # why the hell do I have to do this?
    self.status = self.status.to_sym
  end

  def create_change_set
    what_changed = changes
    change_time = what_changed.delete('updated_at')[1]
    comment = what_changed.delete('comment')
    comment = comment[1] unless comment.nil?
    what_changed.each do |key, values|
      if self.class.associations.has_key? key
        simple_values = values.collect do |value|
          value.collect { |item| item.id }
        end
        what_changed[key] = simple_values
      end
    end
    change_sets.build( :what_changed => what_changed,
                       :changed_at => change_time,
                       :comment => comment ) unless what_changed.empty? and comment.nil?
  end
    
end
