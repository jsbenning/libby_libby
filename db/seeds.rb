# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'pry'

User.destroy_all
Book.destroy_all
Genre.destroy_all

BASE_GENRES = ["History", "Math and Science", "Fiction", "Foreign Language", "Children's", "Young Adult", "Sci-Fi/Fantasy", "Reference",\
 "Social Science", "Art, Design and Fashion", "Psychology and Self-Help", "Horror", "Romance", "Music", "Biography and Memoir", "Travel",\
  "Ethnic Studies", "Nature and the Environment", "Gender Studies", "Legal Studies", "Sports, Crafts and Hobbies", "Health and Medicine", "TV, Media and Film" ]


@user1 = User.create!(email: Faker::Internet.email,
  password: "password123",
  real_name: Faker::Name.name,
  street: Faker::Address.street_address,
  city: Faker::Address.city,
  state: Faker::Address.state_abbr,
  zipcode: Faker::Address.zip)

@user2 = User.create!(email: Faker::Internet.email,
  password: "password123",
  real_name: Faker::Name.name,
  street: Faker::Address.street_address,
  city: Faker::Address.city,
  state: Faker::Address.state_abbr,
  zipcode: Faker::Address.zip)

@user3 = User.create!(email: Faker::Internet.email,
  password: "password123",
  real_name: Faker::Name.name,
  street: Faker::Address.street_address,
  city: Faker::Address.city,
  state: Faker::Address.state_abbr,
  zipcode: Faker::Address.zip)





20.times do |index|
  # genre = Genre.first(offset: rand(Genre.count))
  

  Book.create!(user_id: @user1.id, title: Faker::Book.title,
    author_last_name: Faker::Name.last_name,
    author_first_name: Faker::Name.first_name,
    isbn: Faker::Code.isbn,
    condition: "good",
    description: Faker::Lorem.paragraph)
    
  end

  20.times do |index|

    Book.create!(user_id: @user2.id, title: Faker::Book.title,
    author_last_name: Faker::Name.last_name,
    author_first_name: Faker::Name.first_name,
    isbn: Faker::Code.isbn,
    condition: "fair",
    description: Faker::Lorem.paragraph)
    
  end

  20.times do |index|

    Book.create!(user_id: @user3.id, title: Faker::Book.title,
    author_last_name: Faker::Name.last_name,
    author_first_name: Faker::Name.first_name,
    isbn: Faker::Code.isbn,
    condition: "like new",
    description: Faker::Lorem.paragraph)
    
  end











