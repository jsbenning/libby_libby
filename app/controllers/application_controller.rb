class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :authenticate_user!
  before_action :create_base_genres


  BASE_GENRES = [ "Religion", "Philosophy", "Paranormal and the Occult", "History", "Math, Science and Technology", "Literature/Poetry", \
    "Literary Criticism", "Foreign Language", "Children's", "Young Adult", "Sci-Fi/Fantasy", "Reference", "Art and Design", \
    "Fashion and Appearance", "Psychology and Self-Help", "Social Science", "Horror", "Romance", "Music", "Biography and Memoir", \
    "Travel and Transportation", "Ethnic Studies", "Nature and the Environment", "Gender Studies", "Legal Studies", \
    "Sports, Crafts and Hobbies", "Health and Medicine", "TV, Media and Film", "Humor", "Manga & Graphic Novels"]


  private 


  def create_base_genres
    if Genre.all.empty?
      BASE_GENRES.each do |genre|
        Genre.create!(name: genre)
      end
    end
  end

  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

end



 #arr = %w(9780374524524 9780553211757 9780553212167 9780142004234 9780226469409 9780140301335 9780142180310 9780679735793 9780965068994 9781439148952 9780140281606 9780374530662 9780812968064 9780811214131); 

#Book.all.each do |b|
 # b.isbn = arr.sample
 #b.save
#end


  
  
