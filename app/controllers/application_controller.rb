# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include MongoDBLogging
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  # filter_parameter_logging :password
  
  before_filter :set_title, :authenticate
  helper_method :warden
  
  private
  
  def set_title
    @title = 'Mongo Ticketing'
  end

  def warden
    request.env['warden'] 
  end

  def authenticate
    warden.authenticate!
  end
end
