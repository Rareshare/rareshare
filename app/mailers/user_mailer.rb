class UserMailer < ActionMailer::Base
  default from: "RareShare <no-reply@rare-share.com>"

  def approval_email(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: "Congratulations! Your account has been approved!"
  end

  def suspension_email(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: "Your account has been temporarily suspended."
  end
end