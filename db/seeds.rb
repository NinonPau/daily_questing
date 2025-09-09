puts "Cleaning..."
UserMood.destroy_all
Task.destroy_all
User.delete_all

puts "Creating Users"
User.create!(username: "Renata", email: "renata@renata.com", password: "password", total_xp: 20)
User.create!(username: "Ninon", email: "ninon@ninon.com", password: "password", total_xp: 10)
User.create!(username: "Lucille", email: "lucille@lucille.com", password: "password", total_xp: 50)
User.create!(username: "Carlo", email: "carlo@carlo.com", password: "password", total_xp: 30)

puts "Created first Users: #{User.all}"

puts "Creating Tasks"
Task.create!(user_id: 1, name: "Shop groceries", description: "Get to Supermarket, don't forget Water!", daily: false, completed: false, xp: 10, date: Date.today )
Task.create!(user_id: 2, name: "Clean the desks", description: "Get rid of dust, then use Soap", daily: false, completed: false, xp: 10, date: Date.today )
Task.create!(user_id: 3, name: "Walk the dog", description: "Walk the woof woof through the forest.", daily: true, completed: false, xp: 50, date: Date.today )
Task.create!(user_id: 4, name: "Do some gardening", description: "Lawn mowing and cutting plants.", daily: false, completed: false, xp: 50, date: Date.today )
puts "Created first Users Task: #{Task.all}."


puts "Finished seeding with #{User.count} Users, #{UserMood.count} Usermoods and #{Task.count} Tasks."
