# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
# Clean before reseed
UserMood.delete_all
Task.delete_all
User.delete_all


users = 10.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    username: Faker::Internet.username,
    total_xp: rand(0..200)
  )
end


tasks = 15.times.map do
  Task.create!(
    name: Faker::Verb.base.capitalize + " " + Faker::Name.unique.name,
    description: Faker::Lorem.sentence(word_count: 8),
    daily: Faker::Boolean.boolean,
    completed:Faker::Boolean.boolean,
    duo: Faker::Boolean.boolean,
    xp: rand(10..100),
    user: User.all.sample()
  )
end

users.each do |user|
    UserMood.create!(
      mood_type: %w[Amazing Good Ok'ish Bad].sample,
      xp_bonus: 1
    )
end

puts "Seed finished #{User.count} users, #{Task.count} tasks and #{UserMood.count} user_moods."
