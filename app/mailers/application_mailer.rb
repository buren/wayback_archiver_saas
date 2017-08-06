class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEFAULT_FROM_EMAIL', 'no-reply@waybackarchiver.com')
  layout 'mailer'
end
