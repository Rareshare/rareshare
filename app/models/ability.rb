class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    logged_in_permissions unless user.nil?
  end

  def logged_in_permissions
    bookings
    booking_edits
    booking_edit_requests
    tools
    messages
    facilities
  end

  private

  def bookings
    can :update_draft, Booking do |b|
      b.renter?(user) && b.draft?
    end

    can :cancel, Booking do |b|
      b.can_cancel? && (b.renter?(user) || ( b.owner?(user) && ( b.confirmed? || b.finalized? ) ))
    end

    can :read, Booking do |b|
      b.party? user
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

    can :owner_edit, Booking do |b|
      b.owner?(user) && b.can_owner_edit?
    end

    can :request_edit, Booking do |b|
      b.owner?(user) && b.can_request_edit?
    end

    can :finalize, Booking do |b|
      b.renter?(user) && b.can_finalize?
    end

    can :begin, Booking do |b|
      b.owner?(user) && b.can_begin?
    end

    can :complete, Booking do |b|
      b.owner?(user) && b.can_complete?
    end
  end

  def booking_edits
    can :manage, BookingEdit do |b|
      b.booking_owner?(user) && b.pending?
    end

    can :respond, BookingEdit do |b|
      b.booking_renter?(user) && b.pending?
    end
  end

  def booking_edit_requests
    can :manage, BookingEditRequest do |b|
      b.booking_owner?(user) && b.pending?
    end

    can :respond, BookingEditRequest do |b|
      b.booking_renter?(user) && b.pending?
    end
  end

  def tools
    can :read, Tool
    can [:create, :update, :destroy], Tool, owner_id: user.id

    can :book, Tool do |t|
      !t.owned_by? user
    end
  end

  def messages
    can :read, UserMessage do |m|
      m.sender == user || m.receiver == user
    end
  end

  def facilities
    can :manage, Facility, user_id: user.id
  end
end
