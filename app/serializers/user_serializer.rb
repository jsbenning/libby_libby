class UserSerializer < ActiveModel::Serializer
  attributes :id, :real_name, :street, :city, :state, :zipcode, :role
end


