# Be sure to restart your server when you modify this file.

#Dame09plus::Application.config.session_store :cookie_store, key: '_dame09plus_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Dame09plus::Application.config.session_store :mongoid_store
