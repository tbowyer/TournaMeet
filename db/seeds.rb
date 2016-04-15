# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user_list = []
20.times do
	user_list << []
end
n = 1
user_list.each do |arr|
	arr << "smasher#{n}@gmail.com"
	arr << "password"
	arr << "password"
	n += 1
end

user_list.each do |email, password, password_confirmation|
  User.create( email: email, password: password, password_confirmation: password_confirmation )
end
