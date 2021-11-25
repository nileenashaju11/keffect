# frozen_string_literal: true

class EmailActionMailerPreview < ActionMailer::Preview
  def send_email
    EmailActionMailer.with(action: Email.last).send_email
  end
end
