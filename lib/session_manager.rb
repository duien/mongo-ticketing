require 'sinatra/base'

# Allow Sinatra app to be used an middleware by Rails
module Sinatra
  class Base
    class << self
      remove_method :call if method? :call
    end
  end
end

class SessionManager < Sinatra::Base

  set :root, File.join(File.dirname(__FILE__), 'session_manager')

  get '/unauthenticated' do
    redirect '/login'
  end

  get '/login' do
    haml :login
  end
  
private

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
