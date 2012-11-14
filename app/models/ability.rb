class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.lessor?
      can :read, :all
    elsif user.lessee?
      can :read, :all
    else
      can :read, :all
    end
  end
end
