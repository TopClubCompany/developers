class AccountMailer < ActionMailer::Base
  default from: "from@example.com"

  def confirm_email(email, token)
    @token = token
     mail(to: email, subject: 'Account confirmation')
  end

end
