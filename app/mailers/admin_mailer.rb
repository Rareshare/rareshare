class AdminMailer < ActionMailer::Base
  default from: "RareShare <no-reply@rare-share.com>"

  def new_user_email(user_id)
    @user = User.find(user_id)
    mail to: User.admin.map(&:email).join(', '), subject: "New user registered"
  end
end