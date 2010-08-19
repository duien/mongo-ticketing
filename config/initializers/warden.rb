require 'warden'

ActionController::Dispatcher.middleware.insert_after(ActionController::ParamsParser, Warden::Manager) do |manager|
  manager.default_strategies :password
  manager.failure_app = AuthenticationMiddleware.new

  manager.serialize_into_session do |user|
    user.id.to_s
  end

  manager.serialize_from_session do |user|
    User.find(id)
  end

end

Warden::Strategies.add(:password) do
  
  def valid?
    puts "checking validity of strategy"
    valid = params['email'] || params['password']
    puts params.inspect
    puts valid ? 'VALID' : 'INVALID'
    valid
  end

  def authenticate!
    puts "trying to authenticate"
    u = User.authenticate(params['email'], params['password'])
    puts u.inspect
    u.nil? ? fail!("Could not log in") : success!(u)
  end
end

