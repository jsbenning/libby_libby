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

genres = Genre.create!([ {name: 'Literature'}, {name: 'History'}, {name: 'Religion'}, {name: 'Science'},
  {name: 'Appearance'}, {name: 'Cooking'}, {name: 'Travel'}, {name: 'Romance'}, {name: 'Art'}, 
  {name: 'Health'}, {name: 'Social Science'}, {name: 'Self-Help'}
 ])

@user1 = User.create!(email: Faker::Internet.email,
  password: "password123",
  real_name: Faker::Name.name,
  street: Faker::Address.street_address,
  city: Faker::Address.city,
  state: Faker::Address.state_abbr,
  zipcode: Faker::Address.zip)



100.times do |index|
  # genre = Genre.first(offset: rand(Genre.count))

  Book.create!(user_id: @user1.id, title: Faker::Book.title,
    author_last_name: Faker::Name.last_name,
    author_first_name: Faker::Name.first_name,
    isbn: Faker::Code.isbn,
    condition: "good",
    description: Faker::Lorem.paragraph)
    
  end









  # def change
  #   create_table :books do |t|
  #     t.integer :user_id
  #     t.string :title
  #     t.string :author_last_name
  #     t.string :author_first_name
  #     t.string :isbn
  #     t.string :condition
  #     t.text :description
  #     t.string :status, default: "at_home" # also "sent", "received"

  #     t.timestamps
  #   end
  # end

  # class CreateGenres < ActiveRecord::Migration[5.0]
  # def change
  #   create_table :genres do |t|
  #     t.string :name

  #     t.timestamps
  #   end
  # end

  #   def change
  #   create_table :users do |t|
  #     t.string :real_name
  #     t.string :street
  #     t.string :city
  #     t.string :state
  #     t.string :zipcode

  #     t.integer :user_rating, default: 4
  #     t.boolean :visible, default: true
  #     t.boolean :admin, default: false
  #     ## Database authenticatable
  #     t.string :email,              null: false, default: ""
  #     t.string :encrypted_password, null: false, default: ""

  #     ## Recoverable
  #     t.string   :reset_password_token
  #     t.datetime :reset_password_sent_at

  #     ## Rememberable
  #     t.datetime :remember_created_at

  #     ### Omniauthable
  #     t.string :provider
  #     t.string :uid

