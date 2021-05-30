# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development? && User.all.empty?
  admin = User.create!(first_name: 'Jone', last_name: 'Smith', email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  admin.add_role(:admin)
end
