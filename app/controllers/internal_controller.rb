class InternalController < ApplicationController
  abstract!
  layout "internal"
  before_filter :authenticate_user!
end
