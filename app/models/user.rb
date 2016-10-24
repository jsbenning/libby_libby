class User < ApplicationRecord
  has_many :books, inverse_of: :user
  # has_many :bookgenres, through: :books (not sure about this)
  accepts_nested_attributes_for :books
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
