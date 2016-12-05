class Ability
  include CanCan::Ability

  def initialize(user)
   can :read, Book
   can :create, Book
   unless user.nil? 
     can :update, Book, { user_id: user.id }
   end
   if user.admin?
     can :manage, Book
     can :manage, User
   end
  end
end