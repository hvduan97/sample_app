class ApplicationMailer < ActionMailer::Base
  default from: Settings.email_mailer
  layout "mailer"
end
