class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :real_name, :street, :city, :state, :zipcode, :role
end


