class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    # Admin access handled separately via admin-scoped controllers in ActiveAdmin.
    # can :manage, :all if user.admin?
    bookings user
    tools user
  end

  private

  def bookings(user)
    can :cancel, Booking do |b|
      b.can_cancel? && b.cancellable_by?(user)
    end

    can :read, Booking do |b|
      b.party?(user)
    end

    can :approve, Booking do |b|
      b.owner?(user) && b.can_approve?
    end

    can :deny, Booking do |b|
      b.owner?(user) && b.can_deny?
    end

    can :confirm, Booking do |b|
      b.owner?(user) && b.can_confirm?
    end

    can :finalize, Booking do |b|
      b.renter?(user) && b.can_finalize?
    end
  end

  def tools(user)
    can :manage, Tool do |t|
      t.owned_by? user
    end

    can :read, Tool do |t|
      !user.new_record?
    end

    can :create, Tool do |t|
      !user.new_record?
    end

    can :book, Tool do |t|
      !t.owned_by? user
    end
  end
end
