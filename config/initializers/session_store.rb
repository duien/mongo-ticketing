# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mongo-ticketing_session',
  :secret      => 'e5f21c2422ab28a5fc0b9f603730024925e9567e85677009588aefb4a89e06404a83e6d85bc90c49e5caf78e5e97785c50266fde31715173279ce8c757d46e65'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
