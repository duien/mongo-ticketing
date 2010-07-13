class Ticket
  include MongoMapper::Document
  include ChangeDetection

  STATUSES = [ :new, :open, :resolved ]
  
  def self.statuses
    STATUSES
  end

  key :subject, String
  key :status, Symbol, :required => true, :default => :new
  key :description, String
  key :comment, String
  key :short_id, String
  many :change_sets
  timestamps!

  detect_changes_for :description
  validates_inclusion_of :status, :within => statuses
  
  before_create :set_short_id
  before_update :detect_changes
  before_update :create_change_set

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
  
  def set_short_id
    prefix_length = 5
    sha = Digest::SHA1.hexdigest(self.to_json)
    short_id = nil
    while short_id.nil? || Ticket.first(:short_id => short_id)
      short_id = sha.first(prefix_length)
      prefix_length += 1
    end
    self.short_id = short_id
  end
  
  def to_param
    short_id
  end
    
end
