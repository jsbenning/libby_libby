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

  BASE_GENRES = [ "Religion", "Philosophy", "Paranormal and the Occult", "History", "Math, Science and Technology", "Literature/Poetry", \
    "Literary Criticism", "Foreign Language", "Children's", "Young Adult", "Sci-Fi/Fantasy", "Reference", "Art and Design", \
    "Fashion and Appearance", "Psychology and Self-Help", "Social Science", "Horror", "Romance", "Music", "Biography and Memoir", \
    "Travel and Transportation", "Ethnic Studies", "Nature and the Environment", "Gender Studies", "Legal Studies", \
    "Sports, Crafts and Hobbies", "Health and Medicine", "TV, Media and Film", "Humor", "Manga & Graphic Novels"]

  REAL_ISBNS = %w(9781617291692 9781593275990 9780786902033 9780520253971 9780060933760 9780553211757 9780374524524 9781597801584 9780679758945 9781439148952)


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





10.times do |index|
  # genre = Genre.first(offset: rand(Genre.count))


  Book.create!(user_id: @user1.id, title: Faker::Book.title,
    author_last_name: Faker::Name.last_name,
    author_first_name: Faker::Name.first_name,
    isbn: REAL_ISBNS[(rand(10))],
    condition: "good",
    description: Faker::Lorem.paragraph)

  end

  10.times do |index|

    Book.create!(user_id: @user2.id, title: Faker::Book.title,
    author_last_name: Faker::Name.last_name,
    author_first_name: Faker::Name.first_name,
    isbn: REAL_ISBNS[(rand(10))],
    condition: "fair",
    description: Faker::Lorem.paragraph)

  end

  10.times do |index|

    Book.create!(user_id: @user3.id, title: Faker::Book.title,
    author_last_name: Faker::Name.last_name,
    author_first_name: Faker::Name.first_name,
    isbn: REAL_ISBNS[(rand(10))],
    condition: "like new",
    description: Faker::Lorem.paragraph)

  end


  # BASE_GENRES.each do |genre|
  #   Genre.create!(name: genre)
  # end


  # Book.all.each do |book|
  #   genre_arr = BASE_GENRES.first(rand(BASE_GENRES.count))
  #   genre_arr.each do |gen|
  #     book.genres_attributes=({"index": genre_arr.index(gen)})
  #   end
  # end
