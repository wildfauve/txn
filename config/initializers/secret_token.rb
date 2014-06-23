# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Txn::Application.config.secret_key_base = 'ef12f4bb3cd7c6b2aea58ad68882f8dff14ce1d3c5bc2ad705a5fdb36d3f879a61e5b21b76bc4ac78eb8bd5634191f5cc36267b6e8c6ea3cee65a5634ec3e689'
