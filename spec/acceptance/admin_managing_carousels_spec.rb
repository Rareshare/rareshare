require 'acceptance/acceptance_helper'

feature "Admin managing carousels" do
  let(:admin) { create(:user, admin: true) }

  # Will come back to testing later
  # There's Something obscure with factory relations
  #
  # scenario "Admin creates a carousel", js: true do
  #   tool = build(:tool)
  #   tool.save(validate: false)
  #
  #   login_as admin
  #   visit admin_carousels_path
  #   click_link 'New Carousel'
  #
  #   expect(page).to have_content(tool.display_name)
  #   choose('Tool')
  #   select(tool.display_name)
  # end
end