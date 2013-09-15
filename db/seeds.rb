# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ObjectId.create(name: 'countryName', short_name: 'CN', oid: '2.5.4.6')
ObjectId.create(name: 'stateOrProvinceName', short_name: 'ST', oid: '2.5.4.8')
ObjectId.create(name: 'localityName', short_name: 'L', oid: '2.5.4.7')
ObjectId.create(name: 'organizationName', short_name: 'O', oid: '2.5.4.10')
ObjectId.create(name: 'organizationalUnitName', short_name: 'OU', oid: '2.5.4.11')
ObjectId.create(name: 'commonName', short_name: 'CN', oid: '2.5.4.3')
ObjectId.create(name: 'emailAddress', oid: '1.2.840.113549.1.9.1')
