# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: 'Admin User',
  password: 'foobar',
  password_confirmation: 'foobar',
  admin: true,
  activated: true
)
99.times do |n|
  name = Faker::Name.name
  password = "password"
  User.create!(name:  name,
               password:              password,
               password_confirmation: password,
               activated: true)
end

Shift.create!(
  user_id: 1,
  draft: true,
  workday: "2020/09/25"
)
99.times do |n|
  user_id = Faker::Number.number(digits: 2)
  workday = Faker::Date.between(from: '2019-09-23', to: '2020-09-25')
  Shift.create!(user_id: user_id,
                draft: true,
                workday: workday)
end