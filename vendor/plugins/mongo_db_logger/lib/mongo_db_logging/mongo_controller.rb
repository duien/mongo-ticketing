# please, please, please protect this controller behind a login
class MongoDBLogging::MongoController < ActionController::Base
  append_view_path(File.join(File.dirname(__FILE__), "../../views"))
  
  helper_method :format_messages
  helper_method :print_detail

  def index
    count      = (params[:count] || 50).to_i
    @page      = (params[:page] || 1).to_i
    offset     = (@page - 1) * count
    db         = MongoLogger.mongo_connection
    collection = db[MongoLogger.mongo_collection_name]
    @records   = collection.find({}, :skip => offset, :limit => count, :sort => [[ '_id', :desc ]])
  end

  def show
  end

protected
  def format_messages(messages, css_class)
    return nil if messages.blank?
    css_class ||= ''
    css_class << ' messages'
    output = %{<ul class="#{css_class}">\n}
    messages.each do |mess|
      output << "<li>#{mess}</li>\n"
    end
    output << "</ul>"
  end
  
  def print_detail( object, indent = 0 )
    output = ""
    if object.kind_of? Hash
     output << "{\n"
     output << object.collect { |key, value|
       "  " * indent + "  #{print_detail key} => #{print_detail value, indent+1}"
     }.join(",\n") << "\n"
     output << "  " * indent + "}"
    else
     output << object.inspect
    end
    output
  end
end