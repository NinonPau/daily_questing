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
UserMood.destroy_all
puts "all after destroy"
puts UserMood.all
Task.destroy_all
User.delete_all


users = 10.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    username: Faker::Internet.username,
    total_xp: rand(0..200),
  )
end

UserMood.all.each do |user_mood|
  user_mood.mood_type = ["Amazing", "Good", "Ok'ish", "Bad"].sample
  puts user_mood.mood_type
end

UserMood.all.each do |user_mood|
  puts user_mood.mood_type
end


puts "all after user creation"
puts UserMood.all

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

# puts "1 all"
# puts UserMood.all
# puts "creating UserMood"

# users.each do |user|
#     user_mood = UserMood.create!(
#       user_id: user.id,
#       mood_type: "Bad",
#       xp_bonus: 1
#     )
#   puts user.user_mood
# end


# puts "all"
# puts UserMood.all
# puts "Seed finished #{User.count} users, #{Task.count} tasks and #{UserMood.count} user_moods."
