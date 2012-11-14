class AccountMailer < ActionMailer::Base
  default from: "from@example.com"

  def confirm_email(email, token)
     mail(to: email, subject: 'test') do |format|
       format.text { render text: "#{confirm_account_path(token)}" }
     end
  end

end
