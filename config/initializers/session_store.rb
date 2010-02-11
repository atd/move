# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
    :key         => '_move_session',
    :secret      => '3a946c4b319f6ef9c0f031aed97a7adabd8fcce1ce83cb6db406ce02a28d25d04ff15c1efbbf39e98a11c519e0342c6677ba940dfbfd20f9aefb9e3dc1b77071'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
