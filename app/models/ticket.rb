class Ticket
  include MongoMapper::Document

  key :subject, String
  timestamps!
end
