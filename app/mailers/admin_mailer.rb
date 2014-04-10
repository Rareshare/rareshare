class AdminMailer < ActionMailer::Base
  default from: "RareShare <no-reply@rare-share.com>"

  def new_user_email(user_id)
    @user = User.find(user_id)
    mail to: "admin@rare-share.com, warris.bokhari@rare-share.com, adam.betts@rare-share.com", subject: "New user registered"
  end
end