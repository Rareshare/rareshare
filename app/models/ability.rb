class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    alias_action :create, :read, :update, :destroy, :to => :crud

    bookings user
    booking_edits user
    booking_edit_requests user
    tools    user
    messages user
  end

  private

  def bookings(user)
    can :update_draft, Booking do |b|
      b.renter?(user) && b.draft?
    end

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

    can :owner_edit, Booking do |b|
      b.owner?(user) && b.can_owner_edit? && b.booking_edits.pending.empty?
    end

    can :request_edit, Booking do |b|
      b.owner?(user) && b.can_request_edit? && b.booking_edit_requests.pending.empty?
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

  def booking_edits(user)
    can :manage, BookingEdit do |b|
      b.booking.owner?(user) && b.pending?
    end

    can :respond, BookingEdit do |b|
      b.booking.renter?(user) && b.pending?
    end
  end

  def booking_edit_requests(user)
    can :manage, BookingEditRequest do |b|
      b.booking.owner?(user) && b.pending?
    end

    can :respond, BookingEditRequest do |b|
      b.booking.renter?(user) && b.pending?
    end
  end

  def tools(user)
    can :crud, Tool do |t|
      t.owned_by?(user)
    end

    can :read, Tool do |t|
      !user.new_record?
    end

    can :create, Tool do |t|
      !user.new_record?
    end

    can :book, Tool do |t|
      !t.owned_by?(user)
    end

    can :crud, Facility do |f|
      f.user == user
    end
  end

  def messages(user)
    can :read, UserMessage do |m|
      m.sender == user || m.receiver == user
    end
  end
end
