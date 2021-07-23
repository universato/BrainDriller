class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@[herokuのアプリ名].herokuapp.com'
  layout 'mailer'
end
