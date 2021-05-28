# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

Mime::Type.register "application/x-x509-user-cert", :pem
Mime::Type.register "application/x-x509-ca-cert", :der
Mime::Type.register "application/x-pkcs7-crl", :crl
