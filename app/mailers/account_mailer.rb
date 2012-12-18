class AccountMailer < ActionMailer::Base
  default from: "from@example.com"

  def confirm_email(email, token)
    @token = token
     mail(to: email, subject: 'Account confirmation')
  end

  def send_invitation email, link, sender, message
    @link    = link
    @sender  = sender
    @message = message
    mail(to: email, subject: "Your friend #{sender} invite you")
  end

end
