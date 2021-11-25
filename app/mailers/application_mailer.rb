# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'brickyard@keffecttraining.com'
  layout 'mailer'
end
