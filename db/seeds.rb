# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

20.times do
  u = User.new(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: 'password',
    password_confirmation: 'password'
  )
  u.save
end

10.times do
  Category.create(name: Faker::Lorem.sentence)
end

50.times do
  u = User.all
  c = Category.all
  b = Bulletin.new(
    name: Faker::Lorem.sentence,
    description: Faker::Lorem.paragraph,
    category: c.sample,
    author: u.sample
  )
  b.save
end
