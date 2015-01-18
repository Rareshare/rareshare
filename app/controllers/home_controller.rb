class HomeController < ApplicationController
  skip_before_filter :redirect_to_login, only: :test_error

  layout "home"

  def index
    @carousels = Carousel.active.decorate
  end

  def test_error
    raise TestError
  end
end