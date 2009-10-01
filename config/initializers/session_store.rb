# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shovell_session',
  :secret      => 'e18f8719347cc06e4a544ddaeb27fc67f5f817a4e8fb9b7ef0a10f330807bf3561040e3cab600a29e5620d9fb0e09cc73617be867b2fbb80e4ad88ff14bdeb71'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
