# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
default_password = 'aaaaaaaa'
default_mail_host = 'example.org'

#
# Generate Users
#
users = ['David', 'Katharina', 'Tom', 'Jerry']
users.each do |u|
  User.create(
      :name => u.to_s,
      :email => u.to_s.downcase + '@' + default_mail_host,
      :password => default_password,
      :password_confirmation => default_password
  )
end
