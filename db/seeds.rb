# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Oid.create(name: "countryName", short_name: "C", default_description: "Country Name (2 letter code)", oid: "2.5.4.6")
Oid.create(name: "stateOrProvinceName", short_name: "ST", default_description: "State or Province Name (full name)", oid: "2.5.4.8")
Oid.create(name: "localityName", short_name: "L", default_description: "Locality Name (eg, city)", oid: "2.5.4.7")
Oid.create(name: "organizationName", short_name: "O", default_description: "Organization Name (eg, company)", oid: "2.5.4.10")
Oid.create(name: "organizationalUnitName", short_name: "OU", default_description: "Organizational Unit Name (eg, section)", oid: "2.5.4.11")
Oid.create(name: "commonName", short_name: "CN", default_description: "Common Name (e.g. server FQDN or YOUR name)", oid: "2.5.4.3")
Oid.create(name: "emailAddress", short_name: "emailAddress", default_description: "Email Address", oid: "1.2.840.113549.1.9.1")
