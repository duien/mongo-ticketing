class AuthenticationMiddleware

  def initialize
  end
  
  def call(env)
    puts "Calling the AuthenticationMiddleware"
    [200, {}, []]
  end
  
end
