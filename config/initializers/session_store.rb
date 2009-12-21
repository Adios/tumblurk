# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tumblurk_session',
  :secret      => '73cc0262f7643bd2fd84395f5ba527211565d357a8de9850b008b800734eed0c5f0ee5c4989b741c91b54e0fa2cdc68cae134ca82d91807bb4b8efdf78bf489f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
