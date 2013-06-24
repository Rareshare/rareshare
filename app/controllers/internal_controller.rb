class InternalController < ApplicationController
  abstract!
  layout "internal"
  before_filter :authenticate_user!
  before_filter :tos_accepted?

  private

  def tos_accepted?
    redirect_to welcome_path unless current_user.tos_accepted?
  end
end
