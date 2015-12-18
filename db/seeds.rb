# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
categories = Category.create([{ name: 'For Sale', color: '' }, { name: 'Free', color: 'blue' }, { name: 'Help Wanted', color: 'green' }, { name: 'Jobs Offered', color: 'purple' }, { name: 'Random', color: 'orange' }])
jerry = User.create(email: "jerry@upstairs.io", password: "Upstairs1!", password_confirmation: "Upstairs1!", phone: "5555551212", username: "jerry")
jane = User.create(email: "jane@upstairs.io", password: "Upstairs1!", password_confirmation: "Upstairs1!", phone: "5555551213", username: "jane")
mark = User.create(email: "mark@upstairs.io", password: "Upstairs1!", password_confirmation: "Upstairs1!", phone: "5555551214", username: "mark")
maurice = User.create(email: "maurice@upstairs.io", password: "Upstairs1!", password_confirmation: "Upstairs1!", phone: "5555551215", username: "maurice")
katy = User.create(email: "katy@upstairs.io", password: "Upstairs1!", password_confirmation: "Upstairs1!", phone: "5555551216", username: "katy")
admin = User.create(email: "admin@upstairs.io", password: "Upstairs1!", password_confirmation: "Upstairs1!", phone: "5555551217", username: "admin")
admin.add_role(:admin)
verifier = User.create(email: "verifier@upstairs.io", password: "Upstairs1!", password_confirmation: "Upstairs1!", phone: "5555551218", username: "verfier")
verifier.add_role(:verifier)

building_one = Building.create(
  name: "Elmo's Place",
  address: "401 43rd Ave, San Francisco, CA 94121, USA",
  invitation_link: "638f1bee",
  longitude: -122.504476,
  latitude: 37.78094
)

jerry.join(building_one)
jane.join(building_one)
maurice.join(building_one)
maurice.make_landlord(building_one)

building_two = Building.create(
  name: "Kamp Krantz",
  address: "62 Castenada, San Francisco, CA 94116, USA",
  invitation_link: "638f1bef",
  longitude: -122.4644187,
  latitude: 37.7500272
)

Building.all.each do |building|
  User.all.each do |user|
    user.join(building)
  end
end

Building.all.each do |building|
  Category.all.each do |category|
    10.times do |x|
      building.posts.create!(category: category,
			    postable: building,
			    user: building.users[(rand * 7).to_i],
			    title: Faker::Lorem.sentence(5),
			    body: Faker::Lorem.paragraphs(5).join("\n"))
    end
  end
end


Post.all.each do |post|
   urls =  []
   3.times do
     faked_photo = Faker::Avatar.image
     uploader = Cloudinary::Uploader.upload(faked_photo)
     urls << uploader['url']
   end
  post.send(:photo_urls=, urls, folder: Rails.env.to_s, use_filename: true, image_metadata: true)
end

User.all.each do |user|
  faked_photo = Faker::Avatar.image
  uploader = Cloudinary::Uploader.upload(faked_photo)
  user.avatar_url = uploader['url']
end


Post.all.each do |post|
  users = post.postable.users
  5.times do
    user = users[rand(users.count).to_i]
    post.comments.create(user: user, body: Faker::Lorem.paragraphs(5).join("\n") )
  end
end

Post.all.each do |post|
  users = post.postable.users
  post.comments.each do |comment|
    user = users[rand(users.count).to_i]
    5.times do
      Reply.create(user: user, parent_comment_id: comment.id, body: Faker::Lorem.paragraphs(1).join("\n") )
    end
  end
end
