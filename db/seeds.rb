# require 'faker'

puts "Cleaning..."
UserMood.destroy_all
Task.destroy_all
User.delete_all

puts "Creating Users"
renata = User.create!(username: "Renata", email: "Renata@Renata.com", password: "renata", total_xp: 20)
# renata.user_mood.mood_type = "Unset"
puts "Created first User: #{User.all}"

puts "Creating UserMoods"
# UserMood.create!(user_id: 1, mood_type: "Bad", xp_bonus: 3)
puts "Created first Users UserMood: #{UserMood.all}."

puts "Creating Tasks"
Task.create!(user_id: 1, name: "Shop groceries", description: "Get to Supermarket, don't forget Water!", daily: false, completed: false, xp: 10, date: Date.today )
puts "Created first Users Task: #{Task.all}."


puts "Finished seeding with #{User.count} Users, #{UserMood.count} Usermoods and #{Task.count} Tasks."

# users = 10.times.map do
#   User.create!(
#     email: Faker::Internet.unique.email,
#     password: "password",
#     username: Faker::Internet.username,
#     total_xp: rand(0..200),
#   )
# end

# UserMood.all.each do |user_mood|
#   user_mood.mood_type = ["Amazing", "Good", "Ok'ish", "Bad"].sample
#   puts user_mood.mood_type
# end

# UserMood.all.each do |user_mood|
#   puts user_mood.mood_type
# end

# tasks = 15.times.map do
#   Task.create!(
#     name: Faker::Verb.base.capitalize + " " + Faker::Name.unique.name,
#     description: Faker::Lorem.sentence(word_count: 8),
#     daily: Faker::Boolean.boolean,
#     completed:Faker::Boolean.boolean,
#     duo: Faker::Boolean.boolean,
#     xp: rand(10..100),
#     user: User.all.sample()
#   )
# end
