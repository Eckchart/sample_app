class ApplicationMailer < ActionMailer::Base
  # todo: replace with actual email address when sending
  # emails in production
  default from: "user@realdomain.com"
  layout "mailer"
end
