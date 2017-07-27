class Book < ApplicationRecord
  validates :title, :condition, presence: true

  scope :visible, -> { where(status: 'at_home')}
  scope :by_date, -> { order('created_at DESC, id DESC') }
  
  belongs_to :user, dependent: :destroy
  validates_presence_of :user
  has_and_belongs_to_many :genres 
  accepts_nested_attributes_for :genres
  

  def self.latest_titles
    self.by_date.visible.first(5)
  end

  def genres_attributes=(genre_attributes)
    genre_attributes.values.each do |genre_attribute|
      genre = Genre.find_or_create_by(genre_attribute)
      self.genres << genre
    end
  end

  def self.search(search, user)
    wildcard_search = "%#{search}%"
    if wildcard_search
      Book.where(:status => 'at_home').where.not(:user_id => user.id).where("title LIKE ? OR isbn LIKE ? OR author_last_name LIKE ?", wildcard_search, wildcard_search, wildcard_search)
    else
      Book.where(:status => 'at_home').where.not(:user_id => user.id)
    end
  end
  
end

