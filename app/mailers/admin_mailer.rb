class AdminMailer < ActionMailer::Base
  default from: "RareShare <no-reply@rare-share.com>"

  def new_user_email(user_id)
    @user = User.find(user_id)

    User.admin.each do |admin|
      mail to: admin.email, subject: "New user registered"
    end
  end
end