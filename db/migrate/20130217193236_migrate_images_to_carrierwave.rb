class MigrateImagesToCarrierwave < ActiveRecord::Migration
  def up
    User.all.each do |user|
      if user.image_url.present?
        user.avatar = { tempfile: open(user.image_url), filename: "#{user.uid}.png" }
      end
    end
  end

  def down
  end
end
