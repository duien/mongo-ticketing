# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include MongoDBLogging
  before_filter :log_current_user
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  # filter_parameter_logging :password
  
  before_filter :set_title
  
  private
  
  def set_title
    @title = 'My Awesome Application Name'
  end
  
  def log_current_user
    if Rails.logger.respond_to?(:add_metadata) and current_user
      Rails.logger.add_metadata(:current_user => current_user.as_json)
    end
  end
end
