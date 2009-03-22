# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_qadmin-demo_session',
  :secret      => '4e2cd6fa940813f1dc971904e9d598f58cbbaca09ebeff0a379316990de37006a7210e7202e1c7b23ab07e2bc4440ffd810abbf6565d1adf14073b108a09083b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
