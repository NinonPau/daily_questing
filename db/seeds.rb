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
# Nettoyer avant de reseed
Task.delete_all
UserMood.delete_all
Task.delete_all
User.delete_all


users = 10.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    username: Faker::Internet.username,
    total_xp: rand(0..5000)
  )
end


tasks = 15.times.map do
  Task.create!(
    name: Faker::Verb.base.capitalize + " " + Faker::Name.unique.name,
    description: Faker::Lorem.sentence(word_count: 8),
    daily: Faker::Boolean.boolean,
    duo: Faker::Boolean.boolean,
    xp: rand(10..100),
    user: User.all.sample()
  )
end

users.each do |user|
  # rand(1..3).times do
    UserMood.create!(
      user: user,
      mood_type: %w[happy sad focused tired motivated].sample,
      xp_bonus: rand(0.5..50),

    )
  # end
end



# puts "Seed finished #{User.count} users, #{Task.count} tasks, #{UserTask.count} user_tasks and  #{UserMood.count} user_moods."
