class HomeController < ApplicationController
  layout "home"

  def index
    @carousels = Carousel.active.decorate
  end
end
